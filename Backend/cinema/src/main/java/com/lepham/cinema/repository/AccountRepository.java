package com.lepham.cinema.repository;

import com.lepham.cinema.entity.AccountEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface AccountRepository extends JpaRepository<AccountEntity, Long> {
    boolean existsByEmailAndActive(String email,int active);

    @Query(value = "select a from AccountEntity a where a.email like ?1 and a.active = 1 ")
    boolean checkActive(String email);
    Optional<AccountEntity> findByEmail(String email);
    List<AccountEntity> findAllByActiveAndRole(int active, String role);
    AccountEntity findByIdAndActive(long id, int active);
}
