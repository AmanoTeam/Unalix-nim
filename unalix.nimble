# Package

version = "0.2"
author = "SnwMds"
description = "Small, dependency-free, fast Nim package for removing tracking fields from URLs."
license = "LGPL-3.0"
srcDir = "src"
# bin = @["unalix"]
namedBin["unalixpkg/main"] = "unalix"
installExt = @["nim"]

# Dependencies

requires "nim >= 1.2.6"
