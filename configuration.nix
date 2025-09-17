# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  #boot.loader.systemd-boot.secureBoot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = ["uinput" "kvm-intel"];
  boot.lanzaboote = {
          enable = true;
          pkiBundle = "/var/lib/sbctl";
  };
  
  hardware.uinput.enable = true;
  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = with pkgs; [
    vpl-gpu-rt
    libvdpau-va-gl
    intel-media-driver
    intel-compute-runtime
  ];
  hardware.opengl.driSupport32Bit = true;

  systemd.services.kanata-internalKeyboard.serviceConfig = {
	  SupplementaryGroups = [
		  "input"
		  "uinput"
	  ];
  };


  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "stemzzz"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  hardware.bluetooth = {
   enable = true;
  };
  
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Set your time zone.
  time.timeZone = "Africa/Lagos";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.wayland = true;
  services.desktopManager.gnome.enable = true;
  services.tailscale.enable = true;

  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ezechukwu69 = {
    isNormalUser = true;
    description = "Ezechukwu Ojukwu";
    extraGroups = [ "networkmanager" "kvm" "wheel" "uinput" "input" "video" "docker" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  users.groups.uinput = { };

  # Install firefox.
  programs.firefox.enable = true;

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };
 
  programs.zsh.enable = true;

  programs.hyprland = {
    enable = true;
      xwayland = {
        enable = true;
      };
  };

  programs.hyprlock = {
    enable = true;
  };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  environment.variables = {
    XKB_CONFIG_ROOT="${pkgs.xkeyboard-config}/share/X11/xkb";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    curl
    pkg-config
    xdg-desktop-portal-gnome
    qt6.full
    bash
    gnome-keyring
    clang
    dunst
    cmake
    ninja
    gtk3
    wget
    kanata
    rustdesk
    matugen
    docker-compose
    glibc
    hypridle
    sbctl
    hyprcursor
    hyprshot
    mesa
    xwayland-satellite
    vulkan-tools
    wl-clipboard
    protobuf
    xkeyboard-config
    hyprpanel
    hyprsunset
    hyprpicker
    hyprpolkitagent
    waybar
    killall
    wayland
    wayland-protocols
    wayland-scanner
    libnotify
    mako
    rustup
    gcc
    toilet
    ffmpeg
    xorg.libXext
    xorg.libX11
    qemu_kvm
    tofi
    libvirt
    virt-manager
    glib
    zlib
    ncurses
# android studio
    alsa-lib
    dbus
    expat
    libbsd
    libpulseaudio
    libuuid
    xorg.libXi
    xorg.libxcb
    libxkbcommon
    xorg.xcbutilwm
    openssl
    xorg.xcbutilrenderutil
    xorg.xcbutilkeysyms
    xorg.xcbutilimage
    xorg.xcbutilcursor
    xorg.libICE
    xorg.libSM
    xorg.libxkbfile
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXfixes
    libGL
    libdrm
    libpng
    nspr
    nss_latest
    systemd
#end
    vulkan-headers
    vulkan-loader
  ];

  virtualisation.docker = {
	  enable = true;
  };


  virtualisation.libvirtd = {
	  enable = true;
  };

  programs.niri = {
    enable = true;
  };

  programs.dconf.enable = true;

  programs.nix-ld.enable = true;

  programs.nix-ld.libraries = with pkgs; [

# Add any missing dynamic libraries for unpackaged programs

# here, NOT in environment.systemPackages

  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  environment.etc."kanata/kanata.kbd".source = ./dotfiles/kanata/config.kbd;

  services.flatpak.enable = true;
  services.teamviewer.enable = true;

  services.hypridle = {
	enable = true;
  };

  services.kanata = {
	  enable = true;
	  keyboards = {
		  "main" = {
			  configFile = "/etc/kanata/kanata.kbd";
		  };
	  };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 53317 ];
  # networking.firewall.allowedUDPPorts = [ 53317 ];
  # networking.firewall.allowedUDPPortRanges = [
  #     { from = 53316; to = 53318; }
  #   ];
  #
  #   # Enable multicast
  # networking.firewall.extraCommands = ''
  #     iptables -A nixos-fw -p udp --dport 53317 -j ACCEPT
  #     iptables -A nixos-fw -p udp -m multicast --dst-type MULTICAST -j ACCEPT
  #   '';
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
      userServices = true;
    };
  };

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
