package com.lepham.cinema.validator;


import jakarta.validation.Constraint;
import jakarta.validation.Payload;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Constraint(validatedBy = {StringValidator.class})
@Target({ ElementType.FIELD, ElementType.PARAMETER })
@Retention(RetentionPolicy.RUNTIME)
public @interface StringConstraint {
    String message() default "Invalid string";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
