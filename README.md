# cats

**238 bytes. x64 Assembly. cat(1) clone.**

Uses `sendfile(2)` for zero-copy file output—data transfers directly from kernel filesystem cache to stdout without touching userspace. No libc, no bloat.

## Build

```sh
./build.sh
```

Requires `fasm`.

## Usage

```sh
./cats file1 file2 file3 ...
```

Outputs files to stdout. Exits 0 on success, 1 on error.
