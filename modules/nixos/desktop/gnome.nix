{
  config,
  lib,
  pkgs,
  ...
}: let
  # Fraction of the real finger movement that two-finger touchpad scrolling
  # sees. Lower is slower.
  touchpadScrollFactor = 0.3;
in {
  config = lib.mkIf (config.my.desktop.environment == "gnome") {
    services.desktopManager.gnome.enable = true;
    services.displayManager.gdm.enable = true;

    environment.systemPackages = with pkgs; [
      gnome-tweaks
    ];

    # GNOME has no touchpad scroll speed setting, so this libinput plugin (which
    # mutter loads at login) scales finger movement while exactly two fingers
    # are down. One-finger pointer motion and three/four-finger gestures are
    # untouched; two-finger pinch is scaled too.
    environment.etc."libinput/plugins/touchpad-scroll-speed.lua".text = ''
      libinput:register({1})

      local FACTOR = ${toString touchpadScrollFactor}

      libinput:connect("new-evdev-device", function(device)
        if not device:udev_properties().ID_INPUT_TOUCHPAD then
          return
        end

        local absinfos = device:absinfos()
        local range = {
          [evdev.ABS_MT_POSITION_X] = absinfos[evdev.ABS_MT_POSITION_X],
          [evdev.ABS_MT_POSITION_Y] = absinfos[evdev.ABS_MT_POSITION_Y],
        }
        if not (range[evdev.ABS_MT_POSITION_X] and range[evdev.ABS_MT_POSITION_Y]) then
          return
        end

        local slot = 0
        local touching = {} -- slot -> true while a finger is down
        local fingers = 0
        local axes = {} -- slot -> usage -> { real = <kernel value>, emitted = <scaled value> }

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
          local factor = fingers == 2 and FACTOR or 1

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
                for usage, a in pairs(axes[slot] or {}) do
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
              else
                local r = range[u]
                a.emitted = math.max(r.minimum, math.min(r.maximum, a.emitted + (v - a.real) * factor))
                a.real = v
              end
              table.insert(out, { usage = u, value = math.floor(a.emitted + 0.5) })
            else
              table.insert(out, { usage = u, value = v })
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
