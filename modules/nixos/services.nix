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
        "--n-gpu-layers"
        "99"
        "--ctx-size"
        "24576"
        "--cache-type-k"
        "q8_0"
        "--cache-type-v"
        "q8_0"
        "--jinja"
      ];
    };
  };
}
