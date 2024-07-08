package com.lepham.cinema.repository;

import com.lepham.cinema.entity.AccountEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface AccountRepository extends JpaRepository<AccountEntity, Long> {
    boolean existsByEmailAndActive(String email, int active);


    Optional<AccountEntity> findByEmail(String email);

    List<AccountEntity> findAllByActiveAndRole(int active, String role);

    AccountEntity findByIdAndActive(long id, int active);
}
