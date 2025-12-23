/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package payments;

/**
 *
 * @author ASUS
 */
public class BankTransferPayment implements Payable {

    private String destinationBank;

    public BankTransferPayment(String destinationBank) {
        this.destinationBank = destinationBank;
    }

    @Override
    public boolean pay(int orderId, int amount) {
        // simulasi sukses
        System.out.println("Transfer ke rekening " + destinationBank);
        return true;
    }

    @Override
    public String getMethod() {
        return "Transfer Bank (" + destinationBank + ")";
    }
}
