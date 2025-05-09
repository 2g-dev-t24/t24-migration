#!/bin/ksh

# Archivo de salida
OUTPUT_FILE="campos_users.txt"

LIST FBNK.USER > "$OUTPUT_FILE"

# Verificar si se generó correctamente
if [ -s "$OUTPUT_FILE" ]; then
    echo "Archivo generado: $OUTPUT_FILE"
else
    echo "Error: no se pudo generar el archivo o está vacío"
fi