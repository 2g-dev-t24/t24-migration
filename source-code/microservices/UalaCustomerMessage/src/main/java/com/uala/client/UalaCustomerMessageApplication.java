package com.uala.client;

import com.uala.client.config.OFSConfig;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.context.properties.ConfigurationPropertiesScan;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

@SpringBootApplication
@ConfigurationPropertiesScan("com.uala.client.config")
public class UalaCustomerMessageApplication extends SpringBootServletInitializer {

    public static void main(String[] args) {
        SpringApplication.run(UalaCustomerMessageApplication.class, args);
    }

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(UalaCustomerMessageApplication.class);
    }
}