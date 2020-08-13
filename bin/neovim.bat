:: https://github.com/michael-angelozzi/explorer_launch_wsl_app
@echo off
set my_app=/home/meck/bin/nvim_wsl
set my_wt_profile="Nix"
set pp=%1
set pp=%pp:'='\''%
set pp=%pp:;=\;%
set launch="p=$(wslpath '%pp:"=%') && cd \\"^""$(dirname \\"^""$p\\"^"")\\"^"" && %my_app% \\"^""$p\\"^""
start wt.exe new-tab -p %my_wt_profile% -- bash -i -c %launch%
