{config, ...}: {
  services = {
    howdy = {
      enable = true;
      control = "sufficient";
      settings = {
        core.use_cnn = true;
        video = {
          certainty = 3.5;
          dark_threshold = 80;
        };
      };
    };

    linux-enable-ir-emitter.enable = true;
  };

  # Restrict Howdy to interactive login only
  security.pam.howdy.enable = false;
  security.pam.services.login = {
    howdy.enable = true;

    # Run Howdy after the password check instead of before it, so submitting a
    # password never spins up the camera; the face scan only happens on the
    # fall-through, i.e. when the password box was empty.
    rules.auth.howdy.order = config.security.pam.services.login.rules.auth.unix.order + 100;
  };
}
