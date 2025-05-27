package edu.mcw.scge.configuration;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;

import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.HeadersConfigurer;
import org.springframework.security.config.oauth2.client.CommonOAuth2Provider;


import org.springframework.security.oauth2.client.InMemoryOAuth2AuthorizedClientService;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientService;


import org.springframework.security.oauth2.client.endpoint.OAuth2AccessTokenResponseClient;
import org.springframework.security.oauth2.client.endpoint.OAuth2AuthorizationCodeGrantRequest;
import org.springframework.security.oauth2.client.endpoint.RestClientAuthorizationCodeTokenResponseClient;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;
import org.springframework.security.oauth2.client.registration.InMemoryClientRegistrationRepository;

import org.springframework.security.oauth2.client.web.AuthenticatedPrincipalOAuth2AuthorizedClientRepository;


import org.springframework.security.oauth2.client.web.OAuth2AuthorizedClientRepository;

import org.springframework.security.web.SecurityFilterChain;

import org.springframework.security.web.csrf.CookieCsrfTokenRepository;

import org.springframework.security.web.servlet.util.matcher.PathPatternRequestMatcher;
import org.springframework.web.multipart.support.StandardServletMultipartResolver;



import java.util.List;

import java.util.Objects;
import java.util.stream.Collectors;



/**
 * Created by jthota on 11/12/2019.
 */
@Configuration
@EnableWebSecurity
@PropertySource("classpath:application.properties")
public class SecurityConfiguration  {
    @Autowired
    private Environment env;
    public static final Boolean REQUIRE_AUTHENTICATION=false;
    public static final int GUEST_ACCOUNT_ID=1888;
    private final static String CLIENT_PROPERTY_KEY = "spring.security.oauth2.client.registration.";

    private final static List<String> clients = List.of("google");
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        if (SecurityConfiguration.REQUIRE_AUTHENTICATION) {
            http.authorizeHttpRequests(authorize -> authorize
                            .requestMatchers("/", "/home", "/logout", "/oauth_login", "/common/**", "/data/requestAccount", "/loginFailure", "/images/**").permitAll()
                            .anyRequest().authenticated());
        }else{
            http.authorizeHttpRequests(authorize -> authorize
                            .anyRequest().permitAll());
        }
       http .oauth2Login(auth2->auth2
                .loginPage("/loginSuccessPage")
                .failureUrl("/loginFailure")
                .defaultSuccessUrl("/loginSuccessPage", true)
                .clientRegistrationRepository(clientRegistrationRepository())
                .authorizedClientService(authorizedClientService(clientRegistrationRepository()))
                .authorizationEndpoint(authorization->authorization.baseUri("/login"))
                .tokenEndpoint(tokenEndpointConfig -> tokenEndpointConfig.accessTokenResponseClient(accessTokenResponseClient())))
                .logout(logout -> logout
                        .logoutRequestMatcher(PathPatternRequestMatcher.withDefaults().matcher("/logout"))
                        .logoutSuccessUrl("/") // Redirect after logout
                        .invalidateHttpSession(true) // Invalidate the session
                        .deleteCookies("JSESSIONID") // Delete cookies
                ).csrf(csrf->csrf.csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse()));
        http.headers(headers->headers.cacheControl(HeadersConfigurer.CacheControlConfig::disable));
        return http.build();
    }

    @Bean
    public ClientRegistrationRepository clientRegistrationRepository() {
        List<ClientRegistration> registrations = clients.stream()
                .map(this::getRegistration)
                .filter(Objects::nonNull)
                .collect(Collectors.toList());

        return new InMemoryClientRegistrationRepository(registrations);
    }

    private ClientRegistration getRegistration(String client) {
        String clientId = env.getProperty(
                CLIENT_PROPERTY_KEY + client + ".client-id");

        String clientSecret = env.getProperty(
                CLIENT_PROPERTY_KEY + client + ".client-secret");

        if (client.equals("google")) {
            return CommonOAuth2Provider.GOOGLE.getBuilder(client)
                    .clientId(clientId).clientSecret(clientSecret).build();
        }

        return null;
    }
    @Bean
    public OAuth2AuthorizedClientService authorizedClientService(
            ClientRegistrationRepository clientRegistrationRepository) {
        return new InMemoryOAuth2AuthorizedClientService(clientRegistrationRepository);
    }

    @Bean
    public OAuth2AuthorizedClientRepository authorizedClientRepository(
            OAuth2AuthorizedClientService authorizedClientService) {
        return new AuthenticatedPrincipalOAuth2AuthorizedClientRepository(authorizedClientService);
    }
    @Bean
    public OAuth2AccessTokenResponseClient<OAuth2AuthorizationCodeGrantRequest> accessTokenResponseClient() {
        return new RestClientAuthorizationCodeTokenResponseClient();
    }

    @Bean(name = "filterMultipartResolver")
    public StandardServletMultipartResolver multipartResolver() {
        StandardServletMultipartResolver multipartResolver = new StandardServletMultipartResolver();
        //  multipartResolver.setMaxUploadSize(100000000);
        return multipartResolver;
    }
}
