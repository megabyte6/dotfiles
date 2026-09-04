{...}: {
  services = {
    howdy = {
      enable = true;
      control = "sufficient";
      settings = {
        core = {
          use_cnn = true;
          workaround = "input";
        };
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
  security.pam.services.login.howdy.enable = true;
}
