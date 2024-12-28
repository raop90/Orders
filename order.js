import { LightningElement, track } from 'lwc';
import createOrder from '@salesforce/apex/OrderAPI.createOrder';

export default class OrderComponent extends LightningElement {
    @track orderName = '';
    @track orderExternalId = '';
    @track totalAmount = 0;
    @track currency = '';
    @track orderDate = '';
    @track shippingMethod = '';
    @track responseMessage = '';

    handleInputChange(event) {
        const field = event.target.dataset.id;
        this[field] = event.target.value;
    }

    async handleSubmit() {
        const orderDetails = {
            orderName: this.orderName,
            totalAmount: this.totalAmount,
            currency: this.currency,
            orderDate: this.orderDate,
            shippingMethod: this.shippingMethod
        };

        try {
            const result = await createOrder({
                externalOrderId: this.orderExternalId,
                orderDetails: orderDetails,
                items: [] // You can extend this to handle items
            });
            this.responseMessage = result.message;
        } catch (error) {
            this.responseMessage = `Error: ${error.body.message}`;
        }
    }
}
