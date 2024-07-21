{
  pkgs ? import <nixpkgs> {
    overlays = [
      (fin: pre: {
        glew = pre.glew.override { enableEGL = true; };
        glfw = pre.glfw.overrideAttrs (oldAttrs: {
          nativeBuildInputs = oldAttrs.nativeBuildInputs or [ ] ++ [ fin.wayland-scanner ];
        });
        wayland = pre.wayland.overrideAttrs (oldAttrs: {
          propagatedBuildOutputs = [
            "out"
            "dev"
          ];
        });
      })
    ];
    inherit config crossSystem;
  },
  config ? { },
  crossSystem ? null,
}:

{
  native = pkgs.callPackage ./package.nix { };
  cross = pkgs.pkgsCross.aarch64-multiplatform.callPackage ./package.nix { };
  cross-glfw = pkgs.pkgsCross.aarch64-multiplatform.glfw;
  cross-glew = pkgs.pkgsCross.aarch64-multiplatform.glew;
}
