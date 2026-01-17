package com.example.API_menu_online.config;

import jakarta.persistence.EntityManagerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.dao.annotation.PersistenceExceptionTranslationPostProcessor;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.JpaVendorAdapter;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

import javax.sql.DataSource;
import java.util.Properties;
import java.util.logging.Logger;

@Configuration
@EnableTransactionManagement
// @EnableJpaRepositories removed - using custom repository implementation instead
@PropertySource("classpath:application.properties")
@ComponentScan(basePackages = {
    "com.example.API_menu_online.service",
    "com.example.API_menu_online.service.impl",
    "com.example.API_menu_online.repository",
    "com.example.API_menu_online.repository.impl",
    "com.example.API_menu_online.entity",
    "com.example.API_menu_online.util"
    // Note: config package is excluded to avoid circular dependency
    // Config classes are imported via RootConfig
})
public class AppConfig {

    private static final Logger logger = Logger.getLogger(AppConfig.class.getName());

    @Value("${spring.jpa.hibernate.ddl-auto:none}")
    private String hibernateDdlAuto;

    @Value("${spring.jpa.show-sql:false}")
    private String hibernateShowSql;

    @Value("${spring.jpa.properties.hibernate.dialect:org.hibernate.dialect.MySQL8Dialect}")
    private String hibernateDialect;

    @Bean
    public LocalContainerEntityManagerFactoryBean entityManagerFactory(DataSource dataSource) {
        logger.info("=== AppConfig: Creating EntityManagerFactory ===");
        LocalContainerEntityManagerFactoryBean em = new LocalContainerEntityManagerFactoryBean();
        em.setDataSource(dataSource);
        em.setPackagesToScan("com.example.API_menu_online.entity");

        JpaVendorAdapter vendorAdapter = new HibernateJpaVendorAdapter();
        em.setJpaVendorAdapter(vendorAdapter);

        Properties properties = new Properties();
        properties.setProperty("hibernate.hbm2ddl.auto", hibernateDdlAuto);
        properties.setProperty("hibernate.show_sql", hibernateShowSql);
        properties.setProperty("hibernate.dialect", hibernateDialect);
        properties.setProperty("hibernate.format_sql", "true");
        properties.setProperty("hibernate.use_sql_comments", "true");
        // UTF-8 encoding for Hibernate
        properties.setProperty("hibernate.connection.characterEncoding", "UTF-8");
        properties.setProperty("hibernate.connection.useUnicode", "true");
        properties.setProperty("hibernate.connection.CharSet", "UTF-8");
        em.setJpaProperties(properties);

        logger.info("=== AppConfig: EntityManagerFactory created successfully ===");
        return em;
    }

    @Bean
    public PlatformTransactionManager transactionManager(EntityManagerFactory emf) {
        logger.info("=== AppConfig: Creating TransactionManager ===");
        JpaTransactionManager transactionManager = new JpaTransactionManager();
        transactionManager.setEntityManagerFactory(emf);
        logger.info("=== AppConfig: TransactionManager created successfully ===");
        return transactionManager;
    }

    @Bean
    public PersistenceExceptionTranslationPostProcessor exceptionTranslation() {
        return new PersistenceExceptionTranslationPostProcessor();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}

