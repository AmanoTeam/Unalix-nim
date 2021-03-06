# Package

version = "0.5.1"
author = "SnwMds"
description = "Small, dependency-free, fast Nim package for removing tracking fields from URLs."
license = "LGPL-3.0"
srcDir = "src"
namedBin["unalixpkg/main"] = "unalix"
installExt = @["nim"]

# Dependencies

requires "nim >= 1.4.0"

task test, "Runs the test suite":
  exec "nim compile --run tests/test_cleaner.nim"
