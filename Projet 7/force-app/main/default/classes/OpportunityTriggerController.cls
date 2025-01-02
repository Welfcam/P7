
//Controlleur de Opportunity Trigger : création d'Order et Order Item lorsque l'opportunité passe à Closed Won
public with sharing class OpportunityTriggerController {
    public static void createOrderAndOrderItem(Opportunity opp) {

        List<OpportunityLineItem> oppProd = [SELECT Id, Product2Id, Quantity, Description, UnitPrice, TotalPrice, PricebookEntryId, OpportunityId FROM OpportunityLineItem WHERE OpportunityId = :opp.Id];
        Account acct = [SELECT BillingStreet, BillingPostalCode, BillingCity, BillingCountry, ShippingStreet, ShippingPostalCode, ShippingCity, ShippingCountry FROM Account WHERE Id = :opp.AccountId];
        
        Order newOrder = new Order(
            OpportunityId = opp.Id,
            AccountId = opp.AccountId,
            EffectiveDate = Date.today(),
            ContractId = opp.ContractId,
            Status = 'Draft',
            Pricebook2Id = opp.Pricebook2Id,
            BillingStreet = acct.BillingStreet,
            BillingPostalCode = acct.BillingPostalCode,
            BillingCity = acct.BillingCity,
            BillingCountry = acct.BillingCountry,
            ShippingStreet = acct.ShippingStreet,
            ShippingPostalCode = acct.ShippingPostalCode,
            ShippingCity = acct.ShippingCity,
            ShippingCountry = acct.ShippingCountry
        );
        insert newOrder;

        List<OrderItem> orderItemList = new List<OrderItem>();
        for(OpportunityLineItem oppLineItem : oppProd) {
            OrderItem orderItem = new OrderItem();
            orderItem.OrderId = newOrder.Id;
            orderItem.Product2Id = oppLineItem.Product2Id;
            orderItem.Quantity = oppLineItem.Quantity;
            orderItem.Description = oppLineItem.Description;
            orderItem.UnitPrice = oppLineItem.UnitPrice;
            orderItem.PricebookEntryId = oppLineItem.PricebookEntryId;
            orderItemList.add(orderItem);
        }
        insert orderItemList;
    }
}