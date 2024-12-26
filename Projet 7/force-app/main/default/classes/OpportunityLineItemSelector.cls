public with sharing class OpportunityLineItemSelector {
    public static List<OpportunityLineItem> getOpportunityLineItemByOppId(Id opportunityId) {
        return [SELECT Product2.Name, Product2.Id, Quantity, PricebookEntry.UnitPrice, TotalPrice FROM OpportunityLineItem WHERE OpportunityId = :opportunityId];
    }
}