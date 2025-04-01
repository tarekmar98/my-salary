package my_salary.converter;

import jakarta.persistence.Converter;
import my_salary.classes.OverTimeInfo;
import my_salary.service.GenericJsonConverter;

@Converter(autoApply = true)
public class OverTimeInfoConverter extends GenericJsonConverter<OverTimeInfo> {

    public OverTimeInfoConverter() {
        super(OverTimeInfo.class);
    }
}