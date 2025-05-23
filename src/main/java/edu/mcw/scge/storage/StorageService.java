package edu.mcw.scge.storage;

import org.springframework.core.io.Resource;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.nio.file.Path;
import java.util.stream.Stream;

@Component
public interface StorageService {

	void init();

	void store(MultipartFile file);

	Stream<Path> loadAll();

	Stream<Path> loadAll(String studyId);

	Path load(String filename);

	Resource loadAsResource(String filename);

	void deleteAll();

}
