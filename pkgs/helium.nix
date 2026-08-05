{
  lib,
  appimageTools,
  fetchurl,
  # pkgs,
}:

let
  pname = "helium";
  version = "0.15.1.1";
  architecture = "x86_64"; # builtins.head (builtins.split "-" pkgs.system);

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-${architecture}.AppImage";

    hash = "sha256-qz3w+nnvBgkpHT3E34dv4DvFuYlyzTAyg9tPYJFWs3o=";
  };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  extraPkgs =
    pkgs: with pkgs; [
      libsecret
      gtk3
      nss
      nspr
      xorg.libX11
      xorg.libXcursor
      xorg.libXi
      xorg.libXrandr
      mesa
      libdrm
      dbus
      cups
    ];

  extraInstallCommands = ''
    substituteInPlace $out/share/applications/*.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "Helium browser";
    homepage = "https://github.com/imputnet/helium";
    license = licenses.unfree;
    platforms = [
      "x86_64-linux"
      "arm64-linux"
    ];
    mainProgram = pname;
  };
}
