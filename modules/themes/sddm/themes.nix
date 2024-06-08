#{
#  stdenv,
#  fetchFromGitHub,
#}: {
#  sugar-dark = stdenv.mkDerivation rec {
#    pname = "sddm-sugar-dark-theme";
#    version = "v1.2";
#    dontBuild = true;
#    installPhase = ''
#      mkdir -p $out/share/sddm/themes
#      cp -aR $src $out/share/sddm/themes/sugar-dark
#    '';
#    src = fetchFromGitHub {
#      owner = "MarianArlt";
#      repo = "sddm-sugar-dark";
#      rev = "${version}";
#      sha256 = "0gx0am7vq1ywaw2rm1p015x90b75ccqxnb1sz3wy8yjl27v82yhb";
#    };
#  };
#  astronaut = stdenv.mkDerivation rec {
#    pname = "sddm-astronaut-theme";
#    version = "468a100460d5feaa701c2215c737b55789cba0fc";
#    dontBuild = true;
#    installPhase = ''
#      mkdir -p $out/share/sddm/themes
#      cp -aR $src $out/share/sddm/themes/astronaut
#    '';
#    src = fetchFromGitHub {
#      owner = "Keyitdev";
#      repo = "sddm-astronaut-theme";
#      rev = "${version}";
#      sha256 = "1h20b7n6a4pbqnrj22y8v5gc01zxs58lck3bipmgkpyp52ip3vig";
#    };
#  };
#  tokyo-night = stdenv.mkDerivation rec {
#    pname = "sddm-tokyo-night-theme";
#    version = "320c8e74ade1e94f640708eee0b9a75a395697c6";
#    dontBuild = true;
#    installPhase = ''
#      mkdir -p $out/share/sddm/themes
#      cp -aR $src $out/share/sddm/themes/tokyo-night
#    '';
#    src = fetchFromGitHub {
#      owner = "siddrs";
#      repo = "tokyo-night-sddm";
#      rev = "${version}";
#      sha256 = "1gf074ypgc4r8pgljd8lydy0l5fajrl2pi2avn5ivacz4z7ma595";
#    };
#  };
#}

# Catppuccin

{
  pkgs,
  lib,
  stdenvNoCC ? pkgs.stdenvNoCC,
  fetchFromGitHub ? pkgs.fetchFromGitHub,
  just,
  kdePackages ? pkgs.kdePackages,
  flavor ? "mocha",
  font ? "Noto Sans",
  fontSize ? "9",
  background ? null,
  loginBackground ? false,
}:
stdenvNoCC.mkDerivation rec {
  pname = "catppuccin-sddm";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "sddm";
    rev = "v${version}";
    hash = "sha256-SdpkuonPLgCgajW99AzJaR8uvdCPi4MdIxS5eB+Q9WQ=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [
    just
  ];

  propagatedBuildInputs = [
    kdePackages.qtsvg
  ];

  buildPhase = ''
    runHook preBuild

    just build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/sddm/themes/"
    cp -r dist/catppuccin-${flavor} "$out/share/sddm/themes/catppuccin-${flavor}"

    configFile=$out/share/sddm/themes/catppuccin-${flavor}/theme.conf

    substituteInPlace $configFile \
      --replace-fail 'Font="Noto Sans"' 'Font="${font}"' \
      --replace-fail 'FontSize=9' 'FontSize=${fontSize}'

    ${lib.optionalString (background != null) ''
      substituteInPlace $configFile \
        --replace-fail 'Background="backgrounds/wall.jpg"' 'Background="${background}"' \
        --replace-fail 'CustomBackground="false"' 'CustomBackground="true"'
    ''}

    ${lib.optionalString loginBackground ''
      substituteInPlace $configFile \
        --replace-fail 'LoginBackground="false"' 'LoginBackground="true"'
    ''}

    runHook postInstall
  '';

  postFixup = ''
    mkdir -p $out/nix-support
    echo ${kdePackages.qtsvg} >> $out/nix-support/propagated-user-env-packages
  '';

  meta = {
    description = "Soothing pastel theme for SDDM";
    homepage = "https://github.com/catppuccin/sddm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [elysasrc];
    platforms = lib.platforms.linux;
  };
}