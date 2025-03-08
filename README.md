# Doukutsu-rs

Flatpak packaging for a rust implementation of Doukutsu monogatari.

If you want to play the game, please go to the [flathub](https://flathub.org/apps/io.github.doukutsu_rs.doukutsu-rs) page instead of here, or check out [the website](https://doukutsu.rs/).

## Maintenance

This is made to be as simple as possible to maintain.
If you want to update dependencies, do the standard procedure of linting and
checking the manifest, and run `./update-deps.sh` on the current directory
with the up-to-date repository as the base.

Ensure to always update the cargo dependencies before bumping any versions of
the `doukutsu-rs` module.

You can lint/check the manifest by running:
```sh
flatpak run org.flathub.flatpak-external-data-checker ./io.github.doukutsu_rs.doukutsu-rs.yaml # checks if we are out of date
flatpak run --command=flatpak-builder-lint org.flatpak.Builder manifest ./io.github.doukutsu_rs.doukutsu-rs.yaml # checks if we are doing anything wrong
# then build the manifest as normal and see if it actually builds
flatpak run org.flatpak.Builder $"./build-dir" --state-dir=$"./flatpak-builder" --user --ccache --force-clean --install --disable-rofiles-fuse ./io.github.doukutsu_rs.doukutsu-rs.yaml
```

NOTE: You need to clone the repository with submodules in order to get the required scripts for `./update-deps.sh`
