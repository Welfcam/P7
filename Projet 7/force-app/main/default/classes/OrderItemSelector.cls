public with sharing class OrderItemSelector {
    public static List<OrderItem> getOrderItemByOrderId(Id orderId) {
        return [SELECT Product2.Name, Product2.Id, Quantity, PricebookEntry.UnitPrice, TotalPrice FROM OrderItem WHERE OrderId = :orderId];
    }
}