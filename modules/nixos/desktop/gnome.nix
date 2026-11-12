{
  config,
  lib,
  pkgs,
  ...
}: let
  # Fraction of the real finger movement that two-finger touchpad scrolling
  # sees. Lower is slower.
  touchpadScrollFactor = 0.5;
in {
  config = lib.mkIf (config.my.desktop.environment == "gnome") {
    services.desktopManager.gnome.enable = true;
    services.displayManager.gdm.enable = true;

    environment.systemPackages = with pkgs; [
      gnome-tweaks
    ];

    # GNOME has no touchpad scroll speed setting, so this libinput plugin (which
    # mutter loads at login) slows two-finger scrolling. It holds each new
    # two-finger gesture still for its first ~1.5 mm, classifies it as a scroll
    # (fingers move together) or a pinch (the gap between them changes), then
    # releases it at FACTOR speed for scrolls and full speed for pinches.
    # One-finger pointer motion and three/four-finger gestures are untouched.
    environment.etc."libinput/plugins/touchpad-scroll-speed.lua".text = ''
      libinput:register({1})

      local FACTOR = ${toString touchpadScrollFactor}
      -- How far (mm) the fingers move before the gesture is classified.
      local DECIDE_MM = 1.5

      local X, Y = evdev.ABS_MT_POSITION_X, evdev.ABS_MT_POSITION_Y

      libinput:connect("new-evdev-device", function(device)
        if not device:udev_properties().ID_INPUT_TOUCHPAD then
          return
        end

        local absinfos = device:absinfos()
        local range = { [X] = absinfos[X], [Y] = absinfos[Y] }
        if not (range[X] and range[Y]) then
          return
        end
        -- Device units per mm; guess a ~100 mm pad if the kernel doesn't say.
        local function units_per_mm(r)
          if r.resolution and r.resolution > 0 then
            return r.resolution
          end
          return math.max(1, (r.maximum - r.minimum) / 100)
        end
        local res = { [X] = units_per_mm(range[X]), [Y] = units_per_mm(range[Y]) }

        local function clamp(u, v)
          return math.max(range[u].minimum, math.min(range[u].maximum, v))
        end

        local slot = 0
        local touching = {} -- slot -> true while a finger is down
        local fingers = 0
        local axes = {} -- slot -> usage -> { real = <kernel value>, emitted = <scaled value> }
        -- Two-finger gesture state: nil (not two fingers), "pending",
        -- "scroll" or "pinch". `base` holds real positions when it started.
        local mode, base = nil, nil

        local function active_points()
          local pts = {}
          for s in pairs(touching) do
            local a = axes[s]
            if not (a and a[X] and a[Y]) then
              return nil
            end
            table.insert(pts, { slot = s, x = a[X].real / res[X], y = a[Y].real / res[Y] })
          end
          table.sort(pts, function(p, q) return p.slot < q.slot end)
          return #pts == 2 and pts or nil
        end

        local function gap(p, q)
          return math.sqrt((p.x - q.x) ^ 2 + (p.y - q.y) ^ 2)
        end

        device:connect("evdev-frame", function(_, frame, _)
          -- Pass 1: count the fingers that are down once this frame applies.
          local s = slot
          for _, ev in ipairs(frame) do
            if ev.usage == evdev.ABS_MT_SLOT then
              s = ev.value
            elseif ev.usage == evdev.ABS_MT_TRACKING_ID then
              local down = ev.value >= 0
              if down ~= (touching[s] == true) then
                fingers = math.max(0, fingers + (down and 1 or -1))
              end
              touching[s] = down or nil
            end
          end
          if fingers ~= 2 then
            mode, base = nil, nil
          elseif mode == nil then
            mode = "pending"
          end
          local factor = (mode == "pending" and 0) or (mode == "scroll" and FACTOR) or 1

          -- Pass 2: rewrite positions as offsets that grow at `factor` speed.
          local out = {}
          for _, ev in ipairs(frame) do
            local u, v = ev.usage, ev.value
            if u == evdev.ABS_MT_SLOT then
              slot = v
              table.insert(out, { usage = u, value = v })
            elseif u == evdev.ABS_MT_TRACKING_ID then
              table.insert(out, { usage = u, value = v })
              if v >= 0 then
                -- New touch in this slot: drop any offset left over from the
                -- last scroll so the reported position matches the finger again.
                -- Its first position report is taken as-is.
                for usage, a in pairs(axes[slot] or {}) do
                  a.fresh = true
                  if a.emitted ~= a.real then
                    a.emitted = a.real
                    table.insert(out, { usage = usage, value = a.real })
                  end
                end
              end
            elseif range[u] then
              axes[slot] = axes[slot] or {}
              local a = axes[slot][u]
              if a == nil then
                a = { real = v, emitted = v }
                axes[slot][u] = a
              elseif a.fresh then
                a.real, a.emitted, a.fresh = v, v, nil
              else
                a.emitted = clamp(u, a.emitted + (v - a.real) * factor)
                a.real = v
              end
              table.insert(out, { usage = u, value = math.floor(a.emitted + 0.5) })
            else
              table.insert(out, { usage = u, value = v })
            end
          end

          -- Classify a pending gesture once it has moved far enough.
          if mode == "pending" then
            local pts = active_points()
            if pts and not base then
              base = pts
            elseif pts then
              local cx = (pts[1].x + pts[2].x - base[1].x - base[2].x) / 2
              local cy = (pts[1].y + pts[2].y - base[1].y - base[2].y) / 2
              local moved = math.sqrt(cx * cx + cy * cy)
              local spread = math.abs(gap(pts[1], pts[2]) - gap(base[1], base[2]))
              if math.max(moved, spread) >= DECIDE_MM then
                mode = spread > moved and "pinch" or "scroll"
                local f = mode == "scroll" and FACTOR or 1
                -- Release the held movement at the chosen speed.
                for i, p in ipairs(pts) do
                  table.insert(out, { usage = evdev.ABS_MT_SLOT, value = p.slot })
                  for u, b in pairs({ [X] = base[i].x * res[X], [Y] = base[i].y * res[Y] }) do
                    local a = axes[p.slot][u]
                    a.emitted = clamp(u, a.emitted + (a.real - b) * f)
                    table.insert(out, { usage = u, value = math.floor(a.emitted + 0.5) })
                  end
                end
                table.insert(out, { usage = evdev.ABS_MT_SLOT, value = slot })
              end
            end
          end
          return out
        end)
      end)
    '';

    environment.gnome.excludePackages = with pkgs; [
      # Already installed as flatpaks (flatpak.nix), which stay the same across
      # every desktop.
      decibels
      gnome-calculator
      gnome-characters
      gnome-connections
      gnome-font-viewer
      gnome-logs
      gnome-text-editor
      loupe
      papers
      simple-scan
      snapshot

      # Flatpaks are managed declaratively with uninstallUnmanaged, so anything
      # installed through GNOME Software gets removed on the next rebuild.
      gnome-software
    ];
  };
}
