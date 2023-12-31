package com.example.ss6_app_blog.service;

import com.example.ss6_app_blog.model.Blog;
import com.example.ss6_app_blog.repository.IBlogRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class BlogService implements IBlogService {
    @Autowired
    private IBlogRepository blogRepository;

    @Override
    public List<Blog> getAll() {
        return blogRepository.findAll();
    }

    @Override
    public Page<Blog> getAll(Pageable pageable) {
        return blogRepository.findAll(pageable);
    }

    @Override
    public Page<Blog> findAllByName(Pageable pageable, String searchName) {
        return blogRepository.findAllByNameContaining(pageable,searchName );
    }

    @Override
    public boolean createBlog(Blog blog) {
        LocalDate currentDate = LocalDate.now();
        blog.setBloggingDay(String.valueOf(currentDate));
        Blog blogEntity = blogRepository.save(blog);
        return blogEntity != null;
    }

    @Override
    public void updateBlog(Blog blog) {
        LocalDate currentDate = LocalDate.now();
        blog.setBloggingDay(String.valueOf(currentDate));
        blogRepository.updateBlog(blog.getName(), blog.getAuthor(), blog.getTitle(), blog.getContent(), blog.getBloggingDay(), blog.getId());
    }

    @Override
    public void deleteBlog(Blog blog) {
        Blog blogEntity = blogRepository.findById(blog.getId()).get();
        blogRepository.delete(blogEntity);
    }

    @Override
    public Blog findById(int id) {
        return blogRepository.findById(id).get();
    }

    @Override
    public Page<Blog> findAllByBlog(Pageable pageable,int idCategory,String searchName) {
        return blogRepository.findAllByBlog(pageable,idCategory,"%"+searchName+"%");
    }
}
