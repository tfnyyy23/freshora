/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package payments;

/**
 *
 * @author ASUS
 */
public interface Payable {
    boolean pay(int orderId, int amount);
    String getMethod();
}
