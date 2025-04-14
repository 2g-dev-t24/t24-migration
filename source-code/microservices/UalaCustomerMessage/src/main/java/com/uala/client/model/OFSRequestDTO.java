package com.uala.client.model;

public class OFSRequestDTO {
    private String message; // Cambio de nombre de ofsRequest a message
    private String tenantId = "default"; // Valor fijo para tenantId

    // Getters y Setters
    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getTenantId() {
        return tenantId;
    }

    public void setTenantId(String tenantId) {
        // No se va a modificar el valor del tenantId, ya que siempre será "default"
        this.tenantId = "default"; // No permite cambiarlo
    }
}
