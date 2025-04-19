package com.uala.client.model;

import java.io.*;
import java.nio.file.*;
import java.util.*;

public class CiudadMigrator {

    public static List<String> generarMensajesDesdeArchivo() throws IOException {
        InputStream input = CiudadMigrator.class.getClassLoader()
                .getResourceAsStream("campos_vpm_ciudad_limpio.txt");

        if (input == null) {
            throw new FileNotFoundException("Archivo 'campos_vpm_ciudad_limpio.txt' no encontrado en resources");
        }

        BufferedReader reader = new BufferedReader(new InputStreamReader(input));
        List<String> lines = new ArrayList<>();
        String line;
        while ((line = reader.readLine()) != null) {
            lines.add(line);
        }

        List<String> mensajes = new ArrayList<>();
        List<String> registro = new ArrayList<>();
        String id = null;

        for (String l : lines) {
            l = l.trim();

            if (l.matches("(@?ID\\.\\.\\.\\.\\.\\.\\.\\.\\.\\.\\.+\\s+\\d+|ID\\.\\.\\.\\.\\.\\.\\.\\.\\.\\.\\.+\\s+\\d+)")) {
                if (!registro.isEmpty() && id != null) {
                    mensajes.add(generarMensaje(id, registro));
                    registro.clear();
                }
                id = l.replaceAll("[^0-9]", "");
            } else if (!l.isEmpty()) {
                registro.add(l);
            }
        }

        if (!registro.isEmpty() && id != null) {
            mensajes.add(generarMensaje(id, registro));
        }

        return mensajes;
    }

    private static String generarMensaje(String id, List<String> registro) {
        String ciudad = "", rango1 = "", rango2 = "", rango3 = "", rango4 = "";

        for (String campo : registro) {
            if (campo.startsWith("CIUDAD")) ciudad = extraerValor(campo);
            if (campo.startsWith("RANGO1")) rango1 = extraerValor(campo);
            if (campo.startsWith("RANGO2")) rango2 = extraerValor(campo);
            if (campo.startsWith("RANGO3")) rango3 = extraerValor(campo);
            if (campo.startsWith("RANGO4")) rango4 = extraerValor(campo);
        }

        return String.format("ABC.CIUDAD,REGISTRO/I/PROCESS//0,USER01/123456,%s,CIUDAD=%s,RANGO1=%s,RANGO2=%s,RANGO3=%s,RANGO4=%s",
                id, ciudad, rango1, rango2, rango3, rango4);
    }

    private static String extraerValor(String linea) {
        String[] parts = linea.split("\\.\\.\\.+");
        return parts.length > 1 ? parts[1].trim() : "";
    }
    public static void generarArchivoSalida() throws IOException {
        List<String> mensajes = generarMensajesDesdeArchivo();

        // Ruta al archivo de salida dentro de resources
        String rutaRelativa = "src/main/resources/salida.txt"; // desde el root del proyecto

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(rutaRelativa))) {
            for (String mensaje : mensajes) {
                writer.write(mensaje);
                writer.newLine();
            }
        }
    }
}

