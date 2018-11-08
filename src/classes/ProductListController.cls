public class ProductListController {


    public String newId {get;set;}
    public Product_Table__c newObjectsProduct {get;set;}

    public Product_Table__c newBuyObjectsProduct {get;set;}
    public Contact mailperem {get;set;}
    public Order_Table__c orderTable {get;set;}

    public ProductListController() {
        mailperem = new Contact();
        orderTable = new Order_Table__c();
        newBuyObjectsProduct = new Product_Table__c ();
    }

    public List<Product_Table__c> getNewProductList () {
        List<Product_Table__c> ProductList = [SELECT Id, Name, Product_Description__c, Image_Url__c, Unit_Prise__c, Title__c FROM Product_Table__c];
        return ProductList;
    }

    public PageReference DetailOpisPage (){
        newObjectsProduct = [SELECT Id, Name, Product_Description__c, Image_Url__c, Unit_Prise__c, Title__c, Units_Available__c FROM Product_Table__c WHERE Id =:newId];
        return Page.DetailOpisPage;
    }

    public PageReference FormPage (){
        newBuyObjectsProduct = [SELECT Id, Name, Unit_Prise__c FROM Product_Table__c WHERE Id =:newId];
        return Page.FormPage;
    }
    public PageReference ProductList (){
        return Page.ProductList;
    }
//--------------
    public void listContactEmail (){
        List<Contact> listContactEmailPerem = [SELECT Email, FirstName, LastName  FROM Contact WHERE Email =:mailperem.Email limit 1];

            if (listContactEmailPerem.isEmpty()){
                Contact ContactInsert = new Contact();
                ContactInsert.Email = mailperem.Email;
                ContactInsert.FirstName = mailperem.FirstName;
                ContactInsert.LastName = mailperem.LastName;
                insert ContactInsert;
            }else{
                listContactEmailPerem[0].FirstName = mailperem.FirstName;
                listContactEmailPerem[0].LastName = mailperem.LastName;
                update listContactEmailPerem;
            }

        orderTable.Contact__c = mailperem.id;
        orderTable.Product__c = newBuyObjectsProduct.id;
        if (newObjectsProduct == null || newObjectsProduct.Units_Available__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'ТОВАРА НЕТ'));
        }else if(newObjectsProduct.Units_Available__c - orderTable.Units__c < 0){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'ТОВАРА меньше чем заказ'));
        }else{
            newObjectsProduct.Units_Available__c = newObjectsProduct.Units_Available__c - orderTable.Units__c;
            insert orderTable;
            update newObjectsProduct;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Success'));
        }
    }
    //-------------
    public void kalculitAmount (){
        orderTable.Order_Amount__c = newBuyObjectsProduct.Unit_Prise__c * orderTable.Units__c;
    }
}