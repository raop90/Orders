public with sharing class OrderAPI {
    public class ResponseWrapper {
        @AuraEnabled public String status;
        @AuraEnabled public String message;
        @AuraEnabled public String orderId;

        public ResponseWrapper(String status, String message, String orderId) {
            this.status = status;
            this.message = message;
            this.orderId = orderId;
        }
    }

    @AuraEnabled
    public static ResponseWrapper createOrder(String externalOrderId, Map<String, Object> orderDetails, List<Map<String, Object>> items) {
        try {
            Orderr__c orderr = new Orderr__c();
            orderr.Name = (String) orderDetails.get('orderName');
            orderr.Order_External_Id__c = externalOrderId;
            orderr.Total_Amount__c = Decimal.valueOf(String.valueOf(orderDetails.get('totalAmount')));
            orderr.Currency__c = (String) orderDetails.get('currency');
            String orderDate = (String) orderDetails.get('orderDate');
            if (orderDate != null) {
                try {
                    orderr.Order_Date__c = DateTime.valueOf(orderDate);
                } catch (Exception e) {
                    return new ResponseWrapper('error', 'Invalid date/time format: ' + orderDate, null);
                }
            }
            orderr.Shipping_Method__c = (String) orderDetails.get('shippingMethod');
            insert orderr;

            List<Order_Item__c> orderItems = new List<Order_Item__c>();
            for (Map<String, Object> item : items) {
                Order_Item__c orderItem = new Order_Item__c();
                orderItem.Name = (String) item.get('orderItemName');
                orderItem.Product_Name__c = (String) item.get('productName');
                orderItem.Quantity__c = Integer.valueOf(String.valueOf(item.get('quantity')));
                orderItem.Price__c = Decimal.valueOf(String.valueOf(item.get('price')));
                orderItem.Orderr__c = orderr.Id;
                orderItems.add(orderItem);
            }
            insert orderItems;

            return new ResponseWrapper('success', 'Order created successfully', orderr.Id);
        } catch (Exception e) {
            return new ResponseWrapper('error', e.getMessage(), null);
        }
    }
}
