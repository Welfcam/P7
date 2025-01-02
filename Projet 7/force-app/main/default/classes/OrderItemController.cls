public with sharing class OrderItemController {
    @AuraEnabled(Cacheable=true)
    public static List <OrderItem> getOrderItem(Id orderId) {
        return OrderItemSelector.getOrderItemByOrderId(orderId);
    }
}