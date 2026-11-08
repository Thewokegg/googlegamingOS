#!/usr/bin/env bash

# Detener la compilación si ocurre algún error crítico
set -oue pipefail

echo "=== Iniciando configuración visual de Googlebook OS ==="

# 1. Crear los directorios base para fondos, temas e íconos
mkdir -p /usr/share/backgrounds/googlebook
mkdir -p /usr/share/themes
mkdir -p /usr/share/icons

# 2. Descargar fondo de pantalla limpio estilo Material You
curl -fsSL -o /usr/share/backgrounds/googlebook/default.jpg \
  "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=2564&auto=format&fit=crop" || true

# 3. Descargar e instalar íconos circulares estilo Google/ChromeOS (Tela Circle)
git clone --depth=1 https://github.com/vinceliuice/Tela-circle-icon-theme.git /tmp/tela-circle
/tmp/tela-circle/install.sh -d /usr/share/icons blue
rm -rf /tmp/tela-circle

# 4. Descargar e instalar el tema visual Material You / ChromeOS (Orchis)
git clone --depth=1 https://github.com/vinceliuice/Orchis-theme.git /tmp/orchis-theme
/tmp/orchis-theme/install.sh -d /usr/share/themes -t default -c dark
rm -rf /tmp/orchis-theme

# 5. Preconfigurar GNOME para que arranque con este diseño por defecto
cat << 'EOF' > /usr/share/glib-2.0/schemas/99-googlebook-os.gschema.override
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
EOF

# 6. Compilar los esquemas de GNOME en el sistema base
glib-compile-schemas /usr/share/glib-2.0/schemas/

echo "=== Recursos y esquemas visuales aplicados correctamente ==="
