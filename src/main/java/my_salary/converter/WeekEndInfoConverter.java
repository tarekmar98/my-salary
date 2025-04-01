package my_salary.converter;

import jakarta.persistence.Converter;
import my_salary.classes.WeekEndInfo;
import my_salary.service.GenericJsonConverter;

@Converter(autoApply = true)
public class WeekEndInfoConverter extends GenericJsonConverter<WeekEndInfo> {

    public WeekEndInfoConverter() {
        super(WeekEndInfo.class);
    }
}
