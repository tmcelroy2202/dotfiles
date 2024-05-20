# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import ( builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };


 # systemd.user.services.waybar = {
 #    Unit = {
 #      Description = "Wayland bar for Sway and Wlroots based compositors";
 #      PartOf = [ "graphical-session.target" ];
 #    };
 #    Install = {
 #      WantedBy = [ "graphical-session.target" ];
 #    };
 #    Service = {
 #      Type = "simple";
 #      ExecStart = "/home/tommy/.nix-profile/bin/waybar";
 #      RestartSec = 5;
 #      Restart = "always";
 #    };
 #  };

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    config.credential.helper = "libsecret";

  };


  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;
  # mullvad-vpn = {
  #   enable = true;
    
  # };
    
  qt = {
    enable = true;
    platformTheme = "qt5ct";
    # style = "adwaita-dark";
  };


  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.sway}/bin/sway";
        user = "tommy";
      };
      default_session = initial_session;
    };
  };


  security.polkit.enable = true;

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

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

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tommy = {
    isNormalUser = true;
    description = "tommy";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.displayManager.gdm.wayland = false;
  # services.xserver.desktopManager.plasma5.enable = true;
  catppuccin.flavour = "mocha";

  # gtk.catppuccin.enable = true;
  
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      mako
      grim
      slurp
      alacritty
      dmenu
      swaybg
      acpi
      autotiling-rs
      fastfetch
      rofi
      nil
      gnome.gnome-keyring
      feh
      libsForQt5.qt5ct
      rbw
      iamb
    ];
    extraSessionCommands = ''
      export SOL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
      exec autotiling-rs

    '';
  };

  services.gnome.gnome-keyring.enable = true;

  programs.zsh.shellAliases = {
    nixos-rebuild = "sudo nixos-rebuild switch --flake ~/.dotfiles/";
    vi = "hx";
    lock = "swaylock -c 101010";
  };

  programs.waybar.enable = true;
  programs.zsh.enable = true;
  programs.zsh.ohMyZsh = { 
    enable = true;
    plugins = ["git"];
  };
  users.defaultUserShell = pkgs.zsh;
  users.users.tommy.shell = pkgs.zsh;
 
  # Audio
  nixpkgs.config.pulseaudio = true;
  hardware.pulseaudio.support32Bit = true;    ## If compatibility with 32-bit applications is desired.
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };
  
  environment.variables.EDITOR = "hx";
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    foot
    wmenu
    mullvad-vpn
    upower
    librespeed-cli
    gh
    syncthing
    thefuck
    swaylock
    catppuccin-kvantum
    libsForQt5.qtstyleplugins
    # obsidian
    logseq
    grim
    slurp
    xfce.thunar
    swappy
    gh
    nh
  ];


  environment.sessionVariables = {
    # QT_STYLE_OVERRIDE = "adwaita_dark";
    QT_QPA_QTPLATFORMTHEME = "qt5ct";
    FLAKE = "/home/tommy/.dotfiles";
  };

  services.syncthing.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

#   programs.bash.promptInit =  ''

# PS1='\[\e[38;5;197m\]>\[\e[38;5;156m\]>\[\e[38;5;185m\]>\[\e[0m\] 📁 \[\e[38;5;75m\]\W\[\e[0m\] '
# '';

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  fonts.packages= with pkgs; [ fira-code-nerdfont ];

  # security = {
  #   pam.services.login = {
  #     enableKwallet = true;
  #   };
  # };

  # stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

  # stylix.image = ./catppuccin_triangle.png;
  # stylix.polarity = "dark";

  # stylix.cursor.package = pkgs.bibata-cursors;
  # stylix.cursor.name = "Bibata-Modern-Classic";

  # stylix.fonts = {
  #   serif = {
  #     package = pkgs.nerdfonts;
  #     name = "FiraCode Nerd Font Mono";
  #   };
  #   sansSerif = {
  #     package = pkgs.nerdfonts;
  #     name = "FiraCode Nerd Font Mono";
  #   };
  #   monospace = {
  #     package = pkgs.nerdfonts;
  #     name = "FiraCode Nerd Font Mono";
  #   };
  # };



  

  

}
