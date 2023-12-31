package com.example.ung_dung_blog.model;

import com.fasterxml.jackson.annotation.JsonBackReference;

import javax.persistence.*;
import java.util.Set;

@Entity
@Table(name = "categories")
public class CategoryEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;

    private String name;

    @OneToMany(mappedBy = "categoryEntity")
    @JsonBackReference
    private Set<BlogEntity> blogEntitySet;

    public CategoryEntity() {
    }

    public CategoryEntity(int id, String name) {
        this.id = id;
        this.name = name;
    }



    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Set<BlogEntity> getBlogEntitySet() {
        return blogEntitySet;
    }
    public void setBlogEntitySet(Set<BlogEntity> blogEntitySet) {
        this.blogEntitySet = blogEntitySet;
    }
}
