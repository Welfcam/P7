public with sharing class OrderController {
    
    //Récupère les données retournées par OrderSelector
    @AuraEnabled(Cacheable=true)
    public static Order getOrder(Id orderId) {
        return OrderSelector.getOrderByOrderId(orderId);
    }

    //Méthode appelée lors du click sur le bouton Activate Order du LWC. Mise à jour du statut de l'Order et enregistrement du Transporter Selected
    @AuraEnabled
    public static void activateOrder(Id orderId, Id selectedTransporter) {
        Order orderToUpdate = OrderSelector.getOrderByOrderId(orderId);
        orderToUpdate.Status = 'Activated';
        orderToUpdate.Selected_Transporter__c = selectedTransporter;
        update orderToUpdate;
    }
}