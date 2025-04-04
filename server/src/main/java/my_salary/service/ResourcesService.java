package my_salary.service;

import org.springframework.stereotype.Service;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.File;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;

@Service
public class ResourcesService {
    ObjectMapper objectMapper;
    Map<String, List<String>> countries;
    List<String> languages;
    List<String> religions;
    List<String> workTypes;
    Map<String, Integer> statics;

    public ResourcesService() {
        this.objectMapper = new ObjectMapper();
        try {
            String resourcesRoot = Paths.get("").toAbsolutePath() +
                    "\\server\\src\\main\\java\\my_salary\\resources\\";
            this.countries = objectMapper.readValue(
                    new File(resourcesRoot, "countries.json"),
                    Map.class
            );

            Map<String, List<String>> languagesMap = objectMapper.readValue(
                    new File(resourcesRoot, "languages.json"),
                    Map.class
            );
            this.languages = languagesMap.get("languages");

            Map<String, List<String>> religionsMap = objectMapper.readValue(
                    new File(resourcesRoot, "religions.json"),
                    Map.class
            );
            this.religions = religionsMap.get("religions");

            Map<String, List<String>> workTypesMap = objectMapper.readValue(
                    new File(resourcesRoot, "workTypes.json"),
                    Map.class
            );
            this.workTypes = workTypesMap.get("workTypes");

            this.statics = objectMapper.readValue(
                    new File(resourcesRoot, "statics.json"),
                    Map.class
            );

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean isValidCountry(String country) {
        return countries.containsKey(country);
    }

    public boolean isValidCity(String country, String city) {
        return countries.get(country).contains(city);
    }

    public boolean isValidLanguage(String language) {
        return languages.contains(language);
    }

    public boolean isValidReligion(String religion) {
        return religions.contains(religion);
    }

    public boolean isValidWorkType(String workType) {
        return workTypes.contains(workType);
    }
}
