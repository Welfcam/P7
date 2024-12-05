//Exemple de selector
public with sharing class AccountSelector {
    public static Account getAccountById(Id accountId) {
        return [
                SELECT Id, Name, Type, Industry, BillingCity, BillingCountry, Phone, Website
                FROM Account
                WHERE Id = :accountId
        ];
    }
}