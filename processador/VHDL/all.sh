#!/bin/bash
chmod +x all.sh

for arquivo in *.vhd; do
  ./compile.sh "$arquivo"
done
