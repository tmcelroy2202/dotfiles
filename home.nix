{ config, pkgs, inputs, lib, ... }:

# {
#   home.username = "tommy";
#   home.homeDirectory = "/home/tommy/";
#   home.stateVersion = "23.11";
#   programs.home-manager.enable = true;
# }

{
  home.username = "tommy";
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
  home.packages = [ 
    pkgs.btop
    pkgs.firefox
    pkgs.helix
    pkgs.sway
    pkgs.waybar
    pkgs.zsh
    pkgs.alacritty
    pkgs.nheko
    pkgs.catppuccin
    pkgs.foot
    pkgs.rbw
    pkgs.ranger
  ];

  programs.ranger = {
    enable = true;
    mappings = {
      "xc" = "shell wl-copy < %f";
    };
  };

  # programs.helix = {
  #   enable = true;
  #   settings = {
  #     theme =  "catppuccin_mocha";
  #     editor = {
  #       line-number = "relative";
  #     };
  #   };
  #   # languages = [{
  #   #   name = "markdown";
  #   #   file-types = ["md"];
  #   #   language-servers = ["mdpls"];
  #   # }];
    

  # };
  programs.foot = {
    enable = true;
    settings = {
        main = {
            font = "Fira Code Nerd Font:size=11:line-height=16px";
        };
        colors = {
            foreground = "d9e0ee";
            background = "292a37";
            ## Normal/regular colors (color palette 0-7)
            regular0="303241";  # black
            regular1="ec6a88";
            regular2="3fdaa4";
            regular3="efb993";
            regular4="3fc6de";
            regular5="b771dc";
            regular6="6be6e6";
            regular7="d9e0ee";

            bright0="393a4d"; # bright black
            bright1="e95678"; # bright red
            bright2="29d398";# bright green
            bright3="efb993";# bright yellow
            bright4="26bbd9";
            bright5="b072d1";# bright magenta
            bright6="59e3e3";# bright cyan
            bright7="d9e0ee";# bright white
        };
    };
  };
  programs.nheko = {
    enable = true;
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = { 
        normal = {
          family =  "Fira Code Nerd Font";
        };
      
      };
      live_config_reload = false;
    

      colors = {
        # Default colors
        primary = {
          background =  "#1e1e2e";
          foreground =  "#cdd6f4";
        };

        # Normal colors
        normal = {
          black =    "#6c7086";
          red =      "#f38ba8";
          green =    "#a6e3a1";
          yellow =   "#f9e2af";
          blue =     "#89b4fa";
          magenta =  "#cba6f7";
          cyan =     "#94e2d5";
          white =    "#bac2de";
        };

        # Bright colors
        bright = {
          black =    "#6c7086";
          red =      "#f5c2e7";
          green =    "#a6e3a1";
          yellow =   "0xffb378";
          blue =     "0x65b2ff";
          magenta =  "0x906cff";
          cyan =     "0x63f2f1";
          white =  "0xa6b3cc";
        };
        hints = {
          start.foreground =  "#1E1E2E";
          end.foreground =  "#1E1E2E";
        };
      };
    };
  };
    
  
  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion.enable= true;
    enableCompletion = true;
    # dotDir = ".dotfiles";
    oh-my-zsh.enable = true;
    oh-my-zsh.theme =  "wedisagree";
    initExtra = ''
      eval $(thefuck --alias)
      export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5'
      set -o vi
      export PATH=$PATH:/home/tommy/.cargo/bin
    '';
  };

  # packageOverrides = pkgs: {
  #   nur = import ( builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
  #     inherit pkgs;
  #   };
  # };

  programs.firefox = { 
    enable = true;
    
    profiles.tommy = {
      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        bitwarden
        ublock-origin
        tridactyl
        darkreader
        libredirect
      ];
      userChrome = builtins.readFile ./userChrome.css;
      
      settings = {
        "browser.bookmarks.showMobileBookmarks" = true; # Mobile bookmarks
        "browser.download.useDownloadDir" = false; # Ask for download location
        "browser.in-content.dark-mode" = true; # Dark mode
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false; # Disable top stories
        "browser.newtabpage.activity-stream.feeds.sections" = false;
        "browser.newtabpage.activity-stream.feeds.system.topstories" = false; # Disable top stories
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false; # Disable pocket
        "extensions.pocket.enabled" = false; # Disable pocket
        "media.eme.enabled" = true; # Enable DRM
        "media.gmp-widevinecdm.visible" = true; # Enable DRM
        "media.gmp-widevinecdm.enabled" = true; # Enable DRM
        "signon.autofillForms" = false; # Disable built-in form-filling
        "signon.rememberSignons" = false; # Disable built-in password manager
        "ui.systemUsesDarkTheme" = true; # Dark mode
        "browser.startup.homepage" = "moz-extension://06829059-8a6f-4e51-b07a-6e5481f0a49b/static/newtab.html";
      };
      search.engines = {
          "websurfx" = {
              urls = [{ template = "https://websurfx.pp.ua/search?q={searchTerms}"; }];
          };
      };
      search.default = "websurfx";
	
    };
    nativeMessagingHosts = [
      pkgs.tridactyl-native
    ];
    

    # with pkgs.nur.repos.rycee.firefox-addons; [
    #   tridactyl
    #   ublock
    #   dark-reader
    # ]
    
  };

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      # Use kitty as default terminal
      terminal = "alacritty"; 
      startup = [
        {command = "autotiling-rs";}
        # Launch Firefox on start
        # {command = "firefox";}
        # {command = "exec /home/tommy/.nix-profile/bin/waybar";}
	{command = "swaymsg workspace number 1";}
  {command = "swaylock -c 101010";}
      ];
      window.titlebar = false;
      keybindings = rec {
        "Mod4+f" = ''exec firefox'';
        "Alt+space"= ''exec rofi -config /home/tommy/.dotfiles/rofi/theme/config1.rasi -show drun'';
        "Mod4+s" = ''exec grim -g "$(slurp)" - | wl-copy'';
        "Mod4+Shift+s" = ''exec grim -g "$(slurp)" - | swappy -f -'';
        "Mod4+tab" = ''focus next'';
        "XF86AudioRaiseVolume" =  "exec --no-startup-id pamixer -i 5";
        "XF86AudioLowerVolume" =  "exec --no-startup-id pamixer -d 5";
        "XF86AudioMute" =  "exec --no-startup-id pamixer -t";
        "Mod4+Shift+tab" = ''focus prev'';
        "Mod4+return" = ''exec alacritty'';
        "Mod4+c" = ''kill'';
        "Mod4+1" = ''workspace number 1'';
        "Mod4+2" = ''workspace number 2'';
        "Mod4+3" = ''workspace number 3'';
        "Mod4+4" = ''workspace number 4'';
        "Mod4+5" = ''workspace number 5'';
        "Mod4+6" = ''workspace number 6'';
        "Mod4+7" = ''workspace number 7'';
        "Mod4+8" = ''workspace number 8'';
        "Mod4+9" = ''workspace number 9'';
        "Mod4+0" = ''workspace number 10'';
        "Mod4+Shift+1" = ''move container to workspace number 1'';
        "Mod4+Shift+2" = ''move container to workspace number 2'';
        "Mod4+Shift+3" = ''move container to workspace number 3'';
        "Mod4+Shift+4" = ''move container to workspace number 4'';
        "Mod4+Shift+5" = ''move container to workspace number 5'';
        "Mod4+Shift+6" = ''move container to workspace number 6'';
        "Mod4+Shift+7" = ''move container to workspace number 7'';
        "Mod4+Shift+8" = ''move container to workspace number 8'';
        "Mod4+Shift+9" = ''move container to workspace number 9'';
        "Mod4+Shift+0" = ''move container to workspace number 10'';
        "Mod4+h" = ''focus left'';
        "Mod4+l" = ''focus right'';
        "Mod4+k" = ''focus up'';
        "Mod4+j" = ''focus down'';
        "Mod4+shift+h" = ''resize shrink width 10px'';
        "Mod4+shift+l" = ''resize grow width 10px'';
        "Mod4+shift+k" = ''resize shrink height 10px'';
        "Mod4+shift+j" = ''resize grow height 10px'';
      };

      # colors.focused = { border = "#bd93f9"; childBorder = "#bd93f9"; background = "#bd93f9"; text = "ffffff"; indicator = "#00ff00";};
      bars = [{
        "command" = "exec /home/tommy/.nix-profile/bin/waybar";
        "statusCommand" = "exec /home/tommy/.nix-profile/bin/waybar";        
        }];
    };

    
  };


programs.waybar = { 
  enable = true;
  settings = rec { 
    mainbar = rec { 
      position = "bottom";
      modules-left = ["sway/workspaces" "sway/mode"];
      modules-center = [];
      modules-right = ["pulseaudio" "clock" "battery" "network"];
      network.format = "{essid}";
      clock.format = "{:%I:%M %Y - %m %d}";
    };
  };
  # style = ''  * {    border: none;    border-radius: 0;    font-family: Source Code Pro;  }  window#waybar {    background: #16191C;    color: #bd93f9;  }  #workspaces button {    padding: 1 5px;  }'';

  # style = rec ''  * {    
  #      border: none;
  #      border-radius: 0;
  #      font-family: Source Code Pro;
  #      }
  #      window#waybar {
  #         background: #16191C;    
  #         color: #bd93f9;
  #      }  
  #     #workspaces button {
  #         padding: 1 5px;  
  #     }'';

  style = ''

    * {
      font-size: 12px;
      font-family: Source Code Pro, "Font Awesome 6 Free";
      font-weight: bold;
      border-radius: 2px;
      border: none;
      margin: 0px;
      padding: 0px;
    }

    tooltip {
      background: #282a36;
    }

    window#waybar {
      /* background: transparent; */
      background: #282a36;
      border-bottom: 2px solid #16191C;
    }

    window#waybar.solo #window {
      color: #ff5555;
    }

    window#waybar.tiled #window {
      color: #ff5555;
      
    }

    * :hover {
      box-shadow: none;
      text-shadow: none;
      border: none;
      background: transparent;
    }

    .modules-left,
    .modules-center,
    .modules-right {
      border-bottom: 2px solid #16191C;
    }

    .modules-left,
    .modules-center {
      background: #282a36;
    }

    .modules-left {
      padding: 0 5px;
    }

    #clock { 
      color: #f1fa8c;
      padding: 0 5px;
    }
    #custom-medialeft,
    #custom-media,
    #custom-mediaright,
    #temperature,
    #custom-fan,
    #network
    #battery {
      color: #bd93f9;
      margin: 0 15px 0 5px;
      padding: 0 5px;
      background: #282a36;
    }

    #pulseaudio {
      color: #f38ba8
    }

    #network {
      color: #bd93f9;
      margin: 0 10px 0 5px;
    }
    #battery {
      color: #bd93f9;
      margin: 0 15px 0 5px;
    }

    #clock {
      border: none;
    }

    #workspaces button {
      color: #ffffff;
    }

    #workspaces button.active {
      color: #bd93f9;
    }

    #workspaces button.focused {
        background: #4c566a;
        border-bottom: 3px solid #bd93f9;
    }

    #custom-media {
      margin: 0;
      padding: 0;
      border-left-style: none;
      border-right-style: none;
      border-radius: 0;
    }
    #custom-medialeft {
      padding: 0 5px;
      border-radius: 2px 0 0 2px;
      border-right-style: none;
      margin: 0 0 0 5px;
    }
    #custom-mediaright {
      padding: 0 5px;
      border-radius: 0 2px 2px 0;
      border-left-style: none;
      margin: 0 5px 0 0;
    }

    #battery {
      margin: 0 5px 0 5px;
    }

    #battery.warning {
      color: #ffb86c;
    }
    #battery.critical {
      color: #ff5555;
    }
    #battery.charging {
      color: #50fa7b;
    }
  '';
  # style = ''  * {#network: #bd93f9;}'';
};


  dconf.settings = {
    # "org/gnome/desktop/background" = {
    #   picture-uri-dark = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";
    # };
    "org/gnome/desktop/interface" = {
      color-scheme =  "prefer-dark";
    };
  };

  xdg.enable = true;
  # stylix.targets.gtk.enable =false;

  gtk = {
    enable = true;
    catppuccin.enable =  true;
    # theme = {
    #   name = "catppuccin-mocha";
    #   package = pkgs.catppuccin-gtk;
    # };
  };

  # qt = {
  #   enable = true;
  #   platformTheme.name = "adwaita";
  #   style.name = "adwaita-dark";
  #   # style = "catpuccin-mocha";
  # };

  # config = lib.mkIf config.stylix.targets.kde.enable {
  #   qt = {
  #     enable = true;
  #     style.name = "breeze";
  #   };
  # };

  # qt5 = {
  #   enable = true;
  #   style = lib.mkForce "gtk2";
  #   platformTheme = lib.mkForce "gtk2";
  # };


  services.gnome-keyring.enable = true;

  home.file.".tridactylrc".source = ./tridactylrc;
  home.file.".config/iamb/config.toml".source = ./iamb/config.toml;
  # home.file.".config/joplin/userchrome.css".source = ./joplin/userchrome.css;
  # home.file.".config/joplin/userstyle.css".source = ./joplin/userstyle.css;
  home.file.".config/joplin/userchrome.css".source = config.lib.file.mkOutOfStoreSymlink /home/tommy/.dotfiles/joplin/userchrome.css;
  home.file.".config/joplin/userstyle.css".source = config.lib.file.mkOutOfStoreSymlink /home/tommy/.dotfiles/joplin/userstyle.css;
  home.file.".config/helix/config.toml".source = config.lib.file.mkOutOfStoreSymlink /home/tommy/.dotfiles/helix/config.toml;
  home.file.".config/helix/languages.toml".source = config.lib.file.mkOutOfStoreSymlink /home/tommy/.dotfiles/helix/languages.toml;
  home.file.".config/xournalpp/palette.gpl".source = config.lib.file.mkOutOfStoreSymlink /home/tommy/.dotfiles/xournal/palette.gpl;
  home.file.".config/xournalpp/settings.xml".source = config.lib.file.mkOutOfStoreSymlink /home/tommy/.dotfiles/xournal/settings.xml;
  home.file.".cargo/bin/mdpls".source = config.lib.file.mkOutOfStoreSymlink /home/tommy/.dotfiles/mdpls/mdpls;

  programs.git = {
    enable = true;
    userEmail = "tommy.a.mcelroy@gmail.com";
    userName = "tmcelro2202";
  };


  programs.rbw = {
    enable = true;
    settings = {
      base_url = "https://vw.gamingjones.gay";
      email = "tommy.a.mcelroy@gmail.com";
      pinentry = pkgs.pinentry-gnome3;
    };
  };
  
}
