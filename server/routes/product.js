const express = require('express');
const productRouter = express.Router();
const auth = require("../middleware/auth");
const {Product} = require("../models/product");

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
        res.json(products);
    } catch (err) {
        res.status(500).json({error: err.message});
    }
})

//Rate products by user
productRouter.post('/api/rate-product', auth, async(req, res)=>{
    try {
        const {productId, rating}= req.body;
        let product = await Product.findById(productId);
        
        for(let i=0; i<product.ratings.length; i++){
            if(product.ratings[i].userId==req.user){
                product.ratings.splice(i, 1);
                break;
            }
        }
        
        const ratingSchema={
            userId:req.user,
            rating
        }
        product.ratings.push(ratingSchema);
        await product.save();
        res.json(product);
    } catch (err) {
        res.status(500).json({error: err.message});
    }
})

//fetch deal of the day using highest rating
productRouter.get("/api/deal-of-day", auth, async(req, res)=>{
    try {
        let products = await Product.find({});
        let maxRating=0;
        let maxRated=products[0];

        for(let i=0; i<products.length; i++){
            let ratingList=products[i].ratings;
            let totalRating=0;
            for(let j=0; j<ratingList.length; j++){
                totalRating+=ratingList[j].rating;
            }
            if(ratingList.length!=0 && (maxRating<totalRating/ratingList.length)){
                maxRating=totalRating/ratingList.length;
                maxRated=products[i];
            }
        }
        res.json(maxRated);
    } catch (err) {
        res.status(500).jsoon({error:err.message})
    }
})

module.exports= productRouter;