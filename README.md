# Nix templates

My personal Nix templates for getting started with a Nix project.

```console
$ nix flake init --template github:skykanin/templates#full
```

or

```console
$ nix flake new --template github:skykanin/templates#full ./my-new-project
```

You can also add a shortcut to the flake url by adding it to your registry with a name.
This way you don't have to refer to the full flake url every time you want to create a template
from this flake.

```console
$ nix registry add my-templates github:skykanin/templates
```
