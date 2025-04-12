# Run with `nix-shell cuda-fhs.nix`
{ pkgs ? import <nixpkgs> {} }:
(pkgs.buildFHSUserEnv {
  name = "cuda-env";
  targetPkgs = pkgs: with pkgs; [ 
    gcc12
    git
    gitRepo
    gnupg
    autoconf
    curl
    procps
    gnumake
    util-linux
    m4
    gperf
    unzip
    cudatoolkit
    linuxPackages.nvidia_x11
    libGLU libGL
    xorg.libXi xorg.libXmu freeglut
    xorg.libXext xorg.libX11 xorg.libXv xorg.libXrandr zlib 
    ncurses5
    stdenv.cc
    binutils
    ollama
    nvidia-docker
#    gcc12
  ];
  multiPkgs = pkgs: with pkgs; [ zlib ];
  runScript = "bash -c \'if [[ -z \"$NIX_LOGFILE\" ]]; then export NIX_LOG_FILE=\"/dev/stdout\"; fi; if [[ -z \"$NIX_AUTOSTART\" ]]; then export NIX_AUTOSTART=\"bash\"; fi; $NIX_AUTOSTART >> $NIX_LOGFILE\'";
  profile = ''
    export CUDA_PATH=${pkgs.cudatoolkit}
    # export LD_LIBRARY_PATH=${pkgs.linuxPackages.nvidia_x11}/lib
    export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
    export EXTRA_CCFLAGS="-I/usr/include"
  '';
  #shellHook = ''
  #~/ollama serve
  #'';
}).env
