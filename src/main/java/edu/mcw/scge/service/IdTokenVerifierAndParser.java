package edu.mcw.scge.service;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;

/**
 * Created by jthota on 8/15/2019.
 */
public class IdTokenVerifierAndParser {

    private static final   String GOOGLE_CLIENT_ID="";
    public static GoogleIdToken.Payload getPayload(String tokenString) throws Exception{
        JacksonFactory jacksonFactory=new JacksonFactory();
        GoogleIdTokenVerifier googleIdTokenVerifier= new GoogleIdTokenVerifier(new NetHttpTransport(), jacksonFactory);
        GoogleIdToken token=GoogleIdToken.parse(jacksonFactory, tokenString);
        if(googleIdTokenVerifier.verify(token)){
            GoogleIdToken.Payload payload=token.getPayload();
            if(!GOOGLE_CLIENT_ID.equals(payload.getAudience())){
                throw new IllegalArgumentException("Audience mismatch");
            }else if(!GOOGLE_CLIENT_ID.equals(payload.getAuthorizedParty())){
                throw new IllegalArgumentException("client ID mismatch");
            }
            return payload;
        }else {
            throw  new IllegalArgumentException("ID token cannot be verified");
        }
    }

}
