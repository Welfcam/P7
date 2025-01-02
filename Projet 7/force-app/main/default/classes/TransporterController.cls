//Gère la récupération des données de transporter Conditions en fonction de choix de l'utilisateur
//option 1 = meilleure option => la moins chère des plus rapides
//option 2 = toutes les options possibles
public with sharing class TransporterController {
    @AuraEnabled(Cacheable=true)
    public static List<Transporter_Conditions__c> getTransporters(Id orderId, String transpChoosen) {
        if(transpChoosen == 'option1') {
            return TransporterSelector.getBestTransporterConditionsByOrder(orderId);
        } else {
            return TransporterSelector.getAllTransporterConditionsByOrder(orderId);
        }
    }
}