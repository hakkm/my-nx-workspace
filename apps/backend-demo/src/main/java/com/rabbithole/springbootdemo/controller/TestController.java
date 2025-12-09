package com.rabbithole.springbootdemo.controller;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/test")
@CrossOrigin(origins = "*")
public class TestController {

  @GetMapping("/")
  public ResponseEntity<Map<String, Object>> index() {
    Map<String, Object> response = new HashMap<>();
    response.put("message", "Welcom to our monorepo backend");
    return ResponseEntity.ok(response);
  }

  @GetMapping("/hello")
  public ResponseEntity<Map<String, Object>> hello() {
    Map<String, Object> response = new HashMap<>();
    response.put("message", "Hello from Spring Boot!");
    response.put("timestamp", LocalDateTime.now());
    response.put("status", "success");
    return ResponseEntity.ok(response);
  }

  @GetMapping("/hello/{name}")
  public ResponseEntity<Map<String, Object>> helloWithName(@PathVariable String name) {
    Map<String, Object> response = new HashMap<>();
    response.put("message", "Hello, " + name + "!");
    response.put("timestamp", LocalDateTime.now());
    response.put("status", "success");
    return ResponseEntity.ok(response);
  }

  @GetMapping("/info")
  public ResponseEntity<Map<String, Object>> getInfo(
      @RequestParam(defaultValue = "Spring Boot Demo") String appName) {
    Map<String, Object> response = new HashMap<>();
    response.put("applicationName", appName);
    response.put("version", "1.0.0");
    response.put("timestamp", LocalDateTime.now());
    response.put("status", "running");
    response.put("framework", "Spring Boot");
    response.put("java.version", System.getProperty("java.version"));
    return ResponseEntity.ok(response);
  }

  @GetMapping("/health")
  public ResponseEntity<Map<String, Object>> healthCheck() {
    Map<String, Object> response = new HashMap<>();
    response.put("status", "UP");
    response.put("timestamp", LocalDateTime.now());
    response.put("uptime", System.currentTimeMillis());
    return ResponseEntity.ok(response);
  }
}
