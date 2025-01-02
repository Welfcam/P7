import { LightningElement, api, wire } from 'lwc';
import getOpportunityLineItem from '@salesforce/apex/OpportunityLineItemController.getOpportunityLineItem';
import { NavigationMixin } from 'lightning/navigation';
import { deleteRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { RefreshEvent } from 'lightning/refresh';

export default class OpportunityProductViewer extends NavigationMixin(LightningElement) {
    @api recordId;
    opportunityProducts;
    wiredOpportunityLineItemResult;
    error;
    emptyTable;
    totalQuantity;

    //Colonnes du tableau d'affichage des Opportunités Produits
    columns = [
        { label: 'Name', fieldName: 'Name', type: 'text'},
        { label: 'Quantity', fieldName: 'Quantity', type: 'number'},
        { label: 'Unit Price', fieldName: 'UnitPrice', type: 'currency'},
        { label: 'TotalPrice', fieldName: 'TotalPrice', type: 'currency'},
        {
            type: 'button-icon', label: 'Delete', typeAttributes: {
                name: 'Delete',
                title: 'Delete',
                value: 'delete',
                iconName: 'utility:delete'
            }
        },
        {   type: 'button-icon', label: 'See Product', typeAttributes: {
                label: 'See Product',
                name: 'See Product',
                title: 'See Product',
                value: 'seeProduct',
                iconName: 'utility:preview',
                iconPosition: 'left',
                variant: 'brand'
            }
        }
    ];

    //Récupère les données relatives aux opportunités produit
    @wire(getOpportunityLineItem, { opportunityId: '$recordId'})
    wiredOpportunityLineItemResult (result) {
        this.wiredOpportunityLineItemResult = result;
        if(result.data) {
            if(result.data.length>0) {
                this.error = undefined;
                this.emptyTable = undefined;
                this.opportunityProducts = [];
                result.data.forEach(line => {
                    let oppProd = {};
                    oppProd.Id = line.Id;
                    oppProd.Name = line.Product2.Name;
                    oppProd.ProdId = line.Product2.Id;
                    oppProd.Quantity = line.Quantity;
                    oppProd.UnitPrice = line.PricebookEntry.UnitPrice;
                    oppProd.TotalPrice = line.TotalPrice;
                    this.opportunityProducts.push(oppProd);
                })
            } else {
                this.opportunityProducts = undefined;
                this.error = undefined;
                this.emptyTable = "No products are associated with this opportunity.";
            }
        } else {
            this.opportunityProducts = undefined;
            this.error = "An error occurred while loading opportunity products.";
            this.emptyTable = undefined;
        }
        this.isLoading = false;
        this.refreshRelatedList();
    }

    handleRefresh() {
        refreshApex(this.wiredOpportunityLineItemResult);
    }

    //Gestion des clics sur les boutons 'Supprimer' et 'Voir Produit'
    handleRowAction(event) {
        const oppProdId = event.detail.row.Id;
        const relatedProductId = event.detail.row.ProdId;
        const actionName = event.detail.action.name;
        if (actionName === 'See Product') {
            this.handleSeeProduct(relatedProductId);
        } else if (actionName === 'Delete') {
            this.isLoading = true;
            this.handleDelete(oppProdId);
        }
    };

    //Redirection vers la page Produit en cliquant sur le bouton 'Voir Produit'
    handleSeeProduct(relatedProductId) {
        this[NavigationMixin.Navigate] ({
            type: "standard__recordPage",
            attributes: {
                recordId: relatedProductId, 
                objectApiName: "Product2",
                actionName: "view",
            },
        });
    }

    //Suppression d'une ligne du tableau d'opportunité produits en cliquant sur le bouton "Supprimer"
    handleDelete(oppProdId) {
        deleteRecord(oppProdId)
            .then(result => {
                refreshApex(this.wiredOpportunityLineItemResult);
            })
            .catch(error => {
                this.error = error;
            })   
    }

    //Rafraichit la related list Produit lorsque le tableau est modifié
    refreshRelatedList() {
        this.dispatchEvent(new RefreshEvent());
    }
}
