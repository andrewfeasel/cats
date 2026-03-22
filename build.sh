#!/bin/sh
echo "Building cats ..."

tcc -run src/sysconsts_build.c
exec fasm src/cats.asm cats
