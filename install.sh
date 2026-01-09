#!/usr/bin/env bash
set -euo pipefail

REPO_RAW="https://raw.githubusercontent.com/USUARIO/REPO/main"
BIN_NAME="tooldomain"

# Rutas típicas por usuario
TARGET_DIR="${HOME}/.local/bin"
TARGET_PATH="${TARGET_DIR}/${BIN_NAME}"

if ! command -v curl >/dev/null 2>&1; then
  echo "❌ curl no está instalado"
  exit 1
fi

mkdir -p "$TARGET_DIR"

echo "📥 Descargando ${BIN_NAME} en ${TARGET_PATH}..."
curl -fsSL "${REPO_RAW}/${BIN_NAME}" -o "$TARGET_PATH"

echo "🔐 Dando permisos..."
chmod +x "$TARGET_PATH"

# Asegurar PATH (sin romper nada): intenta zsh y bash
add_path_line='export PATH="$HOME/.local/bin:$PATH"'
for f in "$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.profile"; do
  if [[ -f "$f" ]]; then
    if ! grep -Fqs "$add_path_line" "$f"; then
      echo "$add_path_line" >> "$f"
    fi
  fi
done

echo "✅ Listo."
echo "👉 Abre una nueva terminal y ejecuta: ${BIN_NAME}"
echo "   (o ejecútalo ya con: $TARGET_PATH)"
