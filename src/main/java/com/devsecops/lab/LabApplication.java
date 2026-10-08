package com.devsecops.lab;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class LabApplication {

    public static void main(String[] args) {
        SpringApplication.run(LabApplication.class, args);
    }

    @GetMapping("/")
    public String home() {
        return "DevSecOps CI/CD Lab is running.";
    }

    @GetMapping("/health")
    public String health() {
        return "UP";
    }
}