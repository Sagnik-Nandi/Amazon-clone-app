const express = require('express');
const productRouter = express.Router();
const auth = require("../middleware/auth");
const Product = require("../models/product");

//Get products of a specific category
productRouter.get("/api/products", auth, async(req, res)=>{
    try {
        //there is no body in get request but we need to pass the category name
        //there is a way of passing info without using req.body
        
        //in the client side if they send request to the url
        // "/api/products?category=Essentials" then it is there in req.query
        // or "/api/products:category=Essentials" then req.params

        const products = await Product.find({category: req.query.category});
        res.json(products);
    } catch (err) {
        res.status(500).json({error: err.message});
    }
})

//Search products based on input text
productRouter.get("/api/products/search/:input", auth, async(req, res)=>{
    try {
        //req.params.input collects whatever is passed after the ..search/
        var nameRegex = new RegExp(req.params.input);
        const products = await Product.find({
            name: {$regex:nameRegex, $options:'i'}
        });
        console.log(products[0].name);
        res.json(products);
    } catch (err) {
        res.status(500).json({error: err.message});
    }
})

module.exports= productRouter;