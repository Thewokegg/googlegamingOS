#!/usr/bin/env bash

set -oue pipefail

echo "=== Iniciando configuración visual de Googlebook OS ==="

mkdir -p /usr/share/backgrounds/googlebook
mkdir -p /usr/share/themes
mkdir -p /usr/share/icons

curl -fsSL -o /usr/share/backgrounds/googlebook/default.jpg \
  "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=2564&auto=format&fit=crop" || true

git clone --depth=1 https://github.com/vinceliuice/Tela-circle-icon-theme.git /tmp/tela-circle
(cd /tmp/tela-circle && ./install.sh -d /usr/share/icons blue)
rm -rf /tmp/tela-circle

git clone --depth=1 https://github.com/vinceliuice/Orchis-theme.git /tmp/orchis-theme
(cd /tmp/orchis-theme && ./install.sh -d /usr/share/themes -t default -c dark)
rm -rf /tmp/orchis-theme

cat << 'SCHEMA' > /usr/share/glib-2.0/schemas/99-googlebook-os.gschema.override
[org.gnome.desktop.interface]
icon-theme='Tela-circle-blue'
gtk-theme='Orchis-Dark'
color-scheme='prefer-dark'
clock-format='12h'

[org.gnome.desktop.wm.preferences]
button-layout='appmenu:minimize,maximize,close'

[org.gnome.desktop.background]
picture-uri='file:///usr/share/backgrounds/googlebook/default.jpg'
picture-uri-dark='file:///usr/share/backgrounds/googlebook/default.jpg'
picture-options='zoom'
SCHEMA

glib-compile-schemas /usr/share/glib-2.0/schemas/

echo "=== Recursos y esquemas visuales aplicados correctamente ==="
