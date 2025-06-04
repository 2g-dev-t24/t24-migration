package com.uala.client.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.uala.client.config.OFSConfig;
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
    private final OFSConfig ofsConfig;

    @Autowired
    public OFSClientService(RestTemplate restTemplate, OFSConfig ofsConfig) {
        this.restTemplate = restTemplate;
        this.ofsConfig = ofsConfig;
    }

    public String callOFSService(String ofsRequest) {
        String url = ofsConfig.getUrl();

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        String auth = ofsConfig.getUsername() + ":" + ofsConfig.getPassword();
        headers.set("Authorization", "Basic " + Base64.getEncoder().encodeToString(auth.getBytes()));

        Map<String, String> requestMap = new HashMap<>();
        requestMap.put("ofsRequest", ofsRequest);
        requestMap.put("tenantId", ofsConfig.getTenant());

        HttpEntity<Map<String, String>> entity = new HttpEntity<>(requestMap, headers);

        try {
            ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.POST, entity, String.class);

            ObjectMapper mapper = new ObjectMapper();
            JsonNode json = mapper.readTree(response.getBody());

            ObjectNode result = mapper.createObjectNode();
            result.put("ofsResponse", json.path("ofsResponse").asText());
            return result.toString();

        } catch (HttpClientErrorException | HttpServerErrorException e) {
            return "{\"error\": \"" + e.getStatusCode() + " - " + e.getResponseBodyAsString() + "\"}";
        } catch (Exception e) {
            return "{\"error\": \"Error parseando respuesta: " + e.getMessage() + "\"}";
        }
    }
}
