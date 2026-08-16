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
  security.pam.services = {
    chfn.howdy.enable = false;
    chpasswd.howdy.enable = false;
    chsh.howdy.enable = false;
    cups.howdy.enable = false;
    dms-greeter.howdy.enable = false;
    greetd.howdy.enable = false;
    groupadd.howdy.enable = false;
    groupdel.howdy.enable = false;
    groupmems.howdy.enable = false;
    groupmod.howdy.enable = false;
    login.howdy.enable = true;
    passwd.howdy.enable = false;
    polkit-1.howdy.enable = false;
    runuser.howdy.enable = false;
    runuser-l.howdy.enable = false;
    su.howdy.enable = false;
    sudo.howdy.enable = false;
    swaylock.howdy.enable = false;
    systemd-run0.howdy.enable = false;
    systemd-user.howdy.enable = false;
    useradd.howdy.enable = false;
    userdel.howdy.enable = false;
    usermod.howdy.enable = false;
    vlock.howdy.enable = false;
  };
}
