package com.lepham.cinema.validator;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;

public class CustomDoubleSerializer extends JsonSerializer<Double> {
    @Override
    public void serialize(Double aDouble, JsonGenerator jsonGenerator, SerializerProvider serializerProvider) throws IOException {
        if (aDouble == null) {
            jsonGenerator.writeNull();
        } else {
            if (aDouble == aDouble.longValue()) {
                jsonGenerator.writeNumber(aDouble.longValue());
            } else {
                jsonGenerator.writeNumber(aDouble);
            }
        }
    }
}
