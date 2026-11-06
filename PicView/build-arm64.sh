#!/bin/sh
set -eu

cd "$(dirname "$0")"
src=$PWD
root=$(dirname "$src")
out=${BUILD_DIR:-"$root/build-arm64"}
case "$out" in
    /*) ;;
    *) echo "BUILD_DIR must be an absolute path" >&2; exit 1 ;;
esac
package="$out/PictureView2"
mkdir -p "$package"
cxx=aarch64-w64-mingw32-clang++

build_dll() {
    "$cxx" -shared -static -std=c++14 -O2 -fms-extensions \
        -fms-compatibility-version=19.20 -D_export= -DUNICODE -D_UNICODE \
        -DNDEBUG -DHIDE_TODO -Wno-c++11-narrowing \
        -Wno-microsoft-enum-forward-reference -Wno-nonportable-include-path "$@"
}

build_dll ConEmuSupport.cpp PictureView.cpp PictureView_Class.cpp PictureView_CMYK.cpp \
    PictureView_Configure.cpp PictureView_Display.cpp PictureView_Dlg.cpp \
    PictureView_FileName.cpp PictureView_Panel.cpp PictureView_TitleRepaint.cpp \
    PictureView_Utils.cpp PVDDecoder1.cpp PVDDecoder2.cpp PVDDecoderBase.cpp \
    PVDManager.cpp PVDInterface/BltHelper.cpp PictureView.def \
    -o "$package/0PictureView.dl_" -lshlwapi -lwinmm -lgdi32 -lcomctl32 -lole32 -luuid -lcomdlg32

cd "$root/Far3Wrap/src"
build_dll Loader.cpp Loader.def -o "$package/0PictureView.dll" -lrpcrt4 -lshlwapi
build_dll Far3Wrap.cpp Keyboard3.cpp Memory.cpp SetHook.cpp Far3Wrap.def \
    -o "$package/Far3Wrap64.dll" -ladvapi32 -lrpcrt4 -lshlwapi -luuid

cd "$src/PVDInterface"
build_dll pvdGDI/pvdGDI.cpp PVD1Helper.cpp PVD2Helper.cpp BltHelper.cpp pvdGDI/pvdGDI.def \
    -o "$package/GDIPlus.pvd" -lgdiplus -lgdi32 -lole32 -luuid -lversion
build_dll pvdWIC/pvdWIC.cpp PVD1Helper.cpp PVD2Helper.cpp pvdWIC/pvdWIC.def \
    -o "$package/WIC.pvd" -lwindowscodecs -lole32 -luuid -lversion

sed 's/^Author=<Unknown>/Author=Pavel Skakov \/ Maximus5/; s/^Version=1\.0\.0\.0/Version=2.0.0.25/' \
    "$root/Far3Wrap/Samples/0PictureView.ini" > "$package/0PictureView.ini"
cp "$src"/lng/PictureView_*.lng "$src"/lng/PictureView_*.hlf "$src/bin.x64/CMYK.png" \
    "$src"/LICENSE-*.txt "$package/"
