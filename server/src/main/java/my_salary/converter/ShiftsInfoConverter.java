package my_salary.converter;

import jakarta.persistence.Converter;
import my_salary.classes.ShiftsInfo;
import my_salary.service.GenericJsonConverter;

@Converter(autoApply = true)
public class ShiftsInfoConverter extends GenericJsonConverter<ShiftsInfo>{

    public ShiftsInfoConverter() {
        super(ShiftsInfo.class);
    }
}
