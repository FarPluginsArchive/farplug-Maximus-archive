# Building Picture View 2 for Windows ARM64

Use a POSIX shell such as WSL and put the LLVM-MinGW toolchain with
`aarch64-w64-mingw32-clang++` on `PATH`. From the repository root run:

```sh
sh PicView/build-arm64.sh
```

The script builds Picture View 2, the Far 3 loader and wrapper, and the
GDI+ and Windows Imaging Component decoders. It also packages the CMYK
palette, language files, and help files. The output is
`build-arm64/PictureView2`. Set `BUILD_DIR` to an absolute path to change
the output directory.

Copy the `PictureView2` directory to the `Plugins` directory of an ARM64
Far Manager installation. When running Far in ConEmu ARM64, install the
ARM64 Far plugin for ConEmu so Picture View can find the visible console
window. Restart Far and run `pic:example.png` in the Far command line.
Close the picture with Esc to return to the file panels.

To use F3, configure a Far file association for the desired image extensions
with `pic:!.!` as the view command.
