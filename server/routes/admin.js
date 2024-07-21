const express = require('express');
const adminRouter = express.Router();
const admin = require('../middleware/admin');
const {Product} = require('../models/product');
const Order = require('../models/order');

//Add product
adminRouter.post('/admin/add-product', admin, async (req, res)=>{
    try {
        const {name, description, price, quantity, category, images} = req.body;
        var product= new Product({name, description, price, category, quantity, images});

        product = await product.save();
        res.json(product);
    } catch (err) {
        res.status(500).json({error:err.message});
    }
})

//Change product details
adminRouter.post('/admin/edit-product', admin, async(req, res)=>{
    try{
        const {name, description, price, quantity, category, images, id} = req.body;
        let product = await Product.findById(id);
        product.name=name;
        product.description=description;
        product.price=price;
        product.quantity=quantity;
        product.category=category;
        product.images=images;

        product = await product.save();
        res.json(product);
    } catch(err) {
        res.status(500).json({error:err.message});
    }
})

//Get all products
adminRouter.get('/admin/get-products', admin, async (req, res)=>{
    try {
        const products= await Product.find();
        res.json(products);
    } catch (err) {
        res.status(500).json({error:err.message});
    }
})

//Delete selected product
adminRouter.post('/admin/remove-product', admin, async (req, res)=>{
    try {
        const {id} = req.body;
        const product= await Product.findByIdAndDelete(id);
        res.json(product);
    } catch (err) {
        res.status(500).json({error:err.message});
    }
})

//Get all orders
adminRouter.get('/admin/get-orders', admin, async (req, res)=>{
    try {
        const orders= await Order.find();
        res.json(orders);
    } catch (err) {
        res.status(500).json({error:err.message});
    }
})

//Track and update order status
adminRouter.post('/admin/update-order-status', admin, async(req, res)=>{
    try {
        const {id} = req.body;
        let order = await Order.findById(id);
        order.status+=1;
        order = await order.save();
        res.json(order);
    } catch (err) {
        res.status(500).json({error:err.message});
    }
})

//Fetch all earnings frrom sales
adminRouter.get('/admin/analytics', admin, async(req, res)=>{
    try {
        const orders = await Order.find({});
        let totalEarnings = 0;

        for(let i=0; i<orders.length; i++){
            for(let j=0; j<orders[i].items.length; j++){
                totalEarnings+=orders[i].items[j].quantity*orders[i].items[j].product.price;
            }
        }

        let mobileEarnings = await categoryWiseProducts('Mobiles');
        let essentialEarnings = await categoryWiseProducts('Essentials');
        let applianceEarnings = await categoryWiseProducts('Appliances');
        let bookEarnings = await categoryWiseProducts('Books');
        let fashionEarnings = await categoryWiseProducts('Fashion');

        let earnings = {
            totalEarnings,
            mobileEarnings,
            essentialEarnings,
            applianceEarnings,
            bookEarnings,
            fashionEarnings,
        }
        res.json(earnings);
    } catch (err) {
        res.status(500).json({error: err.message})
    }
})

async function categoryWiseProducts(category){
    let categoryOrders = await Order.find({
        'items.product.category': category,
    });
    let categoryEarnings=0;
    for(let i=0; i<categoryOrders.length; i++){
        for(let j=0; j<categoryOrders[i].items.length; j++){
            categoryEarnings+=categoryOrders[i].items[j].quantity*categoryOrders[i].items[j].product.price;
        }
    }
    return categoryEarnings;
}
module.exports=adminRouter;