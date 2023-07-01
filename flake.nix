# I used chatgpt to generate this template and then just
# modified to how I normally use these things.
{
  description = "My Haskell project";

  nixConfig.extra-substituters = [ "https://haskell-language-server.cachix.org" ];
  nixConfig.extra-trusted-public-keys = [ "haskell-language-server.cachix.org-1:juFfHrwkOxqIOZShtC4YC1uT1bBcq2RSvC7OMKx0Nz8=" ];

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    hls.url = "github:haskell/haskell-language-server";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    utils,
    hls,
    ...
  }:
    utils.lib.eachSystem ["x86_64-linux"] (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      ghcVersion = "94";

      hpkgs = pkgs.haskell.packages."ghc${ghcVersion}".override {
        overrides = hself: _hsuper:
          with pkgs.haskell.lib.compose; {
            llvm-party =
              addBuildTools [pkgs.llvmPackages_15.libllvm]
              (hself.callCabal2nix "llvm-party" ./. {});
          };
      };

      server = hls.packages.${system}."haskell-language-server-${ghcVersion}";

      hsShell = hpkgs.shellFor {
        packages = ps: [ps.llvm-party];
        withHoogle = true;

        buildInputs = [
          server
          
          pkgs.ghcid
          pkgs.cabal-install
        ];
      };
    in {
      legacyPackages = pkgs;
      packages.default = hpkgs.llvm-party;
      devShells.default = hsShell;
    });
}
