package com.lepham.cinema.validator;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;


public class StringValidator implements ConstraintValidator<StringConstraint,String> {
    @Override
    public void initialize(StringConstraint constraintAnnotation) {
        ConstraintValidator.super.initialize(constraintAnnotation);
    }

    @Override
    public boolean isValid(String value, ConstraintValidatorContext context) {
        if(value==null) return false;
        return !value.trim().isEmpty();
    }
}
