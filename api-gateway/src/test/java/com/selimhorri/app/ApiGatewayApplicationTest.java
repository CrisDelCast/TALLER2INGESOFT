package com.selimhorri.app;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class ApiGatewayApplicationTest {

    @Test
    void contextLoads() {
        // La prueba pasa si el contexto arranca correctamente
    }

    @Test
    void mainMethodRuns() {
        ApiGatewayApplication.main(new String[] {});
    }
} 