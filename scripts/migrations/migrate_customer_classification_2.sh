#!/bin/ksh

# Archivo de salida
OUTPUT_FILE="campos_customer_classification_2.txt"

LIST FBNK.CUSTOMER WITH CLASSIFICATION EQ 2 > "$OUTPUT_FILE"

# Verificar si se generó correctamente
if [ -s "$OUTPUT_FILE" ]; then
    echo "Archivo generado: $OUTPUT_FILE"
else
    echo "Error: no se pudo generar el archivo o está vacío"
fi