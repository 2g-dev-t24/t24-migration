package com.uala.client.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.uala.client.config.OfsProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.RestTemplate;

import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

@Service
public class OFSClientService {

    private final RestTemplate restTemplate;
    private final OfsProperties ofsProperties;

    @Autowired
    public OFSClientService(RestTemplate restTemplate, OfsProperties ofsProperties) {
        this.restTemplate = restTemplate;
        this.ofsProperties = ofsProperties;
    }

    public String callOFSService(String ofsRequest) {
        // URL del servicio OFS
        String url = ofsProperties.getUrl() + "/TAFJRestServices/resources/ofs";


        // Configurar el cuerpo de la solicitud
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("Authorization", "Basic " + Base64.getEncoder().encodeToString("t24user:t24User123!".getBytes()));

        // Crear el cuerpo de la solicitud
        Map<String, String> requestMap = new HashMap<>();

        requestMap.put("ofsRequest", ofsRequest);
        requestMap.put("tenantId", "default");

        // Crear la entidad de la solicitud
        HttpEntity<Map<String, String>> entity = new HttpEntity<>(requestMap, headers);

        try {
            // Hacer la solicitud
            ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.POST, entity, String.class);

            // Obtener el body como String
            String responseBody = response.getBody();

            // Parsear con Jackson
            ObjectMapper mapper = new ObjectMapper();
            JsonNode json = mapper.readTree(responseBody);

            // Extraer "ofsResponse"
            String ofsResponse = json.path("ofsResponse").asText();

            // Devolverlo como JSON plano
            ObjectNode result = mapper.createObjectNode();
            result.put("ofsResponse", ofsResponse);
            return result.toString();

        } catch (HttpClientErrorException | HttpServerErrorException e) {
            return "{\"error\": \"" + e.getStatusCode() + " - " + e.getResponseBodyAsString() + "\"}";
        } catch (Exception e) {
            return "{\"error\": \"Error parseando respuesta: " + e.getMessage() + "\"}";
        }
    }
}
