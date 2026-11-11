{
  config,
  pkgs,
  ...
}: {
  programs.binary-ninja = {
    enable = true;
    package = pkgs.binary-ninja.bundled-qt-fhs.personal-wayland;
  };

  # Keep the installer zip alive as long as this generation exists
  # (the FHS variant wraps the real package, exposed as `unwrapped`)
  system.extraDependencies = let
    pkg = config.programs.binary-ninja.package;
  in [(pkg.unwrapped or pkg).src];
}
