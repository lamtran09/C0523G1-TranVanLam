package com.example.ss11_manager_product.repository;

import com.example.ss11_manager_product.model.Product;

import java.util.List;


public interface IProductRepository {
    List<Product> getAll();
    void add(Product product);
    void remove(Product product);
    Product getById(int id);
    List<Product> findByName(String name);
    void update(int id, Product product);
}
