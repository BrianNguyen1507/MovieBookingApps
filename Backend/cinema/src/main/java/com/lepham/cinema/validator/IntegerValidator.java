package com.lepham.cinema.validator;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

import java.util.Objects;

public class IntegerValidator implements ConstraintValidator<IntegerConstraint,Integer> {

    @Override
    public void initialize(IntegerConstraint constraintAnnotation) {
        ConstraintValidator.super.initialize(constraintAnnotation);

    }

    @Override
    public boolean isValid(Integer value, ConstraintValidatorContext context) {
        return value>0;
    }
}
