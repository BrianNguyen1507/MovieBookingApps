package com.lepham.cinema.validator;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = IntegerValidator.class)
public @interface IntegerConstraint {
    String message() default "NUMBER_NOT_NEGATIVE";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
