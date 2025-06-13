package com.selimhorri.app.config;

import java.util.concurrent.TimeUnit;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import feign.Retryer;

/**
 * Configuración global de Feign que activa el patrón <b>Retry</b>.
 * Se reintenta hasta 3 veces con un intervalo inicial de 1 s y
 * un máximo de 5 s entre reintentos.
 */
@Configuration
public class FeignRetryConfiguration {

    @Bean
    public Retryer feignRetryer() {
        // Retryer.Default(period, maxPeriod, maxAttempts)
        return new Retryer.Default(
                1000L,                       // 1 s entre peticiones
                TimeUnit.SECONDS.toMillis(5),// Aumenta hasta 5 s
                3                            // Máximo 3 intentos
        );
    }
} 