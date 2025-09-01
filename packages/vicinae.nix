{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "vicinae";
  buildRev = "4";
  n = "0.7.2";
  v = "v${n}";
  version = "${n}-r${buildRev}";
  sys = "linux-x86_64";

  src = pkgs.fetchurl {
    url = "https://github.com/vicinaehq/${pname}/releases/download/${v}/${pname}-${sys}-${v}.tar.gz";
    sha256 = "sha256-oPlIl+80cOFo94d4VAeJcqIofrLdbJBPNpuSo8TLGJY="; # Nix will tell you the correct hash when you run it
  };

  nativeBuildInputs = with pkgs; [
    autoPatchelfHook  # Important for pre-built binaries
      makeWrapper       # In case you need to wrap the binary
      qt6.wrapQtAppsHook
  ];

  buildInputs = with pkgs; [
# Runtime dependencies that the binary might need
    stdenv.cc.cc.lib
      glibc
      qt6.qtbase
      qt6.qtsvg
      qt6.qtwayland
      kdePackages.layer-shell-qt
      protobuf
      cmark-gfm
      minizip
      abseil-cpp
      zlib-ng
      libqalculate
      qt6Packages.qtkeychain
      wayland
      wayland-protocols
      wayland-scanner
  ];

  propagatedBuildInputs = with pkgs; [
    wl-clipboard-rs  # This provides wlr-clip functionality
# or try: wl-clipboard-rs
  ];

  sourceRoot = ".";
  dontBuild = true;      # Skip build phase since it's a pre-built binary
    dontConfigure = true;  # Skip configure phase
    dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
# Extract and install the binary
    tar -xzf $src
    install -Dm755 ./bin/vicinae $out/bin/vicinae-wrapped

    runHook postInstall
    '';

  postFixup = ''
# Wrap with both Qt and PATH for wlr-clip
    makeWrapper $out/bin/vicinae-wrapped $out/bin/vicinae \
    --prefix PATH : "${pkgs.lib.makeBinPath [ pkgs.wl-clipboard ]}" \
    --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath buildInputs}" \
    ''${qtWrapperArgs[@]}
  '';

  meta = with pkgs.lib; {
    description = "Vicinae application";
    homepage = "https://github.com/vicinaehq/vicinae";
    platforms = platforms.linux;
  };
}
