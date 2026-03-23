# cats

**A very small cat(1) clone**

Uses `sendfile(2)` for zero-copy file output—data transfers directly from kernel filesystem cache to stdout without touching userspace.
Handles all types of files.

## Build

```sh
sh build.sh
```

Requires `fasm` and `tcc`.

## Usage

```sh
cats file1 file2 file3 ...
cats
echo "foo" | cats
```

Outputs files to stdout. Exits 0 on success, 1 on error.
