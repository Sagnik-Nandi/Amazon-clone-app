const express = require('express');
const adminRouter = express.Router();
const admin = require('../middleware/admin');
const Product = require('../models/product');

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


module.exports=adminRouter;