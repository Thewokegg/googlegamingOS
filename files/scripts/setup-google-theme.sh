#!/usr/bin/env bash

set -ou pipefail

echo "=== Iniciando configuración visual de Googlebook OS ==="

export HOME="/root"
export TERM="xterm"

mkdir -p /usr/share/backgrounds/googlebook
mkdir -p /usr/share/themes
mkdir -p /usr/share/icons
mkdir -p /usr/share/gnome-shell/extensions

# 1. Descargar fondo de pantalla Material You
curl -fsSL -o /usr/share/backgrounds/googlebook/default.jpg \
  "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=2564&auto=format&fit=crop" || true

# 2. Instalar íconos circulares Tela Circle
git clone --depth=1 https://github.com/vinceliuice/Tela-circle-icon-theme.git /tmp/tela-circle && \
  (cd /tmp/tela-circle && ./install.sh -d /usr/share/icons blue || true) && \
  rm -rf /tmp/tela-circle

# 3. Instalar tema visual Orchis (Material You / ChromeOS)
git clone --depth=1 https://github.com/vinceliuice/Orchis-theme.git /tmp/orchis-theme && \
  (cd /tmp/orchis-theme && ./install.sh -d /usr/share/themes -t default -c dark || true) && \
  rm -rf /tmp/orchis-theme

# 4. Instalar extensión Dash to Panel (Barra inferior estilo ChromeOS) desde paquetes de Fedora
dnf5 install -y gnome-shell-extension-dash-to-panel || rpm-ostree install gnome-shell-extension-dash-to-panel || true

# 5. Preconfigurar GNOME y activar la barra inferior centrada por defecto
cat << 'SCHEMA' > /usr/share/glib-2.0/schemas/99-googlebook-os.gschema.override
[org.gnome.shell]
enabled-extensions=['dash-to-panel@jderose9.github.com', 'user-theme@gnome-shell-extensions.gcampax.github.com']

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

glib-compile-schemas /usr/share/glib-2.0/schemas/ || true

echo "=== Recursos y esquemas visuales aplicados correctamente ==="
