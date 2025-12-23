/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package payments;

/**
 *
 * @author ASUS
 */
public class ShopeePayPayment implements Payable {

    @Override
    public boolean pay(int orderId, int amount) {
        System.out.println("Bayar Shopeepay | Order: " + orderId + " | Rp " + amount);
        return true;
    }

    @Override
    public String getMethod() {
        return "ShopeePay";
    }
}
