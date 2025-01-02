public with sharing class OrderTriggerController {
    //Méthode pour empêcher la mise à jour du statut de l'Order en cas de quantité insuffisante (Business Min 5, Person Min 3)
    public static void preventValidateOrderIfQtyError(Order orderToActivate) {
        Integer orderQtyMinPersonAccount = 3;
        Integer orderQtyMinBizAccount = 5;
        String acctType = [SELECT Type FROM Account WHERE Id = :orderToActivate.AccountId].Type;
        if(acctType == 'Business' && orderToActivate.Order_Quantity__c < orderQtyMinBizAccount) {
            orderToActivate.addError('The minimum quantity for ' + acctType + ' account is ' + orderQtyMinBizAccount + '. Please update the Order');
        } else if(acctType == 'Person' && orderToActivate.Order_Quantity__c < orderQtyMinPersonAccount) {
            orderToActivate.addError('The minimum quantity for ' + acctType + ' account is ' + orderQtyMinPersonAccount + '. Please update the Order');
        }
    }

    //Méthode pour créer une livraison à partir de l'Order
    public static void createDelivery(Order orderActivated) {
        Delivery__c newDelivery = new Delivery__c(
            Order__c = orderActivated.Id,
            Name = 'Delivery of Order ' + orderActivated.OrderNumber,
            Status__c = 'Draft'
        );
        insert newDelivery;
    }
}