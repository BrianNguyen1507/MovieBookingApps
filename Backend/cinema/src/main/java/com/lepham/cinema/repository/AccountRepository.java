package com.lepham.cinema.repository;

import com.lepham.cinema.entity.AccountEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface AccountRepository extends JpaRepository<AccountEntity, Long> {
    boolean existsByEmail(String email);

    @Query(value = "select a from AccountEntity a where a.email like ?1 and a.active = 1 ")
    boolean checkActive(String email);
    AccountEntity findByEmail(String email);

}