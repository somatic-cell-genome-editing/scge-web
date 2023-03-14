package edu.mcw.scge.service.es;

import edu.mcw.scge.web.SCGEContext;
import io.netty.util.internal.InternalThreadLocalMap;
import org.apache.http.HttpHost;
import org.apache.http.client.config.RequestConfig;
import org.elasticsearch.client.RestClient;
import org.elasticsearch.client.RestClientBuilder;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.client.RestHighLevelClientBuilder;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class ESClient {
    private static RestHighLevelClient client=null;

    public static RestHighLevelClient init(){
        if(client==null) {
         try{

                if(SCGEContext.isProduction() || SCGEContext.isTest()){
;                   InputStream input= new FileInputStream("/data/properties/elasticsearchProps.properties");
                    Properties props= new Properties();
                    props.load(input);
                    String HOST1 = (String) props.get("HOST1");
                    String HOST2 = (String) props.get("HOST2");
                    String HOST3 = (String) props.get("HOST3");
                    String HOST4 = (String) props.get("HOST4");
                    String HOST5 = (String) props.get("HOST5");
                    //    String VARIANTS_HOST= (String) props.get("HOST1");
                    int port = Integer.parseInt((String) props.get("PORT"));
                    client = new RestHighLevelClientBuilder(
                            RestClient.builder(
                                    new HttpHost(HOST1, port, "http"),
                    new HttpHost(HOST2, port, "http"),
                    new HttpHost(HOST3, port, "http"),
                    new HttpHost(HOST4, port, "http") ,
                                    new HttpHost(HOST5, port, "http")
                            ).setRequestConfigCallback(
                                    new RestClientBuilder.RequestConfigCallback() {
                                        @Override
                                        public RequestConfig.Builder customizeRequestConfig(
                                                RequestConfig.Builder requestConfigBuilder) {
                                            return requestConfigBuilder
                                                    .setConnectTimeout(5000)
                                                    .setSocketTimeout(120000)
                                                    .setConnectionRequestTimeout(0);
                                        }

                                    }
                            ).build()
                    ).setApiCompatibilityMode(true).build();
                }else {
                    String DEV_HOST = "travis.rgd.mcw.edu";
                    int port = 9200;
                    client = new RestHighLevelClientBuilder(
                            RestClient.builder(
                                    new HttpHost(DEV_HOST, port, "http")
                            ).setRequestConfigCallback(
                                    new RestClientBuilder.RequestConfigCallback() {
                                        @Override
                                        public RequestConfig.Builder customizeRequestConfig(
                                                RequestConfig.Builder requestConfigBuilder) {
                                            return requestConfigBuilder
                                                    .setConnectTimeout(5000)
                                                    .setSocketTimeout(120000)
                                                    .setConnectionRequestTimeout(0);
                                        }

                                    }
                            ).build()
                    ).setApiCompatibilityMode(true).build();
                }
            }catch (Exception e){
                e.printStackTrace();
            }

        }
        return client;
    }
    public synchronized void destroy() throws IOException {
        System.out.println("destroying Variants Elasticsearch Client...");
        if(client!=null) {
            client.close();
            //   client.threadPool().shutdownNow();
            InternalThreadLocalMap.remove();
            client=null;


        }
    }

    public static RestHighLevelClient getClient() {
        if(client==null) {
         init();
        }
        return client;
    }
}
