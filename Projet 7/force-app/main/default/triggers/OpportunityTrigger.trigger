trigger OpportunityTrigger on Opportunity (after update) {
    for(Opportunity opp: Trigger.New) {
        if(opp.StageName == 'Closed Won' && (Trigger.oldMap.get(opp.Id).StageName != 'Closed Won')) {
            OpportunityTriggerController.createOrderAndOrderItem(opp);
        }
    }
}