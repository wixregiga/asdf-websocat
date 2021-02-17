# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

#
asdf plugin test websocat https://github.com/bdellegrazie/asdf-websocat.git "websocat --version"
```

Tests are automatically run in GitHub Actions on push and PR.
