# TODO

See `TODO.md` in each repos.

## Known Issue

- In order to support vcpkg in a better way, build script needs to write commit numbers of all repos to a file, e.g. `Import/Commits.txt`.
- Check if envvar "UseMultiToolTask" is "True" in Build.ps1

## Roadmap

- Reimplement C++ parser in vczh-libraries/Document using this project.
  - Move all test cases to `BuiltIn_CppDoc`.
- Refactor vczh-libraries/Document to generate document using the new parser but skip the code index temporary.
- Create a new repo `BuildTools` and adapt the release license instead of the development license.
- Revisit Hero DB (prolog is a bad idea, use a simple FPL with additional `query` syntax for querying)

## Ubuntu Development Environment

- Consider recognize referenced projects automatically.
