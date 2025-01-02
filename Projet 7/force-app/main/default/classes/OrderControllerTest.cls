
@isTest
private class OrderControllerTest {

    //Test de la méthode getOrder de Order Controller sur un compte Business
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
        Test.startTest();
        Order result = OrderController.getOrder(order.Id);
        Test.stopTest();
        Assert.areEqual(10200, result.TotalAmount, 'Should return 3100');
        Assert.areEqual('Draft', result.Status, 'Should return Draft');
        Assert.areEqual('France', result.ShippingCountry, 'Should return France');
    }

    //Test de la méthode activateOrder avec un compte Business et la meilleur option de Transporteur
    @isTest
    static void testActivateOrderWithBizAccount() {
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
        List<Transporter__c> transporterList = TestDataFactory.createTransportersTest();
        List<Transporter_Conditions__c> transporterConditionsList = TestDataFactory.createTransporterConditionsTest(transporterList);
        List<Transporter_Conditions__c> bestResult = TransporterController.getTransporters(order.Id, 'option1');
        OrderController.activateOrder(order.Id, bestResult[0].Id);
        Order updatedOrder = OrderController.getOrder(order.Id);
        Assert.areEqual('Activated', updatedOrder.Status, 'Should return Activated');
        Assert.areEqual(bestResult[0].Id, updatedOrder.Selected_Transporter__c);
    }

    //Test de la méthode getOrder de Order Controller sur un compte Person
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
        Order result = OrderController.getOrder(order.Id);
        Assert.areEqual(38000, result.TotalAmount, 'Should return 10200');
        Assert.areEqual('Draft', result.Status, 'Should return Draft');
        Assert.areEqual('Belgique', result.ShippingCountry, 'Should return Belgique');
    }

    //Test de la méthode activateOrder avec un compte Person et la 2eme option de transporteur
    @isTest
    static void testActivateOrderWithPersonAccount() {
        Account acctPers = TestDataFactory.createPersonAccountTest();
        Pricebook2 testPricebookBiz = TestDataFactory.createTestPricebookBiz();
        Pricebook2 testPricebookPerson = TestDataFactory.createTestPricebookPerson();
        List<Product2> prodList = TestDataFactory.createTestProductList();
        List<PricebookEntry> pbeList = TestDataFactory.createPricebookEntryList(prodList, testPricebookBiz, testPricebookPerson);
        Opportunity opp = TestDataFactory.createOpportunityTest(testPricebookBiz, acctPers.Id);
        TestDataFactory.createOppLineItemTest(prodList, opp, pbeList, 3);
        List<OpportunityLineItem> oppProdList = OpportunityLineItemController.getOpportunityLineItem(opp.Id);
        Order order = TestDataFactory.createOrderTest(opp, acctPers);
        List<OrderItem> orderItemList = TestDataFactory.createOrderItemTest(order, oppProdList);
        List<Transporter__c> transporterList = TestDataFactory.createTransportersTest();
        List<Transporter_Conditions__c> transporterConditionsList = TestDataFactory.createTransporterConditionsTest(transporterList);
        List<Transporter_Conditions__c> bestResult = TransporterController.getTransporters(order.Id, 'option2');
        OrderController.activateOrder(order.Id, bestResult[1].Id);
        Order updatedOrder = OrderController.getOrder(order.Id);
        Assert.areEqual('Activated', updatedOrder.Status, 'Should return Activated');
        Assert.areEqual(bestResult[1].Id, updatedOrder.Selected_Transporter__c);
    }
}