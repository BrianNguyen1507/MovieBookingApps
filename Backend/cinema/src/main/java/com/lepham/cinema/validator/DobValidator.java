package com.lepham.cinema.validator;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class DobValidator implements ConstraintValidator<DobConstraint, LocalDate> {
    private int min;
    @Override
    public void initialize(DobConstraint constraintAnnotation) {
        ConstraintValidator.super.initialize(constraintAnnotation);
        min = constraintAnnotation.min();

    }

    @Override
    public boolean isValid(LocalDate value, ConstraintValidatorContext context) {
        long year = ChronoUnit.YEARS.between(value,LocalDate.now());
        return year>= min;
    }
}
