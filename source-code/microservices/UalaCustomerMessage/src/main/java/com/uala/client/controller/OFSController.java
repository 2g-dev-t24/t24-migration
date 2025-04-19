package com.uala.client.controller;

import com.uala.client.model.CiudadMigrator;
import com.uala.client.service.OFSClientService;
import com.uala.client.model.OFSRequestDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

@RestController
@RequestMapping("/customer")
public class OFSController {

    private final OFSClientService ofsClientService;

    @Autowired
    public OFSController(OFSClientService ofsClientService) {
        this.ofsClientService = ofsClientService;
    }

    /**
     * Endpoint que recibe el POST y hace una llamada al servicio OFS.
     * @param ofsRequestDTO El cuerpo de la solicitud.
     * @return La respuesta del servicio OFS.
     */
    @PostMapping
    public ResponseEntity<String> callOFS(@RequestBody OFSRequestDTO ofsRequestDTO) {
        // Llamar al servicio que envía la solicitud al servicio OFS
        String response = ofsClientService.callOFSService(ofsRequestDTO.getMessage());
        return ResponseEntity.ok(response); // Retorna la respuesta del servicio OFS
    }


    @PostMapping("/ciudad")
    public ResponseEntity<String> generarArchivoDeMensajes() {
        try {
            CiudadMigrator.generarArchivoSalida();
            return ResponseEntity.ok("Archivo generado correctamente en /resources/salida.txt");
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error generando el archivo: " + e.getMessage());
        }
    }
}
