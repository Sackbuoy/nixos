# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  lib,
  inputs,
  ...
}: let
  disk1 = "/var/lib/plexmediaserver/disk1";
  disk2 = "/var/lib/plexmediaserver/disk2";
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/system/ly.nix
    ../../modules/system/gaming.nix
    ./networking.nix
  ];

  # hyprland "must haves"
  security = {
    polkit.enable = true;
    pam.services.hyprlock = {};
  };

  services.xserver.enable = true;
  xdg = {
    mime.defaultApplications = {
      "text/html" = "zen.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "x-scheme-handler/about" = "zen.desktop";
      "x-scheme-handler/unknown" = "zen.desktop";
    };
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
      ];
      config.common = {
        default = "gnome";
        "org.freedesktop.impl.portal.FileChooser" = "gtk";
      };
    };
  };

  programs.hyprland = {
    enable = true;
    # withUWSM  = true; # "recommended" but breaks hypr utilities
  };

  services.displayManager.sessionPackages = [pkgs.niri];
  programs.niri.enable = true;
  programs.niri.package = pkgs.niri;

  services.displayManager.defaultSession = "niri";

  services.upower.enable = true;

  services.fwupd.enable = true;

  programs.nix-index-database.comma.enable = true;

  # In your configuration.nix
  systemd.services.fix-network-after-suspend = {
    description = "Fix network after suspend";
    wantedBy = ["suspend.target"];
    after = ["suspend.target"];
    script = ''
      ${pkgs.systemd}/bin/systemctl restart NetworkManager
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  fonts.packages = [
    pkgs.maple-mono.NF
    pkgs.nerd-fonts.symbols-only
  ];

  nix = {
    # package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # anything in flatpak i want should be available
  # in unstable, and it will run better
  services.flatpak.enable = false;

  services.power-profiles-daemon.enable = false;
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
    wireplumber.extraConfig.bluetoothEnhancements = {
      "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
        "bluez5.roles" = [
          "hsp_hs"
          "hsp_ag"
          "hfp_hf"
          "hfp_ag"
        ];
      };
    };
  };

  users.defaultUserShell = pkgs.zsh;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  virtualisation = {
    docker.enable = false; # use podman
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sackbuoy = {
    isNormalUser = true;
    description = "cameron";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
  };

  nix.settings.trusted-users = ["root" "sackbuoy"];

  programs.fish = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
  };

  # Install firefox.
  programs.firefox.enable = true;

  # enable blueman gui
  services.blueman.enable = true;

  # Secret storage for Chromium-based browsers (Brave, etc.)
  environment.sessionVariables.KWALLET_PAM_LOGIN = "1";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true; # install with flatpak

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    vim
    tmux
    ripgrep
    libgcc
    tailscale
    hyprpanel # this doesn't belong here but its the only place it works
    libnotify
    glib
    libcap
    lsof

    # formatting
    alejandra

    # kwallet
    kdePackages.kwallet
    kdePackages.kwalletmanager
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  services.tailscale.enable = true;

  # Gaming configuration is in ../../modules/system/gaming.nix

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # garbage collection. Deletes builds older than 30d
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = ["*"];
        settings = {
          main = {
            capslock = "overload(meta, esc)";
            esc = "overload(esc, capslock)";
          };
        };
      };
    };
  };

  services.rpcbind.enable = true;

  services.open-webui = {
    enable = true;
    package = pkgs.open-webui; # Use stable version (e.g., from nixos-24.11 or later)
    environment = {
      ANONYMIZED_TELEMETRY = "False";
      DO_NOT_TRACK = "True";
      SCARF_NO_ANALYTICS = "True";
      OLLAMA_API_BASE_URL = "http://10.0.0.55:11434/api";
      OLLAMA_BASE_URL = "http://10.0.0.55:11434";
    };
  };

  # Mount the NFS share
  # fileSystems = {
  #   "${disk1}" = {
  #     device = "homelab:${disk1}";
  #     fsType = "nfs";
  #     options = ["x-systemd.requires=tailscaled.service" "x-systemd.automount" "noauto" "noatime" "rw" "bg" "_netdev" "nofail"];
  #     depends = ["tailscaled.service"];
  #   };
  #   "${disk2}" = {
  #     device = "homelab:${disk2}";
  #     fsType = "nfs";
  #     options = ["x-systemd.requires=tailscaled.service" "x-systemd.automount" "noauto" "noatime" "rw" "bg" "_netdev" "nofail"];
  #     depends = ["tailscaled.service"];
  #   };
  # };
}
