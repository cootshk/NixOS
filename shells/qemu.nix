{ pkgs ? import <nixpkgs> {} }:
(pkgs.buildFHSUserEnv {
  name = "qemu";
  targetPkgs = pkgs: with pkgs; [
    qemu
    qemu_full
    qemu_kvm
    libvirt
    virt-manager
  ];
})