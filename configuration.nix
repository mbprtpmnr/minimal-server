{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.forceInstall = true;
  boot.loader.timeout = 10;

  networking.hostName = "nixos-server";
  networking.usePredictableInterfaceNames = false;
  networking.enableIPv6 = true;

  time.timeZone = "Europe/Bucharest";

  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";

  nix = {
    useSandbox = true;
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    binaryCaches = [
      "https://cache.nixos.org"
      "https://cachix.cachix.org"
      "https://nix-community.cachix.org"
    ];
    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    trustedUsers = [ "root" "mbprtpmnr" ];
  };

  users.users.mbprtpmnr = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPassword = "$6$5irWiugp2H5uCw$Rg.gbOfv0MOpqa931xpqaqjOzKWz6UQqtVwNmXRnCIdnKjNSx/1YLhkCQW9iRdvVSXLMmNjIPBY42dpR9yOs8.";
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO87WnrZNztW30J0TlnVsGxByBIqC1iqxv2yxb0JwGUq" ];
    uid = 1000;
    description = "mbprtpmnr";
    group = "mbprtpmnr";
  };
  
  users.groups.mbprtpmnr = {
    name = "mbprtpmnr";
    gid = 1000;
  };

  security.sudo.extraRules = [
    { users = [ "mbprtpmnr" ];
      commands = [
        { command = "ALL" ;
          options= [ "NOPASSWD" ];
        }
      ];
    }
  ];

  environment.systemPackages = with pkgs; [
    git
    inetutils
    mtr
    sysstat
    vim
    curl
    wget
  ];

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
  };

  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];

  system.stateVersion = "21.11";
}
