<div align="center">

# asdf-websocat ![Build](https://github.com/bdellegrazie/asdf-websocat/workflows/Build/badge.svg) ![Lint](https://github.com/bdellegrazie/asdf-websocat/workflows/Lint/badge.svg)

[websocat](https://github.com/vi/websocat) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Why?](#why)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add websocat
# or
asdf plugin add https://github.com/bdellegrazie/asdf-websocat.git
```

websocat:

```shell
# Show all installable versions
asdf list-all websocat

# Install specific version
asdf install websocat latest

# Set a version globally (on your ~/.tool-versions file)
asdf global websocat latest

# Now websocat commands are available
websocat --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/bdellegrazie/asdf-websocat/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Brett Delle Grazie](https://github.com/bdellegrazie/)
