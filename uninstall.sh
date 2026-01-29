#!/bin/bash
set -euo pipefail

echo "=============================================="
echo " Uninstall tooldomain — limpieza completa"
echo "=============================================="
echo

# -------------------------
# Paths conocidos
# -------------------------
BIN_PATHS=(
  "$HOME/bin/tooldomain"
  "$HOME/bin/tooldomain.sh"
  "/usr/local/bin/tooldomain"
  "/usr/bin/tooldomain"
)

CACHE_PATHS=(
  "$HOME/.cache/tooldomain"
  "$HOME/.cache/tooldomain*"
)

CONFIG_PATHS=(
  "$HOME/.tooldomain"
  "$HOME/.config/tooldomain"
)

INSTALLERS=(
  "$HOME/install-tooldomain.sh"
  "$HOME/tooldomain-install.sh"
)

SHELL_FILES=(
  "$HOME/.bashrc"
  "$HOME/.bash_profile"
  "$HOME/.zshrc"
  "$HOME/.profile"
)

# -------------------------
# Funciones
# -------------------------
rm_if_exists() {
  local p="$1"
  if [[ -e "$p" ]]; then
    echo "🗑️  Eliminando: $p"
    rm -rf "$p"
  fi
}

remove_aliases() {
  local file="$1"
  [[ -f "$file" ]] || return 0

  if grep -q "tooldomain" "$file"; then
    echo "✂️  Limpiando referencias en: $file"
    cp "$file" "${file}.bak.$(date +%s)"
    sed -i.bak '/tooldomain/d' "$file" || true
  fi
}

# -------------------------
# 1) Borrar binarios
# -------------------------
echo "▶ Eliminando binarios..."
for p in "${BIN_PATHS[@]}"; do
  rm_if_exists "$p"
done

# -------------------------
# 2) Borrar cache
# -------------------------
echo
echo "▶ Eliminando cache..."
for p in "${CACHE_PATHS[@]}"; do
  rm_if_exists "$p"
done

# -------------------------
# 3) Borrar config
# -------------------------
echo
echo "▶ Eliminando configuraciones..."
for p in "${CONFIG_PATHS[@]}"; do
  rm_if_exists "$p"
done

# -------------------------
# 4) Borrar scripts de instalación
# -------------------------
echo
echo "▶ Eliminando instaladores..."
for p in "${INSTALLERS[@]}"; do
  rm_if_exists "$p"
done

# -------------------------
# 5) Limpiar aliases / exports en shells
# -------------------------
echo
echo "▶ Limpiando aliases y exports..."
for f in "${SHELL_FILES[@]}"; do
  remove_aliases "$f"
done

# -------------------------
# 6) Limpiar hash del shell
# -------------------------
hash -r 2>/dev/null || true

# -------------------------
# 7) Verificación final
# -------------------------
echo
echo "▶ Verificación final:"
if command -v tooldomain >/dev/null 2>&1; then
  echo "⚠️  tooldomain aún está en PATH: $(command -v tooldomain)"
else
  echo "✅ tooldomain eliminado del PATH"
fi

echo
echo "=============================================="
echo " ✔ Uninstall completado"
echo " 👉 Recomendado: abre una nueva terminal"
echo "=============================================="
