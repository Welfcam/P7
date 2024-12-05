trigger OrderTrigger on Order (before insert, before update) {
    // TODO: Verifier érifier si la commande répond aux critères
    //  de validation. Cette méthode doit s'assurer que le nombre minimum de produits est respecté en fonction du type
    //  de client (Particulier ou Professionnel).
    //  TODO: Selectionner le meilleur transporteur selon le choix fait sur la commande
}