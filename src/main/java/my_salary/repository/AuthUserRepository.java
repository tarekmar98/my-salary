package my_salary.repository;

import my_salary.entity.AuthUser;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * Repository interface for performing custom database operations related to the Movie entity.
 * This interface extends JpaRepository, providing built-in methods for interacting with the Movie database table.
 */
public interface AuthUserRepository extends JpaRepository<AuthUser, String> {

}