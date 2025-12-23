/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package payments;

/**
 *
 * @author ASUS
 */

public class VirtualAccountPayment implements Payable {

    private String bankName;

    public VirtualAccountPayment(String bankName) {
        this.bankName = bankName;
    }

    @Override
    public boolean pay(int orderId, int amount) {
        System.out.println("VA " + bankName + " | Order: " + orderId);
        return true;
    }

    @Override
    public String getMethod() {
        return bankName + " Virtual Account";
    }
}

