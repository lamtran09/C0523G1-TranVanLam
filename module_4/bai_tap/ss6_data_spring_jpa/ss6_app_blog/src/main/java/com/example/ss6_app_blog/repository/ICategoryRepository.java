package com.example.ss6_app_blog.repository;

import com.example.ss6_app_blog.model.Category;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ICategoryRepository extends JpaRepository<Category,Integer> {

}
