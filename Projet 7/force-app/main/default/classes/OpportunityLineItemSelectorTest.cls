@isTest
private class OpportunityLineItemSelectorTest {

    @isTest
    static void test3OppProdOnBizAccount() {
        Account acctBiz = TestDataFactory.createBusinessAccountTest();
        Pricebook2 testPricebookBiz = TestDataFactory.createTestPricebookBiz();
        Pricebook2 testPricebookPerson = TestDataFactory.createTestPricebookPerson();
        List<Product2> prodList = TestDataFactory.createTestProductList();
        List<PricebookEntry> pbeList = TestDataFactory.createPricebookEntryList(prodList, testPricebookBiz, testPricebookPerson);
        Opportunity opp = TestDataFactory.createOpportunityTest(testPricebookBiz, acctBiz.Id);
        List<OpportunityLineItem> oppProdList = TestDataFactory.createOppLineItemTest(prodList, opp, pbeList, 3);
        Test.startTest();
        List<OpportunityLineItem> results = OpportunityLineItemSelector.getOpportunityLineItemByOppId(opp.Id);
        Test.stopTest();
        Assert.areEqual(3, results.size(), 'Should return 3 opportunity product');
        Assert.areEqual('Produit 1', results[0].Product2.Name, 'Should return Produit 1');
        Assert.areEqual(4, results[2].Quantity, 'Should return 4');
        Assert.areEqual(1500, results[2].PricebookEntry.UnitPrice, 'Should return 1500');
    }

    @isTest
    static void test3OppProdOnPersonAccount() {
        Account acctPers = TestDataFactory.createPersonAccountTest();
        Pricebook2 testPricebookBiz = TestDataFactory.createTestPricebookBiz();
        Pricebook2 testPricebookPerson = TestDataFactory.createTestPricebookPerson();
        List<Product2> prodList = TestDataFactory.createTestProductList();
        List<PricebookEntry> pbeList = TestDataFactory.createPricebookEntryList(prodList, testPricebookBiz, testPricebookPerson);
        Opportunity opp = TestDataFactory.createOpportunityTest(testPricebookPerson, acctPers.Id);
        List<OpportunityLineItem> oppProdList = TestDataFactory.createOppLineItemTest(prodList, opp, pbeList, 3);
        Test.startTest();
        List<OpportunityLineItem> results = OpportunityLineItemSelector.getOpportunityLineItemByOppId(opp.Id);
        Test.stopTest();
        Assert.areEqual(3, results.size(), 'Should return 3 opportunity product');
        Assert.areEqual('Produit 3', results[2].Product2.Name, 'Should return Produit 3');
        Assert.areEqual(3, results[1].Quantity, 'Should return 3');
        Assert.areEqual(3000, results[0].PricebookEntry.UnitPrice, 'Should return 3000');
    }

    @isTest
    static void test1OppProdOnPersonAccount() {
        Account acctPers = TestDataFactory.createPersonAccountTest();
        Pricebook2 testPricebookBiz = TestDataFactory.createTestPricebookBiz();
        Pricebook2 testPricebookPerson = TestDataFactory.createTestPricebookPerson();
        List<Product2> prodList = TestDataFactory.createTestProductList();
        List<PricebookEntry> pbeList = TestDataFactory.createPricebookEntryList(prodList, testPricebookBiz, testPricebookPerson);
        Opportunity opp = TestDataFactory.createOpportunityTest(testPricebookPerson, acctPers.Id);
        List<OpportunityLineItem> oppProdList = TestDataFactory.createOppLineItemTest(prodList, opp, pbeList, 1);
        Test.startTest();
        List<OpportunityLineItem> results = OpportunityLineItemSelector.getOpportunityLineItemByOppId(opp.Id);
        Test.stopTest();
        Assert.areEqual(1, results.size(), 'Should return 1 opportunity product');
        Assert.areEqual('Produit 1', results[0].Product2.Name, 'Should return Produit 1');
        Assert.areEqual(2, results[0].Quantity, 'Should return 2');
        Assert.areEqual(3000, results[0].PricebookEntry.UnitPrice, 'Should return 3000');
    }
}