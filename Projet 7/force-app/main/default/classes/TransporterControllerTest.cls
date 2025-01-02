@isTest
private class TransporterControllerTest {
    //Teste les données récupérées par TransporterController avec Option 1 et Option 2 sur un Compte Business (France)
    @isTest
    static void transporterConditionsSelectorTestWithBizAccount() {
        Account acctBiz = TestDataFactory.createBusinessAccountTest();
        Pricebook2 testPricebookBiz = TestDataFactory.createTestPricebookBiz();
        Pricebook2 testPricebookPerson = TestDataFactory.createTestPricebookPerson();
        List<Product2> prodList = TestDataFactory.createTestProductList();
        List<PricebookEntry> pbeList = TestDataFactory.createPricebookEntryList(prodList, testPricebookBiz, testPricebookPerson);
        Opportunity opp = TestDataFactory.createOpportunityTest(testPricebookBiz, acctBiz.Id);
        Order order = TestDataFactory.createOrderTest(opp, acctBiz);
        List<Transporter__c> transporterList = TestDataFactory.createTransportersTest();
        List<Transporter_Conditions__c> transporterConditionsList = TestDataFactory.createTransporterConditionsTest(transporterList);
        Test.startTest();
        List<Transporter_Conditions__c> bestResult = TransporterController.getTransporters(order.Id, 'option1');
        List<Transporter_Conditions__c> allResults = TransporterController.getTransporters(order.Id, 'option2');
        Test.stopTest();
        Assert.areEqual(1, bestResult.size(), 'Should return 1');
        Assert.areEqual('France', bestResult[0].Delivery_Zone__c, 'Should return France');
        Assert.areEqual('DHL France', bestResult[0].Name, 'Should return DHL France');
        Assert.areEqual(2, allResults.size(), 'Should return 2');
        Assert.areEqual('Amazon France', allResults[1].Name, 'Should return Amazon France');
    }

    //Teste les données récupérées par TransporterController avec Option 1 et Option 2 sur un Compte Person (Belgique)
    @isTest
    static void transporterConditionsSelectorTestWithPersonAccount() {
        Account acctPers = TestDataFactory.createPersonAccountTest();
        Pricebook2 testPricebookBiz = TestDataFactory.createTestPricebookBiz();
        Pricebook2 testPricebookPerson = TestDataFactory.createTestPricebookPerson();
        List<Product2> prodList = TestDataFactory.createTestProductList();
        List<PricebookEntry> pbeList = TestDataFactory.createPricebookEntryList(prodList, testPricebookBiz, testPricebookPerson);
        Opportunity opp = TestDataFactory.createOpportunityTest(testPricebookPerson, acctPers.Id);
        Order order = TestDataFactory.createOrderTest(opp, acctPers);
        List<Transporter__c> transporterList = TestDataFactory.createTransportersTest();
        List<Transporter_Conditions__c> transporterConditionsList = TestDataFactory.createTransporterConditionsTest(transporterList);
        Test.startTest();
        List<Transporter_Conditions__c> bestResult = TransporterController.getTransporters(order.Id, 'option1');
        List<Transporter_Conditions__c> allResults = TransporterController.getTransporters(order.Id, 'option2');
        Test.stopTest();
        Assert.areEqual(1, bestResult.size(), 'Should return 1');
        Assert.areEqual('Belgique', bestResult[0].Delivery_Zone__c, 'Should return Belgique');
        Assert.areEqual('Chronopost Belgique', bestResult[0].Name, 'Should return Chronopost Belgique');
        Assert.areEqual(2, allResults.size(), 'Should return 2');
        Assert.areEqual('Amazon Belgique', allResults[1].Name, 'Should return Amazon Belgique');
    }
}