package com.uala.client.controller;

import com.uala.client.service.OFSClientService;
import com.uala.client.model.OFSRequestDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

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
}
