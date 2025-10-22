#!/bin/bash
# scripts/clean_xcode_cache.sh
# Limpia DerivedData y xcuserdata relacionadas con un proyecto Xcode.
# Uso:
#   ./scripts/clean_xcode_cache.sh --project TestApp4        # interactivo (pregunta antes de borrar)
#   ./scripts/clean_xcode_cache.sh --project TestApp4 --yes  # borra sin preguntar
#   ./scripts/clean_xcode_cache.sh --project TestApp4 --dry-run  # muestra lo que borraría

set -euo pipefail

PROJECT_NAME="TestApp4"
YES=0
DRY_RUN=0

usage() {
  cat <<EOF
Usage: $0 [--project NAME] [--yes] [--dry-run]

--project NAME   Nombre del proyecto (por defecto: TestApp4)
--yes            No pedir confirmación, borrar directamente
--dry-run        Mostrar qué se borraría sin eliminar
-h, --help       Mostrar esta ayuda
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)
      PROJECT_NAME="$2"
      shift 2
      ;;
    --yes)
      YES=1
      shift
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Argumento desconocido: $1"
      usage
      exit 1
      ;;
  esac
done

DERIVED_DIR="$HOME/Library/Developer/Xcode/DerivedData"

echo "Proyecto objetivo: $PROJECT_NAME"

echo "Buscando entradas de DerivedData que coincidan con '$PROJECT_NAME' en: $DERIVED_DIR"
MATCHES=$(ls -1 "$DERIVED_DIR" 2>/dev/null | grep -i "$PROJECT_NAME" || true)

if [[ -z "$MATCHES" ]]; then
  echo "No se encontraron entradas de DerivedData que coincidan con '$PROJECT_NAME'."
else
  echo "Entradas encontradas:"
  echo "$MATCHES"
  if [[ $DRY_RUN -eq 1 ]]; then
    echo "(dry-run) No se eliminará nada."
  else
    if [[ $YES -ne 1 ]]; then
      read -p "¿Eliminar las entradas anteriores? [y/N] " RESP
      case "$RESP" in
        [yY]|[yY][eE][sS]) true ;;
        *) echo "Cancelado por el usuario."; exit 0 ;;
      esac
    fi
    for entry in $MATCHES; do
      target="$DERIVED_DIR/$entry"
      echo "Eliminando: $target"
      rm -rf "$target"
    done
    echo "DerivedData limpio."
  fi
fi

# Limpiar xcuserdata dentro del repo (TestApp4.xcodeproj y project workspace si existen)
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "Buscando carpetas xcuserdata en el repo: $ROOT_DIR"
XCUSER_PATHS=$(find "$ROOT_DIR" -maxdepth 3 -type d -name xcuserdata 2>/dev/null || true)

if [[ -z "$XCUSER_PATHS" ]]; then
  echo "No se encontraron xcuserdata en el repo."
else
  echo "Se encontraron las siguientes rutas xcuserdata:"
  echo "$XCUSER_PATHS"
  if [[ $DRY_RUN -eq 1 ]]; then
    echo "(dry-run) No se eliminará nada."
  else
    if [[ $YES -ne 1 ]]; then
      read -p "¿Eliminar estas carpetas xcuserdata? [y/N] " RESP2
      case "$RESP2" in
        [yY]|[yY][eE][sS]) true ;;
        *) echo "Cancelado por el usuario."; exit 0 ;;
      esac
    fi
    while IFS= read -r path; do
      echo "Eliminando: $path"
      rm -rf "$path"
    done <<< "$XCUSER_PATHS"
    echo "xcuserdata eliminadas."
  fi
fi

echo "Operación completada."
