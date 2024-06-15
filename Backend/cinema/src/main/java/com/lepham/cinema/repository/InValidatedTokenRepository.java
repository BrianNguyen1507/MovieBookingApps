package com.lepham.cinema.repository;

import com.lepham.cinema.entity.InvalidatedToken;
import org.springframework.data.jpa.repository.JpaRepository;

public interface InValidatedTokenRepository extends JpaRepository<InvalidatedToken, String> {
}
