package com.api.demo.service;

import com.google.auth.oauth2.GoogleCredentials;
import org.springframework.core.io.ClassPathResource;

public class TesteCredenciais {
    public static void main(String[] args) {
        try {
            GoogleCredentials credentials = GoogleCredentials
                    .fromStream(new ClassPathResource("credentials/credentials.json").getInputStream())
                    .createScoped("https://www.googleapis.com/auth/spreadsheets");

            credentials.refreshIfExpired();
            System.out.println("Token de acesso: " + credentials.getAccessToken().getTokenValue());

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
