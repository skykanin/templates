{
  description = "A collection of flake templates";

  outputs = { self }: {

    templates = {

      haskell-devShell = {
        path = ./haskell-devShell;
        description =
          "A development environment for Haskell with provided tooling";
      };

    };

  };
}
