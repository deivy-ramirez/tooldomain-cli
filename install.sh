#!/usr/bin/env bash
set -euo pipefail

REPO_RAW="https://raw.githubusercontent.com/deivy-ramirez/tooldomain-cli/main"
BIN_NAME="tooldomain"

TARGET_DIR="${HOME}/bin"
TARGET_PATH="${TARGET_DIR}/${BIN_NAME}"

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || { echo "❌ Requiere '$1' instalado"; exit 1; }
}

need_cmd curl

mkdir -p "$TARGET_DIR"

echo "📥 Descargando ${BIN_NAME} en ${TARGET_PATH}..."
curl -fsSL "${REPO_RAW}/${BIN_NAME}" -o "$TARGET_PATH"

# Validación rápida: que no haya bajado un HTML de error
if head -n 1 "$TARGET_PATH" | grep -qi "<!doctype html"; then
  echo "❌ Descarga falló (parece HTML). Revisa que el archivo '${BIN_NAME}' exista en el repo y sea público."
  rm -f "$TARGET_PATH"
  exit 1
fi

echo "🔐 Dando permisos..."
chmod +x "$TARGET_PATH"

# Asegurar PATH
add_path_line='export PATH="$HOME/bin:$PATH"'
updated_any=0

for f in "$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.profile"; do
  # crea el archivo si no existe (para que el PATH se guarde)
  [[ -f "$f" ]] || : > "$f"
  if ! grep -Fqs "$add_path_line" "$f"; then
    printf "\n%s\n" "$add_path_line" >> "$f"
    updated_any=1
  fi
done

echo "✅ Listo."
if command -v "$BIN_NAME" >/dev/null 2>&1; then
  echo "👉 Ejecuta: ${BIN_NAME}"
else
  echo "👉 Ejecuta ya: ${TARGET_PATH}"
  if [[ $updated_any -eq 1 ]]; then
    echo "ℹ️ Para que el comando quede disponible sin ruta, abre una nueva terminal"
    echo "   o recarga tu shell: source ~/.zshrc  (o source ~/.bashrc)"
  fi
fi
