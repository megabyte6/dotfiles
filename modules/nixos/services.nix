{pkgs, ...}: {
  services = {
    # Printing via CUPS
    printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
      ];
    };
    # Network printer/service discovery
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    # Trash and remote mounts for Nautilus
    gvfs.enable = true;

    flatpak.enable = true;

    llama-cpp = {
      enable = true;
      package = pkgs.unstable.llama-cpp;
      port = 8033;
      modelsDir = "/srv/llama-cpp/models/";
      extraFlags = [
        # GPU offload is deliberately not configured (no --n-gpu-layers). With it
        # unset, --fit (on by default) checks free VRAM at load time and places
        # any layers that don't fit in system RAM instead of failing to load.

        # Keep at most two models loaded; requesting a third unloads the least
        # recently used one first (default is 4, which can exhaust VRAM)
        "--models-max"
        "2"
        # Unload the model after 10 minutes without requests to free VRAM;
        # it is reloaded automatically on the next request
        "--sleep-idle-seconds"
        "600"

        # Context window in tokens. Fixed so --fit offloads layers to RAM
        # rather than shrinking the context when VRAM is tight
        "--ctx-size"
        "24576"
        # Store the KV cache as 8-bit instead of 16-bit, roughly halving its
        # memory use with negligible quality loss. A quantized V cache
        # requires flash attention, which is enabled automatically (-fa auto)
        "--cache-type-k"
        "q8_0"
        "--cache-type-v"
        "q8_0"
      ];
    };
  };
}
