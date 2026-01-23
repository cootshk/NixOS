final: prev: {
  vesktop = prev.vesktop.overrideAttrs (oldAttrs: {
    # Fix permission denied during electron build on Linux
    # See: https://github.com/NixOS/nixpkgs/pull/476514
    preBuild = prev.lib.optionalString prev.stdenv.hostPlatform.isLinux ''
      cp -r ${prev.electron}/libexec/electron electron-dist
      chmod -R u+w electron-dist
    '';

    buildPhase = ''
      runHook preBuild

      pnpm build --standalone
      pnpm exec electron-builder \
        --dir \
        -c.asarUnpack="**/*.node" \
        -c.electronDist=electron-dist \
        -c.electronVersion=${prev.electron.version}

      runHook postBuild
    '';
  });
}
