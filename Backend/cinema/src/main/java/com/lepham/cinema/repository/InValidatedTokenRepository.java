package com.lepham.cinema.repository;

import com.lepham.cinema.entity.InvalidatedToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface InValidatedTokenRepository extends JpaRepository<InvalidatedToken, String> {
}
