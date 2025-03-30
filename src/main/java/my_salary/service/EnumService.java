package my_salary.service;

public class EnumService {
    public static <E extends Enum<E>> boolean isValidEnum(Class<E> enumClass, String value) {
        for (E e : enumClass.getEnumConstants()) {
            if (e.name().equals(value)) {
                return true;
            }
        }
        return false;
    }
}
