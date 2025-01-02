@isTest
private class OrderTriggerTest {

    //Test de la mise à jour au statut Validated d'une commande Business avec une quantité < 5 (mise à jour non autorisée)
    @isTest
    static void testTriggerOnBizAccountWithQuantityError() {
        Account acctBiz = TestDataFactory.createBusinessAccountTest();
        Pricebook2 testPricebookBiz = TestDataFactory.createTestPricebookBiz();
        Pricebook2 testPricebookPerson = TestDataFactory.createTestPricebookPerson();
        List<Product2> prodList = TestDataFactory.createTestProductList();
        List<PricebookEntry> pbeList = TestDataFactory.createPricebookEntryList(prodList, testPricebookBiz, testPricebookPerson);
        Opportunity opp = TestDataFactory.createOpportunityTest(testPricebookBiz, acctBiz.Id);
        TestDataFactory.createOppLineItemTest(prodList, opp, pbeList, 1);
        List<OpportunityLineItem> oppProdList = OpportunityLineItemController.getOpportunityLineItem(opp.Id);
        Order order = TestDataFactory.createOrderTest(opp, acctBiz);
        List<OrderItem> orderItemList = TestDataFactory.createOrderItemTest(order, oppProdList);

        order.Status = 'Activated';
        try {
            Test.startTest();
            update order;
            Test.stopTest();
        } catch (DmlException e) {
            Assert.areEqual(e.getMessage().contains('The minimum quantity for Business account is 5. Please update the Order'), true);

        }
        Order unchangedOrder = [SELECT Status, Order_Quantity__c FROM Order WHERE Id = :order.Id];
        Assert.areEqual(2, unchangedOrder.Order_Quantity__c, 'Should return 2');
        Assert.areEqual('Draft', unchangedOrder.Status, 'Should return Draft');
    }

    //Test de la mise à jour au statut Validated d'une commande Business avec une quantité > 5 (mise à jour autorisée)
    @isTest
    static void testTriggerOnBizAccountWithRightQuantity() {
        Account acctBiz = TestDataFactory.createBusinessAccountTest();
        Pricebook2 testPricebookBiz = TestDataFactory.createTestPricebookBiz();
        Pricebook2 testPricebookPerson = TestDataFactory.createTestPricebookPerson();
        List<Product2> prodList = TestDataFactory.createTestProductList();
        List<PricebookEntry> pbeList = TestDataFactory.createPricebookEntryList(prodList, testPricebookBiz, testPricebookPerson);
        Opportunity opp = TestDataFactory.createOpportunityTest(testPricebookBiz, acctBiz.Id);
        TestDataFactory.createOppLineItemTest(prodList, opp, pbeList, 2);
        List<OpportunityLineItem> oppProdList = OpportunityLineItemController.getOpportunityLineItem(opp.Id);
        Order order = TestDataFactory.createOrderTest(opp, acctBiz);
        List<OrderItem> orderItemList = TestDataFactory.createOrderItemTest(order, oppProdList);

        order.Status = 'Activated';
        Test.startTest();
        update order;
        Test.stopTest();

        Order updatedOrder = [SELECT Status, Order_Quantity__c FROM Order WHERE Id = :order.Id];
        Assert.areEqual(5, updatedOrder.Order_Quantity__c, 'Should return 2');
        Assert.areEqual('Activated', updatedOrder.Status, 'Should return Activated');
        }

    //Test de la mise à jour au statut Validated d'une commande Person avec une quantité < 3 (mise à jour non autorisée)
    @isTest
    static void testTriggerOnPersAccountWithQuantityError() {
        Account acctPers = TestDataFactory.createPersonAccountTest();
        Pricebook2 testPricebookBiz = TestDataFactory.createTestPricebookBiz();
        Pricebook2 testPricebookPerson = TestDataFactory.createTestPricebookPerson();
        List<Product2> prodList = TestDataFactory.createTestProductList();
        List<PricebookEntry> pbeList = TestDataFactory.createPricebookEntryList(prodList, testPricebookBiz, testPricebookPerson);
        Opportunity opp = TestDataFactory.createOpportunityTest(testPricebookPerson, acctPers.Id);
        TestDataFactory.createOppLineItemTest(prodList, opp, pbeList, 1);
        List<OpportunityLineItem> oppProdList = OpportunityLineItemController.getOpportunityLineItem(opp.Id);
        Order order = TestDataFactory.createOrderTest(opp, acctPers);
        List<OrderItem> orderItemList = TestDataFactory.createOrderItemTest(order, oppProdList);

        order.Status = 'Activated';
        try {
            Test.startTest();
            update order;
            Test.stopTest();
        } catch (DmlException e) {
            Assert.areEqual(e.getMessage().contains('The minimum quantity for Person account is 3. Please update the Order'), true);

        }
        Order unchangedOrder = [SELECT Status, Order_Quantity__c FROM Order WHERE Id = :order.Id];
        Assert.areEqual(2, unchangedOrder.Order_Quantity__c, 'Should return 2');
        Assert.areEqual('Draft', unchangedOrder.Status, 'Should return Draft');
    }

    //Test de la mise à jour au statut Validated d'une commande Person avec une quantité > 3 (Mise à jour autorisée)
    @isTest
    static void testTriggerOnPersAccountWithRightQuantity() {
        Account acctPers = TestDataFactory.createPersonAccountTest();
        Pricebook2 testPricebookBiz = TestDataFactory.createTestPricebookBiz();
        Pricebook2 testPricebookPerson = TestDataFactory.createTestPricebookPerson();
        List<Product2> prodList = TestDataFactory.createTestProductList();
        List<PricebookEntry> pbeList = TestDataFactory.createPricebookEntryList(prodList, testPricebookBiz, testPricebookPerson);
        Opportunity opp = TestDataFactory.createOpportunityTest(testPricebookPerson, acctPers.Id);
        TestDataFactory.createOppLineItemTest(prodList, opp, pbeList, 2);
        List<OpportunityLineItem> oppProdList = OpportunityLineItemController.getOpportunityLineItem(opp.Id);
        Order order = TestDataFactory.createOrderTest(opp, acctPers);
        List<OrderItem> orderItemList = TestDataFactory.createOrderItemTest(order, oppProdList);

        order.Status = 'Activated';
        
        Test.startTest();
        update order;
        Test.stopTest();

        Order updatedOrder = [SELECT Status, Order_Quantity__c FROM Order WHERE Id = :order.Id];
        Assert.areEqual(5, updatedOrder.Order_Quantity__c, 'Should return 5');
        Assert.areEqual('Activated', updatedOrder.Status, 'Should return Activated');
    }
}