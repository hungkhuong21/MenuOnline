package com.example.API_menu_online.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

/**
 * RootConfig - Main configuration class that imports other configuration classes
 * This follows the Spring MVC architecture pattern similar to the reference project
 */
@Configuration
@Import({
    MySqlConfig.class, 
    PropertyConfig.class, 
    AppConfig.class
})
public class RootConfig {
    // This class now acts as a configuration aggregator
    // All actual configuration is delegated to specialized config classes:
    // - MySqlConfig: Database configuration
    // - AppConfig: Application context, JPA, and component scanning
    // - PropertyConfig: Property file configuration
}

