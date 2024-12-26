@isTest
private class AccountControllerTest {
    @isTest
    static void testBusinessAccount() {
        Account acctBiz = TestDataFactory.createBusinessAccountTest();
        Account controllerAccount = AccountController.getAccount(acctBiz.Id);
        Assert.areEqual('Business', acctBiz.Type, 'Should return Business');
        Assert.areEqual('Energy', acctBiz.Industry, 'Should return Energy');
        Assert.areEqual('Paris', acctBiz.BillingCity, 'Should return Paris');
    }

    static void testPersonAccount() {
        Account acctPers = TestDataFactory.createPersonAccountTest();
        Account controllerAccount = AccountController.getAccount(acctPers.Id);
        Assert.areEqual('Person', acctPers.Type, 'Should return Person');
        Assert.areEqual('Other', acctPers.Industry, 'Should return Other');
        Assert.areEqual('Belgique', acctPers.BillingCountry, 'Should return Belgique');
    }
}