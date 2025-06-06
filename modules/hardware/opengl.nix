{pkgs, ...}: {
  hardware.opengl = {
    enable = true;
    # driSupport = true;
    # enable32Bit = true;
    extraPackages = with pkgs; [
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
    ];
  };
}
