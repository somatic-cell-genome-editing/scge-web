package edu.mcw.scge.storage;


import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Component;

//@ConfigurationProperties("storage")
@Configuration
@Component
@PropertySource("classpath:application.properties")
public class StorageProperties {

	/**
	 * Folder location for storing files
	 */
	private String location = "/data/scge_submissions";
	//private String location = "/Users/jdepons/upload-dir";
	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

}