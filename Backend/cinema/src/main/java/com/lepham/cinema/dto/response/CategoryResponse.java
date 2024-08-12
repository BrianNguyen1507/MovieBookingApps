package com.lepham.cinema.dto.response;

import lombok.*;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Slf4j
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class CategoryResponse {
	long id;
	String name;
	
}
