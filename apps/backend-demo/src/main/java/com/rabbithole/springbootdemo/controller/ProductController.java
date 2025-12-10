package com.rabbithole.springbootdemo.controller;


import com.rabbithole.springbootdemo.model.Product;
import org.springframework.web.bind.annotation.*;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicLong;

@RestController
@RequestMapping("/api/products")
@CrossOrigin(origins = "*")
public class ProductController {

  // The entire database. It resets every time the server restarts.
  private final List<Product> products = new ArrayList<>();
  private final AtomicLong nextId = new AtomicLong(1);

  public ProductController() {
    // Seed some initial, temporary data
    products.add(new Product(nextId.getAndIncrement(), "Memory Foam Pillow", 49.99));
    products.add(new Product(nextId.getAndIncrement(), "Phantom Keyboard", 129.50));
    products.add(new Product(nextId.getAndIncrement(), "4K Monitor", 350.00));
  }

  @GetMapping
  public List<Product> getAllProducts() {
    System.out.println("Fetching all " + products.size() + " products.");
    return products;
  }

  @PostMapping
  public Product addProduct(@RequestBody Product newProduct) {
    // Create a new product with the next available ID
    Product productToSave = new Product(
      nextId.getAndIncrement(),
      newProduct.name(),
      newProduct.price()
    );
    products.add(productToSave);
    System.out.println("Added new product: " + productToSave.name());
    return productToSave;
  }
}
