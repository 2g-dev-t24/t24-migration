package com.uala.client.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@ConfigurationProperties(prefix = "ofs.service")
public class OFSConfig {

    private String url;
    private String username;
    private String password;
    private String tenant;

    // Getters y Setters
    public String getUrl() { return url; }
    public void setUrl(String url) { this.url = url; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getTenant() { return tenant; }
    public void setTenant(String tenant) { this.tenant = tenant; }
}
