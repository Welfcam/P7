@isTest
private class OpportunityTriggerTest {

    //Test création d'une Order lorsqu'un l'opportunité d'un compte Business passe à Closed Won
    @isTest
    static void testCreateOrderOnBizOppClosedWon() {
        Account acctBiz = TestDataFactory.createBusinessAccountTest();
        Pricebook2 testPricebookBiz = TestDataFactory.createTestPricebookBiz();
        Pricebook2 testPricebookPerson = TestDataFactory.createTestPricebookPerson();
        List<Product2> prodList = TestDataFactory.createTestProductList();
        List<PricebookEntry> pbeList = TestDataFactory.createPricebookEntryList(prodList, testPricebookBiz, testPricebookPerson);
        Opportunity opp = TestDataFactory.createOpportunityTest(testPricebookBiz, acctBiz.Id);
        TestDataFactory.createOppLineItemTest(prodList, opp, pbeList, 3);
        List<OpportunityLineItem> oppProdList = OpportunityLineItemController.getOpportunityLineItem(opp.Id);

        opp.StageName = 'Closed Won';
        update opp;

        List<Order> testOrder = [SELECT Id, AccountId, Account.Type, OpportunityId, Status FROM Order WHERE OpportunityId = :opp.Id];
        List<OrderItem> testOrderItem = [SELECT Id, Product2.Name, Quantity, UnitPrice FROM OrderItem WHERE OrderId = :testOrder[0].Id];
        Assert.areEqual(1, testOrder.size(), 'Should return 1');
        Assert.areEqual('Draft', testOrder[0].Status, 'Should return Draft');
        Assert.areEqual('Business', testOrder[0].Account.Type, 'Should return Business');
        Assert.areEqual(3, testOrderItem.size(), 'Should return 3');
        Assert.areEqual('Produit 2', testOrderItem[1].Product2.Name, 'Should return Produit 2');

    }

    //Test création d'une Order lorsqu'un l'opportunité d'un compte Person passe à Closed Won
    @isTest
    static void testCreateOrderOnPersonOppClosedWon() {
        Account acctPers = TestDataFactory.createPersonAccountTest();
        Pricebook2 testPricebookBiz = TestDataFactory.createTestPricebookBiz();
        Pricebook2 testPricebookPerson = TestDataFactory.createTestPricebookPerson();
        List<Product2> prodList = TestDataFactory.createTestProductList();
        List<PricebookEntry> pbeList = TestDataFactory.createPricebookEntryList(prodList, testPricebookBiz, testPricebookPerson);
        Opportunity opp = TestDataFactory.createOpportunityTest(testPricebookPerson, acctPers.Id);
        TestDataFactory.createOppLineItemTest(prodList, opp, pbeList, 3);
        List<OpportunityLineItem> oppProdList = OpportunityLineItemController.getOpportunityLineItem(opp.Id);

        opp.StageName = 'Closed Won';
        update opp;

        List<Order> testOrder = [SELECT Id, AccountId, Account.Type, OpportunityId, Status FROM Order WHERE OpportunityId = :opp.Id];
        List<OrderItem> testOrderItem = [SELECT Id, Product2.Name, Quantity, UnitPrice FROM OrderItem WHERE OrderId = :testOrder[0].Id];
        Assert.areEqual(1, testOrder.size(), 'Should return 1');
        Assert.areEqual('Draft', testOrder[0].Status, 'Should return Draft');
        Assert.areEqual('Person', testOrder[0].Account.Type, 'Should return Person');
        Assert.areEqual(3, testOrderItem.size(), 'Should return 3');
        Assert.areEqual('Produit 2', testOrderItem[1].Product2.Name, 'Should return Produit 2');
    }

}