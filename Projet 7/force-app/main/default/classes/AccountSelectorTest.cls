@isTest
private class AccountSelectorTest {

    @isTest
    static void testAccountBiz() {
        Account acctBiz = TestDataFactory.createBusinessAccountTest();
        Account selectorAccount = AccountSelector.getAccountById(acctBiz.Id);
        Assert.areEqual('Business', acctBiz.Type, 'Should return Business');
        Assert.areEqual('Energy', acctBiz.Industry, 'Should return Energy');
        Assert.areEqual('Paris', acctBiz.BillingCity, 'Should return Paris');
    }

    static void testAccountPerson() {
        Account acctPers = TestDataFactory.createPersonAccountTest();
        Account selectorAccount = AccountSelector.getAccountById(acctPers.Id);
        Assert.areEqual('Person', acctPers.Type, 'Should return Person');
        Assert.areEqual('Other', acctPers.Industry, 'Should return Other');
        Assert.areEqual('Belgique', acctPers.BillingCountry, 'Should return Belgique');
    }
}