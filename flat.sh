# stop on first error
set -e

set -v


cat << EOF > program.c
#include <stdio.h>

int main() {
    printf("Hello World!\n");
    return 0;
}
EOF

sudo apt install -y gcc
gcc program.c -O3 -g0 -o program-linux

cat << EOF > manifest.yml
app-id: org.flatpak.Hello
runtime: org.freedesktop.Platform
runtime-version: '23.08'
sdk: org.freedesktop.Sdk
command: program-linux
modules:
  - name: hello
    buildsystem: simple
    build-commands:
      - install -D program-linux /app/bin/program-linux
    sources:
      - type: file
        path: /home/ubuntu/program-linux
        dest-filename: program-linux
EOF

flatpak-builder -v -y --user --install build-dir manifest.yml
flatpak run org.flatpak.Hello
