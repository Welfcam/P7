@isTest
private class OrderItemControllerTest {
    //Test des données retournées par OrderItemControlleur pour 3 OrderItem - Compte Business
    @isTest
    static void test3OrderItemOnBizAccount() {
        Account acctBiz = TestDataFactory.createBusinessAccountTest();
        Pricebook2 testPricebookBiz = TestDataFactory.createTestPricebookBiz();
        Pricebook2 testPricebookPerson = TestDataFactory.createTestPricebookPerson();
        List<Product2> prodList = TestDataFactory.createTestProductList();
        List<PricebookEntry> pbeList = TestDataFactory.createPricebookEntryList(prodList, testPricebookBiz, testPricebookPerson);
        Opportunity opp = TestDataFactory.createOpportunityTest(testPricebookBiz, acctBiz.Id);
        //List<OpportunityLineItem> oppProdList = TestDataFactory.createOppLineItemTest(prodList, opp, pbeList, 3);
        TestDataFactory.createOppLineItemTest(prodList, opp, pbeList, 3);
        List<OpportunityLineItem> oppProdList = OpportunityLineItemController.getOpportunityLineItem(opp.Id);
        Order order = TestDataFactory.createOrderTest(opp, acctBiz);
        List<OrderItem> orderItemList = TestDataFactory.createOrderItemTest(order, oppProdList);
        Test.startTest();
        List<OrderItem> results = OrderItemController.getOrderItem(order.Id);
        Test.stopTest();
        Assert.areEqual(3, results.size(), 'Should return 3 order products');
        Assert.areEqual(3, results[1].Quantity, 'Should return 3');
    }

    //Test des données retournées par OrderItemControlleur pour 2 OrderItem - Compte Person
    @isTest
    static void test2OrderItemOnPersonAccount() {
        Account acctPers = TestDataFactory.createPersonAccountTest();
        Pricebook2 testPricebookBiz = TestDataFactory.createTestPricebookBiz();
        Pricebook2 testPricebookPerson = TestDataFactory.createTestPricebookPerson();
        List<Product2> prodList = TestDataFactory.createTestProductList();
        List<PricebookEntry> pbeList = TestDataFactory.createPricebookEntryList(prodList, testPricebookBiz, testPricebookPerson);
        Opportunity opp = TestDataFactory.createOpportunityTest(testPricebookPerson, acctPers.Id);
        //List<OpportunityLineItem> oppProdList = TestDataFactory.createOppLineItemTest(prodList, opp, pbeList, 3);
        TestDataFactory.createOppLineItemTest(prodList, opp, pbeList, 2);
        List<OpportunityLineItem> oppProdList = OpportunityLineItemController.getOpportunityLineItem(opp.Id);
        Order order = TestDataFactory.createOrderTest(opp, acctPers);
        List<OrderItem> orderItemList = TestDataFactory.createOrderItemTest(order, oppProdList);
        Test.startTest();
        List<OrderItem> results = OrderItemController.getOrderItem(order.Id);
        Test.stopTest();
        Assert.areEqual(2, results.size(), 'Should return 2 order products');
        Assert.areEqual(3, results[1].Quantity, 'Should return 3');
    }
}