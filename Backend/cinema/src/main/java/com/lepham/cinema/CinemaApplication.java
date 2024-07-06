package com.lepham.cinema;

import com.lepham.cinema.entity.MovieTheaterEntity;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class CinemaApplication {
	public static void main(String[] args) {
		SpringApplication.run(CinemaApplication.class, args);
	}

}
