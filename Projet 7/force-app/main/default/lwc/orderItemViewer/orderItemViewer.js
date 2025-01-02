import { LightningElement, api, wire } from 'lwc';
import getOrderItem from '@salesforce/apex/OrderItemController.getOrderItem';
import { NavigationMixin } from 'lightning/navigation';
import { deleteRecord, updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { RefreshEvent } from 'lightning/refresh';
import getTransporters from '@salesforce/apex/TransporterController.getTransporters';
import activateOrder from '@salesforce/apex/OrderController.activateOrder';
import hasPermission from '@salesforce/customPermission/View_Transporter_Options';
import {getRecord, getFieldValue } from 'lightning/uiRecordApi';
import TOTAL_AMOUNT_FIELD from '@salesforce/schema/Order.TotalAmount';
import ACCOUNT_NAME_FIELD from '@salesforce/schema/Order.Account.Name';
import ORDER_QUANTITY_FIELD from '@salesforce/schema/Order.Order_Quantity__c';
import SHIPPING_STREET_FIELD from '@salesforce/schema/Order.ShippingStreet';
import SHIPPING_POSTALCODE_FIELD from '@salesforce/schema/Order.ShippingPostalCode';
import SHIPPING_CITY_FIELD from '@salesforce/schema/Order.ShippingCity';
import SHIPPING_COUNTRY_FIELD from '@salesforce/schema/Order.ShippingCountry';
import ORDER_TRANSPORTER_NAME_FIELD from '@salesforce/schema/Order.Selected_Transporter__r.Name';
import ORDER_STATUS_FIELD from '@salesforce/schema/Order.Status';
import ORDER_GLOBAL_COST_FIELD from '@salesforce/schema/Order.Order_Global_Cost__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
const FIELDS = [TOTAL_AMOUNT_FIELD, ACCOUNT_NAME_FIELD, ORDER_QUANTITY_FIELD, SHIPPING_STREET_FIELD, SHIPPING_POSTALCODE_FIELD, SHIPPING_CITY_FIELD, SHIPPING_COUNTRY_FIELD, ORDER_TRANSPORTER_NAME_FIELD, ORDER_GLOBAL_COST_FIELD, ORDER_STATUS_FIELD];

export default class OpportunityProductViewer extends NavigationMixin(LightningElement) {
    @api recordId;
    @api objectApiName;
    orderProducts;
    wiredOrderItemResult;
    error;
    emptyTable;
    wiredTransporterResult;
    transporter;
    transpOption = 'option1';
    rowId;
    rowCost;
    orderGlobalCost = 'Please select a transporter';
    selectedTransporterName = 'Please select a transporter';
    selectedTransporter;
    isTransporterSelected;
    orderAmount;
    accountName;
    orderQuantity;
    shippingStreet;
    shippingPostalCode;
    shippingCity;
    shippingCountry;
    orderStatus;
    isOrderActivated = false;
    
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
    ]

    @wire(getOrderItem, { orderId: '$recordId'})
    wiredOrderItem (result) {
        this.wiredOrderItemResult = result;
        if(result.data) {
            if(result.data.length>0) {
                this.error = undefined;
                this.emptyTable = undefined;
                this.orderProducts = [];
                result.data.forEach(line => {
                    let orderProd = {};
                    orderProd.Id = line.Id;
                    orderProd.Name = line.Product2.Name;
                    orderProd.ProdId = line.Product2.Id;
                    orderProd.Quantity = line.Quantity;
                    orderProd.UnitPrice = line.PricebookEntry.UnitPrice;
                    orderProd.TotalPrice = line.TotalPrice;
                    this.orderProducts.push(orderProd);
                })
            } else {
                this.orderProducts = undefined;
                this.error = undefined;
                this.emptyTable = "No products are associated with this order.";
            }
        } else {
            this.orderProducts = undefined;
            this.error = "An error occurred while loading order products.";
            this.emptyTable = undefined;
        }
        this.isLoading = false;
        this.refreshRelatedList();
    }

    handleRefresh() {
        refreshApex(this.wiredOrderItemResult);
    }

    //Gestion des clics sur les boutons 'Supprimer' et 'Voir Produit'
    handleRowAction(event) {
        const orderProdId = event.detail.row.Id;
        const relatedProductId = event.detail.row.ProdId;
        const actionName = event.detail.action.name;
        if (actionName === 'See Product') {
            this.handleSeeProduct(relatedProductId);
        } else if (actionName === 'Delete') {
            this.isLoading = true;
            this.handleDelete(orderProdId);
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
    handleDelete(orderProdId) {
        deleteRecord(orderProdId)
            .then(result => {
                refreshApex(this.wiredOrderItemResult);
            })
            .catch(error => {
                this.error = error;
            })   
    }

    //Rafraichit la related list Produit lorsque le tableau est modifié
    refreshRelatedList() {
        this.dispatchEvent(new RefreshEvent());
    }

    //Définit la valeur de options lors du choix du bouton radio
    get options() {
        return [
            { label: 'Best option', value: 'option1' },
            { label: 'Choose another transporter', value: 'option2'},
        ];
    }

    //Colonnes pour afficher les données des transporter Conditions    
    transporterColumns = [
        { label: 'Name', fieldName: 'Name', type: 'text', cellAttributes: { class: { fieldName: 'rowClass'} }},
        { label: 'Delivery Zone', fieldName: 'Delivery_Zone__c', type: 'text', cellAttributes: { class: { fieldName: 'rowClass'} }},
        { label: 'Delivery Cost', fieldName: 'Delivery_Cost__c', type: 'currency', cellAttributes: { class: { fieldName: 'rowClass'} }},
        { label: 'Delivery Time', fieldName: 'Delivery_Time__c', type: 'number', cellAttributes: { class: { fieldName: 'rowClass'} }},
        {
            type: "button", typeAttributes: {
                label: { fieldName: 'buttonLabel'},
                name: 'Choose',
                title: 'Choose this transporter',
                value: 'choose',
                variant: { fieldName: 'buttonStyle'}
            }
        }    
    ]

    //Récupère les données pour compléter la partie Delivery Summary
    @wire(getRecord, { recordId : '$recordId', fields: FIELDS})
    wiredOrder ({ error, data }) {
        if(data) {
            this.orderAmount = getFieldValue(data, TOTAL_AMOUNT_FIELD);
            this.accountName = getFieldValue(data, ACCOUNT_NAME_FIELD);
            this.orderQuantity = getFieldValue(data, ORDER_QUANTITY_FIELD);
            this.shippingStreet = getFieldValue(data, SHIPPING_STREET_FIELD);
            this.shippingPostalCode = getFieldValue(data, SHIPPING_POSTALCODE_FIELD);
            this.shippingCity = getFieldValue(data, SHIPPING_CITY_FIELD);
            this.shippingCountry = getFieldValue(data, SHIPPING_COUNTRY_FIELD);
            this.orderStatus = getFieldValue(data, ORDER_STATUS_FIELD);
            
            //Si l'order est au statut Activated, Order Global Cost et Selected transporter de la partie summary est mise à jour avec les données de l'order
            if(this.orderStatus === 'Activated') {
                this.orderGlobalCost = getFieldValue(data, ORDER_GLOBAL_COST_FIELD);    
                this.selectedTransporterName = getFieldValue(data, ORDER_TRANSPORTER_NAME_FIELD);
                this.isOrderActivated = true;
            }
        //En cas d'erreur un message d'erreur est affiché dans la console    
        } else if(error) {
            console.error('Error retrieving order: ', error)
        }
    }
    
    //Récupère les données des transporter Conditions  en fonction de la valeur du bouton radio
    @wire(getTransporters, { orderId : '$recordId', transpChoosen : '$transpOption'})
    wiredTransporter (result) {
        this.wiredTransporterResult = result;
        //S'il y a des transporteurs compatibles, les données sont retournées
        if(result.data) {
            //Boucle à travers les différentes lignes du tableau renvoyé par @wire getTransporter
            this.transporter = result.data.map((line) => {
                //Création de variables pour gérer la mise en forme de la ligne sélectionnée dans le tableau
                let rowClass;
                let buttonLabel;
                let buttonStyle;
                //L'option 1 (best option) est sélectionnée par défaut et le transporteur correspondant également
                if(this.transpOption === 'option1') {
                    this.rowId = result.data[0].Id;
                    this.rowCost = result.data[0].Delivery_Cost__c;
                }
                //Si l'Id de la ligne du tableau parcourru correspond à l'Id de la ligne sur laquelle l'utilisateur à cliqué sur "Choose"
                //la ligne et le bouton sont mis en forme et les données affichées dans la partie Delivery Summary
                if(line.Id == this.rowId) {
                    rowClass = 'slds-text-color_success slds-text-title_bold slds-theme_shade';
                    buttonLabel = 'Selected';
                    buttonStyle = 'success';
                    this.orderGlobalCost = this.orderAmount + this.rowCost + ' €';
                    this.selectedTransporterName = line.Name;
                    this.selectedTransporter = line.Id;
                    this.isTransporterSelected = true;
                //Dans les autres cas, la mise en forme reste standard    
                } else {
                    rowClass = '';
                    buttonLabel = 'Choose';
                    buttonStyle = 'brand';
                }
                return {...line, rowClass: rowClass, buttonLabel: buttonLabel, buttonStyle: buttonStyle};
            });
            this.error = undefined;
        } else {
            //En cas d'erreur lors du chargement des données, un message d'erreur s'affiche.
            this.transporter = undefined;
            this.error = "An error occured while loading the transporter options";
        };
    }

    //Gère le changement de bouton radio
    handleTransporterChoice(event) {
        this.transpOption = event.detail.value;
    }

    //Gère le clique sur le bouton Choose dans le tableau des transporteurs compatibles
    handleChoose(event) {
        this.rowId = event.detail.row.Id;
        this.rowCost = event.detail.row.Delivery_Cost__c;
        this.wiredTransporter(this.wiredTransporterResult);
    };

    

    //Gestion du clic sur le bouton Activate Order, une fois le transporteur sélectionné
    async handleActivateOrder() {
        try {
            await activateOrder({ orderId : this.recordId, selectedTransporter : this.selectedTransporter });
            this.dispatchEvent(new RefreshEvent());
        
        //Si la quantité de l'order est insuffisante, un message d'erreur informe l'utilisateur    
        } catch (error) {
            const event = new ShowToastEvent({
                title: 'Quantity Error',
                message: error.body.pageErrors[0].message,
                variant: 'error'
            });
            this.dispatchEvent(event);
            console.log(error);
        }
    }

    //Gestion de la permission pour voir le choix des transporteur dans une commande Draft
    get canViewTransporterOptions() {
        return hasPermission;
    }
}