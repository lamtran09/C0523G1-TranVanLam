package com.example.ung_dung_blog.model;

import javax.persistence.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Entity
@Table(name = "books")
public class Blog {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;
    @Column(name = "title", unique = true)
    private String title;
    @Column(columnDefinition = "text")
    private String content;
    private String author;
    @Column(columnDefinition = "date")
    private String bloggingDay;
    @ManyToOne
    @JoinColumn(name = "category_id",referencedColumnName = "id")
    private Category category;

    public Blog() {
    }

    public Blog(int id, String title, String content, String author, String bloggingDay) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.author = author;
        this.bloggingDay = bloggingDay;
    }

    public Blog(int id, String title, String content, String author, String bloggingDay, Category category) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.author = author;
        this.bloggingDay = bloggingDay;
        this.category = category;
    }

    public int getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public String getContent() {
        return content;
    }

    public String getAuthor() {
        return author;
    }

    public String getBloggingDay() {
        DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        return LocalDate.parse(bloggingDay, dateTimeFormatter).format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }

    public Category getCategory() {
        return category;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public void setBloggingDay(String time) {
        this.bloggingDay = time;
    }

    public void setCategory(Category category) {
        this.category = category;
    }
}
