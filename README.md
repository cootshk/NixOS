<h1 align="center">
   <img src="./assets/nixos-logo.png  " width="100px" /> 
   <br>
      My reproducible config for NixOS
   <br>
      <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/palette/macchiato.png" width="600px" /> <br>
   <div align="center">
</h1>

![Screenshot](./assets/preview.png)

> [!WARNING]
> <p>Not Tested on amd GPUs and bios boot mode!<br>

# Install
> [!Note]
> <p>Default locale and timezone is American.<br>
> If you want to change this then edit the variables in flake.nix.</p>

Make sure to reboot after installing with any of the methods below.
## Using the install script
```bash
nix run --experimental-features "nix-command flakes" nixpkgs#git clone https://github.com/Sly-Harvey/NixOS.git ~/NixOS
```
```bash
cd ~/NixOS
```
```bash
sudo ./install.sh
```
## Building manually
> [!IMPORTANT]
> <p>When building manually from the flake make sure to place your hardware-configuration.nix in hosts/Default/<br>
> and CHANGE the username variable in flake.nix with your username!!<br>
> then run the command below</p>
```bash
sudo nixos-rebuild switch --flake .#nixos
```
