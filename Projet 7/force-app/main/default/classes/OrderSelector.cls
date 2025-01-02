public with sharing class OrderSelector {
    public static Order getOrderByOrderId(Id orderId) {
        return [
                SELECT Id, Status, ShippingStreet, ShippingPostalCode, ShippingCity, ShippingCountry, TotalAmount, AccountId, Account.Name, Selected_Transporter__c 
                FROM Order
                WHERE Id = :orderId
        ];
    }
}