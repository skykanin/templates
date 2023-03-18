{
  description = "A collection of flake templates";

  outputs = { self }: {

    templates = {

      haskell-devShell = {
        path = ./haskell-devShell;
        description =
          "A development environment for Haskell with provided tooling";
      };

      scala-devShell = {
        path = ./scala-devShell;
        description =
          "A development environment for Scala with provided tooling";
      };

      basic-devShell = {
        path = ./basic-devShell;
        description =
          "A basic development environment template";
      };

    };

  };
}
