public with sharing class AccountController {
    @AuraEnabled(Cacheable=true)
    public static Account getAccount(Id accountId) {
        return AccountSelector.getAccountById(accountId);
    }
}    