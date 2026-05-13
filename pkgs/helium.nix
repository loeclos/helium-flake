{
  lib,
  appimageTools,
  fetchurl,
  pkgs,
}:

let
  pname = "helium";
  version = "0.12.1.1";
  architecture = builtins.head (builtins.split "-" pkgs.system);

  src = fetchurl {
    url = "https://github.com/imputnet/helium/releases/download/${version}/helium-${version}${architecture}.AppImage";

    hash = "1sm21x7zyklq25nvq1cx69g0hncr3k7pakh658xl7d2lm7apycpi";
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
