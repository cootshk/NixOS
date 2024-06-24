{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    #libnvidia-container
    #nvidia-container-toolkit
    #nvidia-docker
    docker
    docker-compose
  ];
  virtualisation.docker = {
    enable = true;
    # setSocketVariable = true;
  };
  #systemd.tmpfiles.rules = optional config.virtualisation.docker.enableNvidia "L+ /run/nvidia-docker/bin - - - - ${nvidia_x11.bin}/origBin" ++ optional (nvidia_x11.persistenced != null && config.virtualisation.docker.enableNvidia) "L+ /run/nvidia-docker/extras/bin/nvidia-persistenced - - - - ${nvidia_x11.persistenced}/origBin/nvidia-persistenced";
}