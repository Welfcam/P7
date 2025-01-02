public with sharing class TransporterSelector {
    //Récupère les données relatives à tous les transporteurs possibles en fonction du Shipping Country et du type de compte
    public static List<Transporter_Conditions__c> getAllTransporterConditionsByOrder(Id orderId) {
        Order order = [SELECT Account.Type, ShippingCountry FROM Order WHERE Id = :orderId];
        String orderAccountType = '%' + order.Account.Type + '%';
        String orderShippingCountry = order.ShippingCountry;
        return [SELECT Name, Delivery_Zone__c, Delivery_Cost__c, Delivery_Time__c
                FROM Transporter_Conditions__c 
                WHERE Transporter__r.Delivery_Type__c LIKE :orderAccountType AND Delivery_Zone__c = :orderShippingCountry
                ORDER BY Delivery_Time__c ASC, Delivery_Cost__c ASC];
    }
    
    //Récupère les données relatives à la meilleure option (la moins chère des plus rapides) en fonction du Shipping Country et du type de compte
    public static List<Transporter_Conditions__c> getBestTransporterConditionsByOrder(Id orderId) {
        Order order = [SELECT Account.Type, ShippingCountry FROM Order WHERE Id = :orderId];
        String orderAccountType = '%' + order.Account.Type + '%';
        String orderShippingCountry = order.ShippingCountry;
        return [SELECT Name, Delivery_Zone__c, Delivery_Cost__c, Delivery_Time__c 
                FROM Transporter_Conditions__c 
                WHERE Transporter__r.Delivery_Type__c LIKE :orderAccountType AND Delivery_Zone__c = :orderShippingCountry 
                ORDER BY Delivery_Time__c ASC, Delivery_Cost__c ASC LIMIT 1];
    }
}
    