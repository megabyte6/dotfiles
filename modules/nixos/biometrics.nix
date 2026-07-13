{...}: {
  services = {
    howdy = {
      enable = true;
      control = "sufficient";
      settings = {
        core = {
          abort_if_lid_closed = true;
          abort_if_ssh = true;
          detection_notice = false;
          disabled = false;
          no_confirmation = false;
          suppress_unknown = false;
          timeout_notice = true;
          use_cnn = false;
          workaround = "input";
        };
        debug = {
          end_report = false;
          gtk_stdout = false;
          verbose_stamps = false;
        };
        rubberstamps = {
          enabled = false;
          stamp_rules = "nod\t\t5s\t\tfailsafe     min_distance=12";
        };
        snapshots = {
          save_failed = false;
          save_successful = false;
        };
        video = {
          certainty = 3.5;
          dark_threshold = 80;
          device_format = "v4l2";
          device_fps = -1;
          device_path = "/dev/video2";
          exposure = -1;
          force_mjpeg = false;
          frame_height = -1;
          frame_width = -1;
          max_height = 320;
          recording_plugin = "opencv";
          rotate = 0;
          timeout = 4;
          warn_no_device = true;
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
