# cats

**A very small "cat" clone**

## Description
"cats" is optimized highly. it is tuned for all file types, and it compiles to less than a kilobyte
on x64 Debian. this program does not link to libc, or any other libraries. Because of that, it is small and efficient,
with the side effect of not accepting non-path arguments. Subsequently, the five people on this planet that use options for "cat"
will be very dissapointed with me. Despite that, "cats" gets the job done, and it does it efficiently.


## Build

```sh
sh build.sh
```
Dependencies: fasm, tcc

## Usage

```sh
cats file1 file2 file3 ...
cats
echo "foo" | cats
cats foo.txt | some_program
```

"cats" does what "cat" does.
