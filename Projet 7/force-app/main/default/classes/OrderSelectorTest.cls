@isTest
private class OrderSelectorTest {
    //Test de OrderSelector sur Compte Business
    @isTest
    static void testOrderOnBizAccount() {
        Account acctBiz = TestDataFactory.createBusinessAccountTest();
        Pricebook2 testPricebookBiz = TestDataFactory.createTestPricebookBiz();
        Pricebook2 testPricebookPerson = TestDataFactory.createTestPricebookPerson();
        List<Product2> prodList = TestDataFactory.createTestProductList();
        List<PricebookEntry> pbeList = TestDataFactory.createPricebookEntryList(prodList, testPricebookBiz, testPricebookPerson);
        Opportunity opp = TestDataFactory.createOpportunityTest(testPricebookBiz, acctBiz.Id);
        TestDataFactory.createOppLineItemTest(prodList, opp, pbeList, 3);
        List<OpportunityLineItem> oppProdList = OpportunityLineItemController.getOpportunityLineItem(opp.Id);
        Order order = TestDataFactory.createOrderTest(opp, acctBiz);
        List<OrderItem> orderItemList = TestDataFactory.createOrderItemTest(order, oppProdList);
        Order result = OrderSelector.getOrderByOrderId(order.Id);
        Assert.areEqual(10200, result.TotalAmount, 'Should return 3100');
        Assert.areEqual('Draft', result.Status, 'Should return Draft');
        Assert.areEqual('France', result.ShippingCountry, 'Should return France');
    }

    //Test de OrderSelector sur Compte Person
    @isTest
    static void testOrderOnPersAccount() {
        Account acctPers = TestDataFactory.createPersonAccountTest();
        Pricebook2 testPricebookBiz = TestDataFactory.createTestPricebookBiz();
        Pricebook2 testPricebookPerson = TestDataFactory.createTestPricebookPerson();
        List<Product2> prodList = TestDataFactory.createTestProductList();
        List<PricebookEntry> pbeList = TestDataFactory.createPricebookEntryList(prodList, testPricebookBiz, testPricebookPerson);
        Opportunity opp = TestDataFactory.createOpportunityTest(testPricebookPerson, acctPers.Id);
        TestDataFactory.createOppLineItemTest(prodList, opp, pbeList, 3);
        List<OpportunityLineItem> oppProdList = OpportunityLineItemController.getOpportunityLineItem(opp.Id);
        Order order = TestDataFactory.createOrderTest(opp, acctPers);
        List<OrderItem> orderItemList = TestDataFactory.createOrderItemTest(order, oppProdList);
        Order result = OrderSelector.getOrderByOrderId(order.Id);
        Assert.areEqual(38000, result.TotalAmount, 'Should return 10200');
        Assert.areEqual('Draft', result.Status, 'Should return Draft');
        Assert.areEqual('Belgique', result.ShippingCountry, 'Should return Belgique');
    }
}