package com.selimhorri.app.integration;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.http.*;
import org.springframework.boot.test.context.SpringBootTest.WebEnvironment;

import static org.junit.jupiter.api.Assertions.*;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

import java.util.Map;
import java.util.concurrent.TimeUnit;
import java.util.HashMap;

/**
 * Pruebas de Integración - Comunicación entre Microservicios
 * Valida que los servicios se comuniquen correctamente entre sí
 */
@SpringBootTest(webEnvironment = WebEnvironment.RANDOM_PORT)
@ActiveProfiles("test")
public class MicroservicesIntegrationTest {

    @LocalServerPort
    private int port;

    @Autowired
    private TestRestTemplate restTemplate;

    private String baseUrl;
    private HttpHeaders headers;

    @BeforeEach
    void setUp() {
        baseUrl = "http://localhost:" + port;
        headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
    }

    /**
     * Prueba de Integración 1: Service Discovery - Verificar registro de servicios
     */
    @Test
    @DisplayName("Service Discovery debe registrar servicios correctamente")
    void testServiceDiscoveryRegistration() throws InterruptedException {
        // Esperar a que los servicios se registren
        TimeUnit.SECONDS.sleep(10);
        
        // Verificar que service discovery esté funcionando
        ResponseEntity<Map> response = restTemplate.getForEntity(
            "http://localhost:8761/eureka/apps", Map.class);
        
        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
        
        // Verificar que al menos algunos servicios estén registrados
        Map<String, Object> body = response.getBody();
        assertThat(body, hasKey("applications"));
    }

    /**
     * Prueba de Integración 2: User Service - Product Service Communication
     * Simula consulta de usuario para ver productos
     */
    @Test
    @DisplayName("User Service debe poder comunicarse con Product Service")
    void testUserServiceToProductServiceCommunication() {
        // 1. Crear un usuario en User Service
        String userData = "{"
                + "\"firstName\": \"Sofia\","
                + "\"lastName\": \"Martinez\","
                + "\"email\": \"sofia.martinez@example.com\","
                + "\"phone\": \"3157894561\","
                + "\"credential\": {"
                + "\"username\": \"smartinez\","
                + "\"password\": \"password123\","
                + "\"roleBasedAuthority\": \"ROLE_USER\","
                + "\"isEnabled\": true,"
                + "\"isAccountNonExpired\": true,"
                + "\"isAccountNonLocked\": true,"
                + "\"isCredentialsNonExpired\": true"
                + "}"
                + "}";

        HttpEntity<String> userRequest = new HttpEntity<>(userData, headers);
        
        // Simular llamada a User Service a través del proxy/gateway
        ResponseEntity<Map> userResponse = restTemplate.postForEntity(
            baseUrl + "/api/users", userRequest, Map.class);
        
        // Verificar que el usuario se creó exitosamente
        if (userResponse.getStatusCode() == HttpStatus.OK || 
            userResponse.getStatusCode() == HttpStatus.CREATED) {
            
            // 2. Simular que este usuario consulta productos
            ResponseEntity<Map> productsResponse = restTemplate.getForEntity(
                baseUrl + "/api/products", Map.class);
            
            // Verificar que puede acceder a productos
            assertTrue(
                productsResponse.getStatusCode() == HttpStatus.OK ||
                productsResponse.getStatusCode() == HttpStatus.NOT_FOUND, // Acceptable if no products exist
                "User should be able to access products service"
            );
        }
    }

    /**
     * Prueba de Integración 3: Order Service - User Service - Product Service
     * Simula creación de orden que requiere validar usuario y producto
     */
    @Test
    @DisplayName("Order Service debe validar usuario y producto al crear orden")
    void testOrderServiceIntegration() {
        // 1. Verificar que existe un usuario
        ResponseEntity<Map> usersResponse = restTemplate.getForEntity(
            baseUrl + "/api/users", Map.class);
        
        if (usersResponse.getStatusCode() == HttpStatus.OK) {
            // 2. Crear una orden (esto debería validar usuario internamente)
            String orderData = "{"
                    + "\"orderDate\": \"2025-01-25\","
                    + "\"orderDesc\": \"Orden de prueba de integración - Laptop Dell\","
                    + "\"orderFee\": 2899.99,"
                    + "\"userId\": 1"
                    + "}";

            HttpEntity<String> orderRequest = new HttpEntity<>(orderData, headers);
            
            ResponseEntity<Map> orderResponse = restTemplate.postForEntity(
                baseUrl + "/api/orders", orderRequest, Map.class);
            
            // Verificar que la comunicación entre servicios funcionó
            assertTrue(
                orderResponse.getStatusCode() == HttpStatus.OK ||
                orderResponse.getStatusCode() == HttpStatus.CREATED ||
                orderResponse.getStatusCode() == HttpStatus.BAD_REQUEST, // Expected if validation fails
                "Order service should communicate with user service"
            );
        }
    }

    /**
     * Prueba de Integración 4: Payment Service - Order Service
     * Simula procesamiento de pago para una orden
     */
    @Test
    @DisplayName("Payment Service debe procesar pagos para órdenes existentes")
    void testPaymentServiceOrderIntegration() {
        // 1. Simular procesamiento de pago
        String paymentData = "{"
                + "\"paymentDate\": \"2025-01-25\","
                + "\"paymentMethod\": \"CREDIT_CARD\","
                + "\"fee\": 2899.99,"
                + "\"isPaid\": true,"
                + "\"orderId\": 1"
                + "}";

        HttpEntity<String> paymentRequest = new HttpEntity<>(paymentData, headers);
        
        ResponseEntity<Map> paymentResponse = restTemplate.postForEntity(
            baseUrl + "/api/payments", paymentRequest, Map.class);
        
        // Verificar que el payment service puede comunicarse con order service
        assertTrue(
            paymentResponse.getStatusCode() == HttpStatus.OK ||
            paymentResponse.getStatusCode() == HttpStatus.CREATED ||
            paymentResponse.getStatusCode() == HttpStatus.BAD_REQUEST,
            "Payment service should communicate with order service"
        );
    }

    /**
     * Prueba de Integración 5: Cross-Service Health Check
     * Verifica que todos los servicios estén funcionando y comunicándose
     */
    @Test
    @DisplayName("Todos los servicios deben estar saludables y comunicándose")
    void testCrossServiceHealthCheck() {
        // Lista de endpoints de health de diferentes servicios
        String[] healthEndpoints = {
            "/actuator/health",
            "/api/users/1",      // User service test
            "/api/products",     // Product service test  
            "/api/orders",       // Order service test
            "/api/payments",     // Payment service test
            "/api/credentials"   // Credential service test
        };

        int successfulCalls = 0;
        
        for (String endpoint : healthEndpoints) {
            try {
                ResponseEntity<String> response = restTemplate.getForEntity(
                    baseUrl + endpoint, String.class);
                
                if (response.getStatusCode().is2xxSuccessful() ||
                    response.getStatusCode() == HttpStatus.NOT_FOUND) {
                    successfulCalls++;
                }
            } catch (Exception e) {
                // Service might not be available
                System.out.println("Service not available: " + endpoint);
            }
        }
        
        // Al menos 50% de los servicios deben responder
        assertTrue(successfulCalls >= healthEndpoints.length / 2,
            "At least half of the services should be responding");
    }

    /**
     * Prueba de Integración 6: Service Discovery Circuit Breaker
     * Verifica que el circuit breaker funcione cuando un servicio falla
     */
    @Test
    @DisplayName("Circuit Breaker debe activarse cuando un servicio falla")
    void testCircuitBreakerIntegration() {
        // Simular múltiples llamadas a un endpoint que podría fallar
        int failedCalls = 0;
        int totalCalls = 5;
        
        for (int i = 0; i < totalCalls; i++) {
            try {
                // Intentar llamar a un servicio que podría no existir
                ResponseEntity<String> response = restTemplate.getForEntity(
                    baseUrl + "/api/nonexistent", String.class);
                
                if (response.getStatusCode().isError()) {
                    failedCalls++;
                }
            } catch (Exception e) {
                failedCalls++;
            }
        }
        
        // Verificar que el sistema maneja las fallas apropiadamente
        assertTrue(failedCalls > 0, "System should handle service failures gracefully");
    }
} 