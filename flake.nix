# https://www.tweag.io/blog/2020-05-25-flakes/
{
  # One-line description shown by `nix flake metadata`
  description = "A flake for building Hello Flake";

  # Other flakes that this flake depends on. These are fetched by Nix and passed
  # as arguments to the `outputs` function.
  inputs = {
    # Although we don't specify a revision here, Nix automatically generates a
    # lock file when we run `nix build`, stating precisely which revision to use.
    # If we wanted to update this locked input, we could run:
    #
    #   nix flake lock --update-input nixpkgs
    #
    nixpkgs.url = github:NixOS/nixpkgs/nixos-20.03;
  };

  # The heart of the flake -- a function that produces an attribute set.
  # The `self` argument refers to this flake. The attributes are arbitrary
  # values, except that there are some standard outputs.
  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.hello =
      # Notice the reference to nixpkgs here.
      nixpkgs.legacyPackages.x86_64-linux.stdenv.mkDerivation {
        name = "hello";
        src = self;
        buildPhase = "gcc -o hello ./hello.c";
        installPhase = "mkdir -p $out/bin; install -t $out/bin hello";
      };

    packages.x86_64-linux.default = self.packages.x86_64-linux.hello;
  };
}
