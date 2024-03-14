# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "uas" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ef50c840-05d4-45b4-8f99-4e3cf2ff1955";
    fsType = "btrfs";
    options = ["subvol=@"];
  };

  boot.initrd.luks.devices."luks-8f557d36-e66d-4a70-8068-5845f5a07ad2".device = "/dev/disk/by-uuid/8f557d36-e66d-4a70-8068-5845f5a07ad2";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9D31-0901";
    fsType = "vfat";
  };

  swapDevices = [];

  fileSystems."/mnt/seagate" = {
    device = "/dev/disk/by-uuid/E212-7894";
    fsType = "auto";
    options = [
      "X-mount.mkdir"
      "async"
      "auto"
      "dev"
      "user"
      "rw"
      "exec"
      "suid"
      "nofail"
      "uid=1000"
      "gid=100"
      "umask=000"
      "x-gvfs-show"
      "x-systemd.automount"
      "x-systemd.mount-timeout=5"
    ];
  };

  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/01DA12C1CBDE9100";
    fsType = "lowntfs-3g";
    options = [
      "X-mount.mkdir"
      "nofail"
      "async"
      "rw"
      "exec"
      "user"
      "uid=1000"
      "gid=100"
      "umask=000"
      "x-gvfs-show"
      "x-systemd.mount-timeout=5"
    ];
  };

  hardware = {
    nvidia = {
      open = false;
      nvidiaSettings = true;
      powerManagement.enable = true;
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [nvidia-vaapi-driver];
    };
  };

  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize = 8192; # Use 8GB memory.
      # memorySize = 4096; # Use 4GB memory.
      # memorySize = 2048; # Use 2GB memory.
      cores = 3;
    };
  };
  virtualisation.vmVariantWithBootLoader = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize = 8192; # Use 8GB memory.
      # memorySize = 4096; # Use 4GB memory.
      # memorySize = 2048; # Use 2GB memory.
      cores = 3;
    };
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
