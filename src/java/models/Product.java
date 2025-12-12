/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

/**
 *
 * @author ASUS
 */
public class Product {
    private int productId;
    private String name, description, image;
    private double price, rating;
    private int stock, categoryId;

    public Product() {}
    public Product(int productId, String name, String description, double price,
                   int stock, String image, double rating, int categoryId) {

        this.productId = productId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.stock = stock;
        this.image = image;
        this.rating = rating;
        this.categoryId = categoryId;
    }

    public int getProductId() { return productId; }
    public String getName() { return name; }
    public double getPrice() { return price; }
    public String getImage() { return image; }
}
