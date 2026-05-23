# jetbrains-fhs.nix
#
# Wraps all the JetBrains IDEs in ONE shared FHS sandbox and gives you a
# launcher command per IDE (`idea`, `pycharm`, `clion`, ...). Every JDK is
# symlinked into /usr/lib/jvm *inside* the sandbox, which is exactly where
# IntelliJ's "Detected SDKs" scanner looks on Linux — so all three JDKs show
# up automatically when you go to add a Project SDK.
#
# Import it from configuration.nix:
#   imports = [ ./jetbrains-fhs.nix ];

{ pkgs, lib, ... }:

let
  #### JDKs that should be visible to IntelliJ ################################
  # Package names (looked up in `pkgs`). The name is also what appears under
  # /usr/lib/jvm and in the IDE's SDK list.
  jdks = [
    "zulu17"
    "corretto21"
    "zulu25"
  ];

  #### IDEs to sandbox #######################################################
  # Each name is both the in-sandbox binary and the launcher you get on PATH.
  ides = [
    "idea"
    "clion"
    "pycharm"
    "webstorm"
    "goland"
    "datagrip"
    "rider"
    "phpstorm"
    "rust-rover"
  ];

  #### The FHS sandbox #######################################################
  fhs = pkgs.buildFHSEnv {
    name = "jetbrains-fhs";

    targetPkgs =
      p:
      # The IDEs themselves
      (map (name: p.jetbrains.${name}) ides)
      # JDKs + JVM build tooling
      ++ (map (name: p.${name}) jdks)
      ++ (with p; [
        gradle
        gradle_9
        maven
        jetbrains-runner
        dotnet-sdk_8
        dotnet-sdk_9
        python311
        python314
      ])
      # Native toolchain: CLion, native gradle plugins, Minecraft natives, etc.
      ++ (with p; [
        gcc
        gnumake
        cmake
        ninja
        pkg-config
        binutils
        gdb
        glfw # Minecraft / LWJGL
        git
        coreutils
        which
        file
        gawk
        gnugrep
        gnused
        findutils
      ])
      # Runtime libs the IDEs, the bundled JCEF browser, and any binaries the
      # IDEs/plugins download expect to find at standard FHS paths.
      ++ (with p; [
        stdenv.cc.cc.lib
        glibc
        zlib
        zstd
        openssl
        curl
        libxml2
        expat
        fontconfig
        freetype
        dejavu_fonts
        glib
        gtk3
        cairo
        pango
        gdk-pixbuf
        atk
        at-spi2-atk
        at-spi2-core
        dbus
        cups
        nss
        nspr
        alsa-lib
        libpulseaudio
        libGL
        libGLU
        vulkan-loader
        libdrm
        libxkbcommon
        wayland
        # Xorg
        libX11
        libXext
        libXrender
        libXtst
        libXi
        libXrandr
        libXcursor
        libXScrnSaver
        libXxf86vm
        libxcb
        libXcomposite
        libXdamage
        libXfixes
      ]);

    # Sourced inside the sandbox before runScript. Default JAVA_HOME to the
    # newest JDK and put its bin on PATH so command-line java/gradle agree
    # with what the IDE sees.
    profile = ''
      export JAVA_HOME=/usr/lib/jvm/zulu25
      export PATH="$JAVA_HOME/bin:$PATH"
    '';

    # Populate /usr/lib/jvm inside the sandbox. `.home` is the canonical Java
    # home for these packages; fall back to the package root if it's absent.
    extraBuildCommands = ''
      mkdir -p $out/usr/lib/jvm || true
      ${lib.concatStringsSep "\n" (
        map (
          name:
          let
            jdk = pkgs.${name};
          in
          "ln -sfn ${jdk.home or jdk} $out/usr/lib/jvm/${name} || true"
        ) jdks
      )}
    '';

    runScript = "bash";
  };

  #### One launcher per IDE ##################################################
  # `idea`, `pycharm`, ... each exec the matching binary inside the shared
  # sandbox and forward all args (so `idea /path/to/project` works).
  launchers = map (
    ide:
    pkgs.writeShellScriptBin ide ''
      exec ${fhs}/bin/jetbrains-fhs -c 'exec ${ide} "$@"' -- "$@"
    ''
  ) ides;
in
{
  environment.systemPackages = launchers ++ [
    fhs # also exposes `jetbrains-fhs` — an interactive shell inside the sandbox, handy for debugging
  ];

  # Keep this in EXACTLY ONE module. If you already declare
  # permittedInsecurePackages in your main configuration.nix, delete it there
  # or here to avoid a duplicate-definition merge.
  nixpkgs.config.permittedInsecurePackages = [
    "gradle-7.6.6"
  ];
}
