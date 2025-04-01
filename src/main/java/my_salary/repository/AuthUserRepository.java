package my_salary.repository;

import my_salary.entity.AuthUser;
import org.springframework.data.jpa.repository.JpaRepository;


public interface AuthUserRepository extends JpaRepository<AuthUser, String> {

}