package com.example.API_menu_online.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;

import javax.sql.DataSource;
import java.util.logging.Logger;

@Configuration
@PropertySource("classpath:application.properties")
public class MySqlConfig {

    private static final Logger logger = Logger.getLogger(MySqlConfig.class.getName());

    @Value("${spring.datasource.url}")
    private String jdbcUrl;

    @Value("${spring.datasource.username}")
    private String jdbcUsername;

    @Value("${spring.datasource.password}")
    private String jdbcPassword;

    @Value("${spring.datasource.driver-class-name}")
    private String jdbcDriver;

    @Bean
    public DataSource dataSource() {
        logger.info("=== MySqlConfig: Creating DataSource ===");
        try {
            logger.info("JDBC URL: " + (jdbcUrl != null ? jdbcUrl : "NULL"));
            logger.info("Username: " + (jdbcUsername != null ? jdbcUsername : "NULL"));
            logger.info("Driver: " + (jdbcDriver != null ? jdbcDriver : "NULL"));
            
            if (jdbcUrl == null || jdbcUrl.startsWith("${")) {
                throw new IllegalStateException("JDBC URL not resolved: " + jdbcUrl);
            }
            if (jdbcDriver == null || jdbcDriver.startsWith("${")) {
                throw new IllegalStateException("JDBC Driver not resolved: " + jdbcDriver);
            }
            
            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(jdbcUrl);
            config.setUsername(jdbcUsername);
            config.setPassword(jdbcPassword);
            config.setDriverClassName(jdbcDriver);
            config.setMaximumPoolSize(10);
            config.setMinimumIdle(5);
            config.setConnectionTimeout(30000);
            config.setIdleTimeout(600000);
            config.setMaxLifetime(1800000);
            // Set connection properties for UTF-8
            config.addDataSourceProperty("useUnicode", "true");
            config.addDataSourceProperty("characterEncoding", "UTF-8");
            config.addDataSourceProperty("connectionCollation", "utf8mb4_unicode_ci");
            HikariDataSource dataSource = new HikariDataSource(config);
            logger.info("=== MySqlConfig: DataSource created successfully ===");
            return dataSource;
        } catch (Exception e) {
            logger.severe("=== MySqlConfig: Error creating DataSource: " + e.getMessage() + " ===");
            logger.severe("=== MySqlConfig: Exception class: " + e.getClass().getName() + " ===");
            e.printStackTrace();
            throw new RuntimeException("Failed to create DataSource", e);
        }
    }

    @Bean
    public static PropertySourcesPlaceholderConfigurer propertySourcesPlaceholderConfigurer() {
        logger.info("=== MySqlConfig: Creating PropertySourcesPlaceholderConfigurer ===");
        return new PropertySourcesPlaceholderConfigurer();
    }
}

