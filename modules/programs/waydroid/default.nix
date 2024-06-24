{pkgs, ...} : {
  virtualization.waydroid = {
    enable = true;
    waydroid = {
      enable = true;
      waydroidPackages = with pkgs; [
        # List of packages to install in the container
        # e.g. firefox
      ];
    };
  };
}