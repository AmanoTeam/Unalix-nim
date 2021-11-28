# Package

version = "0.7"
author = "SnwMds"
description = "Small, dependency-free, fast Nim package for removing tracking fields from URLs."
license = "LGPL-3.0"
srcDir = "src"
namedBin["unalixpkg/main"] = "unalix"
installExt = @["nim"]

# Dependencies

requires "nim >= 1.2.8"
requires "htmlunescape >= 0.2"

task test, "Runs the test suite":
  exec "nimble install --accept --depsOnly"
  exec "nim compile --run ./tests/test_cleaner.nim"
