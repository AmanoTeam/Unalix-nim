# Package

version = "0.8"
author = "SnwMds"
description = "Small, dependency-free, fast Nim package for removing tracking fields from URLs."
license = "LGPL-3.0"
srcDir = "src"
namedBin["unalixpkg/main"] = "unalix"
installExt = @["nim", "c", "h"]

# Dependencies

requires "nim >= 1.4.0"
