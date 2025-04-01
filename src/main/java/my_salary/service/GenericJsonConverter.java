package my_salary.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter
public class GenericJsonConverter<T> implements AttributeConverter<T, String> {

    private final Class<T> clazz;
    private final ObjectMapper objectMapper = new ObjectMapper();

    public GenericJsonConverter(Class<T> clazz) {
        this.clazz = clazz;
        objectMapper.registerModule(new JavaTimeModule());
    }

    @Override
    public String convertToDatabaseColumn(T attribute) {
        try {
            return objectMapper.writeValueAsString(attribute);
        } catch (JsonProcessingException e) {
            throw new IllegalArgumentException("Error converting POJO to JSON", e);
        }
    }

    @Override
    public T convertToEntityAttribute(String dbData) {
        try {
            return objectMapper.readValue(dbData, clazz);
        } catch (Exception e) {
            throw new IllegalArgumentException("Error converting JSON to POJO", e);
        }
    }
}
