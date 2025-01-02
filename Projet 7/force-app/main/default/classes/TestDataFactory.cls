@isTest
public class TestDataFactory {

    //Création d'un compte Business de Test
    public static Account createBusinessAccountTest() {
        Account testAccountBiz = new Account(
            Name = 'Test Business Account',
            Type = 'Business',
            Industry = 'Energy',
            BillingCity = 'Paris',
            BillingCountry = 'France',
            ShippingCity = 'Paris',
            ShippingCountry = 'France',
            Phone = '123456',
            Website = 'test@test123456.com'
            );
        insert testAccountBiz;
        return testAccountBiz;    
    }

    //Création d'un compte Person de Test
    public static Account createPersonAccountTest() {
        Account testAccountPers = new Account(
            Name = 'Test Person Account',
            Type = 'Person',
            Industry = 'Other',
            BillingCity = 'Bruxelles',
            BillingCountry = 'Belgique',
            ShippingCity = 'Bruxelles',
            ShippingCountry = 'Belgique',
            Phone = '654321',
            Website = 'test@test654321.com'
            );
        insert testAccountPers;
        return testAccountPers;    
    }
    
    //Création Pricebook Business
    public static Pricebook2 createTestPricebookBiz() {
        Pricebook2 testPricebookBiz = new Pricebook2(Name = 'Pricebook Business', IsActive = true);
        insert testPricebookBiz;
        return testPricebookBiz; 
    }

    //Création Pricebook Person
    public static Pricebook2 createTestPricebookPerson() {
        Pricebook2 testPricebookPerson = new Pricebook2(Name = 'Pricebook Person', IsActive = true);
        insert testPricebookPerson;
        return testPricebookPerson;
    }

    //Création produits de test
    public static List<Product2> createTestProductList() {
        List<Product2> testProductsList = new List<Product2>();
        testProductsList.add(new Product2(Name = 'Produit 1'));
        testProductsList.add(new Product2(Name = 'Produit 2'));
        testProductsList.add(new Product2(Name = 'Produit 3'));
        testProductsList.add(new Product2(Name = 'Produit 4'));
        testProductsList.add(new Product2(Name = 'Produit 5'));

        insert testProductsList;
        return testProductsList;
    }

    //Création de PricebookEntries (Standard, Business et Person)
    public static List<PricebookEntry> createPricebookEntryList(List<Product2> testProductsList, Pricebook2 testPricebookBiz, Pricebook2 testPricebookPerson) {

        Id pricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> pbeList = new List<PricebookEntry>();
        pbeList.add(new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = testProductsList[0].Id, UnitPrice = 100, IsActive = true));
        pbeList.add(new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = testProductsList[1].Id, UnitPrice = 200, IsActive = true));
        pbeList.add(new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = testProductsList[2].Id, UnitPrice = 300, IsActive = true));
        pbeList.add(new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = testProductsList[3].Id, UnitPrice = 400, IsActive = true));
        pbeList.add(new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = testProductsList[4].Id, UnitPrice = 500, IsActive = true));

        pbeList.add(new PricebookEntry(Pricebook2Id = testPricebookBiz.Id, Product2Id = testProductsList[0].Id, UnitPrice = 600, IsActive = true));
        pbeList.add(new PricebookEntry(Pricebook2Id = testPricebookBiz.Id, Product2Id = testProductsList[1].Id, UnitPrice = 1000, IsActive = true));
        pbeList.add(new PricebookEntry(Pricebook2Id = testPricebookBiz.Id, Product2Id = testProductsList[2].Id, UnitPrice = 1500, IsActive = true));
        pbeList.add(new PricebookEntry(Pricebook2Id = testPricebookBiz.Id, Product2Id = testProductsList[3].Id, UnitPrice = 2000, IsActive = true));
        pbeList.add(new PricebookEntry(Pricebook2Id = testPricebookBiz.Id, Product2Id = testProductsList[4].Id, UnitPrice = 2500, IsActive = true));

        pbeList.add(new PricebookEntry(Pricebook2Id=testPricebookPerson.Id, Product2Id=testProductsList[0].Id, UnitPrice=3000, IsActive = true));
        pbeList.add(new PricebookEntry(Pricebook2Id=testPricebookPerson.Id, Product2Id=testProductsList[1].Id, UnitPrice=4000, IsActive = true));
        pbeList.add(new PricebookEntry(Pricebook2Id=testPricebookPerson.Id, Product2Id=testProductsList[2].Id, UnitPrice=5000, IsActive = true));
        pbeList.add(new PricebookEntry(Pricebook2Id=testPricebookPerson.Id, Product2Id=testProductsList[3].Id, UnitPrice=6000, IsActive = true));
        pbeList.add(new PricebookEntry(Pricebook2Id=testPricebookPerson.Id, Product2Id=testProductsList[4].Id, UnitPrice=7000, IsActive = true));

        insert pbeList;
        return pbeList;
    }
    
    //Création d'une opportunité test
    public static Opportunity createOpportunityTest(Pricebook2 testPricebook, Id accountId) {
        Opportunity testOpp = new Opportunity (
            Name = 'Test Opp',
            StageName = 'Prospecting',
            CloseDate = System.today().addMonths(1),
            Pricebook2Id = testPricebook.Id,
            AccountId = accountId
        );
        insert testOpp;
        return testOpp;
    }

    //Création d'opportunités produit test (max 5)
    public static List<OpportunityLineItem> createOppLineItemTest(List<Product2> prodList, Opportunity testOpp, List<PricebookEntry> pbeList, Integer nbOfProdMax5) {
        List<OpportunityLineItem> oppProdList = new List<OpportunityLineItem>();      
        for(Integer i = 0; i<nbOfProdMax5; i++) {
            oppProdList.add(new OpportunityLineItem(
                Product2Id = prodList[i].Id,
                OpportunityId = testOpp.Id,
                Quantity = i + 2,
                UnitPrice = pbeList[i].UnitPrice
            ));
        }
        insert oppProdList;
        return oppProdList;
    }

    //Création d'une commande test
    public static Order createOrderTest(Opportunity opp, Account acct) {
        Order testOrder = new Order (
            OpportunityId = opp.Id,
            AccountId = opp.AccountId,
            EffectiveDate = Date.today(),
            Status = 'Draft',
            Pricebook2Id = opp.Pricebook2Id,
            ShippingCountry = acct.ShippingCountry
        );
        insert testOrder;
        return testOrder;
    }

    //Création de produits de commande
    public static List<OrderItem> createOrderItemTest(Order testOrder, List<OpportunityLineItem> oppProdList) {
        List<OrderItem> orderItemList = new List<OrderItem>();
        for(OpportunityLineItem oppLineItem : oppProdList) {
            OrderItem orderItem = new OrderItem(
                OrderId = testOrder.Id,
                Product2Id = oppLineItem.Product2Id,
                Quantity = oppLineItem.Quantity,
                UnitPrice = oppLineItem.PricebookEntry.UnitPrice,
                PricebookEntryId = oppLineItem.PricebookEntry.Id
            );
            orderItemList.add(orderItem);
        }
        insert orderItemList;
        return orderItemList;
    }

    //Création de transporteurs
    public static List<Transporter__c> createTransportersTest() {
        List<Transporter__c> transporterList = new List<Transporter__c>();
        transporterList.add(new Transporter__c(Name='Amazon', Delivery_Type__c='Business_and_Person'));
        transporterList.add(new Transporter__c(Name='DHL', Delivery_Type__c='Business_only'));
        transporterList.add(new Transporter__c(Name='Chronopost', Delivery_Type__c='Person_only'));

        insert transporterList;
        return transporterList;
    }

    //Création de Transporter Conditions
    public static List<Transporter_Conditions__c> createTransporterConditionsTest(List<Transporter__c> transporterList) {
        List<Transporter_Conditions__c> transporterConditionsList = new List<Transporter_Conditions__c>();
        transporterConditionsList.add(new Transporter_Conditions__c(Transporter__c=transporterList[0].Id, Name=transporterList[0].Name + ' Belgique', Delivery_Zone__c='Belgique', Delivery_Cost__c=12, Delivery_Time__c=6));
        transporterConditionsList.add(new Transporter_Conditions__c(Transporter__c=transporterList[0].Id, Name=transporterList[0].Name + ' France', Delivery_Zone__c='France', Delivery_Cost__c=15, Delivery_Time__c=5));
        transporterConditionsList.add(new Transporter_Conditions__c(Transporter__c=transporterList[1].Id, Name=transporterList[1].Name + ' Belgique', Delivery_Zone__c='Belgique', Delivery_Cost__c=25, Delivery_Time__c=2));
        transporterConditionsList.add(new Transporter_Conditions__c(Transporter__c=transporterList[1].Id, Name=transporterList[1].Name + ' France', Delivery_Zone__c='France', Delivery_Cost__c=28, Delivery_Time__c=1));
        transporterConditionsList.add(new Transporter_Conditions__c(Transporter__c=transporterList[2].Id, Name=transporterList[2].Name + ' Belgique', Delivery_Zone__c='Belgique', Delivery_Cost__c=18, Delivery_Time__c=3));
        transporterConditionsList.add(new Transporter_Conditions__c(Transporter__c=transporterList[2].Id, Name=transporterList[2].Name + ' France', Delivery_Zone__c='France', Delivery_Cost__c=20, Delivery_Time__c=1));

        insert transporterConditionsList;
        return transporterConditionsList;
    }
}