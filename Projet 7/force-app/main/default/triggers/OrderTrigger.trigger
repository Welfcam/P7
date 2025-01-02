trigger OrderTrigger on Order (before update, after update) {//+before insert
        for (Order order : Trigger.new) {
        if(order.Status == 'Activated' && (Trigger.oldMap.get(order.Id).Status != 'Activated')) {
            if(Trigger.isBefore) {
                OrderTriggerController.preventValidateOrderIfQtyError(order);
            }
            if(Trigger.isAfter) {
                OrderTriggerController.createDelivery(order);
            }
        }
    }
}

// TODO: Verifier si la commande répond aux critères
    //  de validation. Cette méthode doit s'assurer que le nombre minimum de produits est respecté en fonction du type
    //  de client (Particulier ou Professionnel).
    //  TODO: Selectionner le meilleur transporteur selon le choix fait sur la commande