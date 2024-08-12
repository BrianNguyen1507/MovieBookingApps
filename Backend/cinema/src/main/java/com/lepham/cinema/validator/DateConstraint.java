package com.lepham.cinema.validator;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target({ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = {DateValidator.class})
public @interface DateConstraint {
    String message() default "INVALID_DATE";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
