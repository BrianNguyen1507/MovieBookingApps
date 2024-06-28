package com.lepham.cinema.repository;

import com.lepham.cinema.entity.CategoryEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;


public interface CategoryRepository extends JpaRepository<CategoryEntity, Long> {
	@Query(value = "SELECT c FROM CategoryEntity c INNER JOIN  c.films f WHERE f.id = ?1")
	List<CategoryEntity> findAllByFilmEntityId(long filmId);

	Optional<CategoryEntity> findByName(String name);
	
}
