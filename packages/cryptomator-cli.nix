{ stdenv, fetchFromGitHub, jdk }:

stdenv.mkDerivation {
  pname = "cryptomator-cli";
  version = "latest";

  src = fetchFromGitHub {
    owner = "cryptomator";
    repo = "cli";
    rev = "master";
    #sha256 = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"; # Run nix-prefetch-git
  };

  buildInputs = [ jdk ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/bin/
  '';
}

