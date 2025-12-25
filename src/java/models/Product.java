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
    private String name;
    private String description;
    private int price;
    private int stock;
    private String image;
    private double rating;
    private int categoryId;

    // Constructor Lengkap
    public Product(int productId, String name, String description, int price, int stock, String image, double rating, int categoryId) {
        this.productId = productId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.stock = stock;
        this.image = image;
        this.rating = rating;
        this.categoryId = categoryId;
    }

    // GETTER (Wajib ada untuk JSP)
    public int getProductId() { return productId; }
    public String getName() { return name; }
    public String getDescription() { return description; } // Ini yang tadi error
    public int getPrice() { return price; }
    public int getStock() { return stock; }
    public String getImage() { return image; }
    public double getRating() { return rating; }
    public int getCategoryId() { return categoryId; }

    // SETTER (Opsional tapi baik untuk dimiliki)
    public void setDescription(String description) { this.description = description; }
    public void setName(String name) { this.name = name; }
    public void setPrice(int price) { this.price = price; }
    public void setStock(int stock) { this.stock = stock; }

}
