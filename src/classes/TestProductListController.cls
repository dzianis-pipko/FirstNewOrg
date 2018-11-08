/**
 * Created by Denis on 06.11.2018.
 */

@IsTest private class TestProductListController {

    @testSetup static void testAutoRun() {

        Product_Table__c ProductList = new Product_Table__c(
                Name = 'iPhone2',
                Image_URL__c = '123',
                Unit_Prise__c = 100,
                Product_description__c = 'Descr',
                Units_Available__c = 3
        );
        insert ProductList;
    }

    @isTest static void testGetNewProductList() {
        ProductListController controller = new ProductListController();
        System.assertNotEquals(null, controller.getNewProductList());
    }

    @isTest static void testProductList() {
        ProductListController controller = new ProductListController();
        System.assertNotEquals(null, controller.ProductList());
    }

    @isTest static void testFormPage() {
        ProductListController controller = new ProductListController();
        List<Product_Table__c> listProd = [SELECT Id FROM Product_Table__c LIMIT 1];
        controller.newId = listProd[0].id;
        System.assertNotEquals(null, controller.FormPage());
    }

    @isTest static void testDetailOpisPage() {
        ProductListController controller = new ProductListController();
        List<Product_Table__c> TestslistProd = [SELECT Id FROM Product_Table__c LIMIT 1];
        controller.newId = TestslistProd[0].id;
        System.assertNotEquals(null, controller.DetailOpisPage());
    }

    @isTest static void testlistContactEmail() {
        Contact TestContact = new Contact(
                Email = 'den@mail.ru',
                FirstName = '123',
                LastName = '123'
        );

        insert TestContact;

        ProductListController controller = new ProductListController();

        controller.mailperem.Email = 'den@mail.ru';
        controller.mailperem.FirstName = '123';
        controller.mailperem.LastName = '124';
        controller.listContactEmail();
        TestContact = [SELECT Email, FirstName, LastName FROM Contact WHERE Id = :TestContact.Id];
        System.assertEquals('124', TestContact.LastName);
        System.assertEquals('den@mail.ru', TestContact.Email);

        Contact TestContactSecond = new Contact(
                Email = 'positiveTest@mail.ru',
                FirstName = '123',
                LastName = '123'
        );
        insert TestContactSecond;

        controller.mailperem.Email = 'lexa@mail.ru';
        controller.mailperem.FirstName = '123';
        controller.mailperem.LastName = '124';
        controller.listContactEmail();
        TestContactSecond = [SELECT Email, FirstName, LastName  FROM Contact WHERE Email ='lexa@mail.ru'];
        System.assertEquals('124', TestContactSecond.LastName);
        System.assertEquals('lexa@mail.ru', TestContactSecond.Email);

        List<ApexPages.Message> pageMessages = ApexPages.getMessages();
        Boolean orderIsEmpty = false;
        for (ApexPages.Message item : pageMessages) {
            if (item.getDetail().contains('ТОВАРА НЕТ')) {
                orderIsEmpty = true;
            }
        }
        system.assert(orderIsEmpty);

    }

    @isTest static void testlistContactEmailOrderNegative() {
        ProductListController controller = new ProductListController();
        controller.mailperem.Email = 'lexa@mail.ru';
        controller.mailperem.FirstName = '123';
        controller.mailperem.LastName = '124';
        controller.newObjectsProduct = [SELECT Id, Units_Available__c FROM Product_Table__c];

        controller.orderTable.Units__c = 12;
        controller.listContactEmail();

        List<ApexPages.Message> pageMessages = ApexPages.getMessages();
        Boolean orderIsEmpty = false;
        for (ApexPages.Message item : pageMessages) {
            if (item.getDetail().contains('ТОВАРА меньше чем заказ')) {
                orderIsEmpty = true;
            }
        }
        system.assert(orderIsEmpty);
    }
    @isTest static void testlistContactEmailOrderPositive() {
        ProductListController controller = new ProductListController();
        controller.mailperem.Email = 'lexa@mail.ru';
        controller.mailperem.FirstName = '123';
        controller.mailperem.LastName = '124';
        controller.newObjectsProduct = [SELECT Id, Units_Available__c FROM Product_Table__c];

        controller.orderTable.Units__c = 2;
        controller.listContactEmail();

        List<ApexPages.Message> pageMessages = ApexPages.getMessages();
        Boolean orderIsEmpty = false;
        for (ApexPages.Message item : pageMessages) {
            if (item.getDetail().contains('Success')) {
                orderIsEmpty = true;
            }
        }
        system.assert(orderIsEmpty);
    }
    @isTest static void testKalkulator() {
        ProductListController controller = new ProductListController();
        controller.orderTable.Units__c = 2;
        controller.newBuyObjectsProduct.Unit_Prise__c = 4;
        controller.kalculitAmount();
        System.assertEquals(8, controller.orderTable.Order_Amount__c);

    }
}


