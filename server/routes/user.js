const express = require('express');
const userRouter = express.Router();
const auth=require('../middleware/auth');
const User = require('../models/user');
const { Product } = require('../models/product');

//add to cart
userRouter.post('/api/add-to-cart', auth, async(req, res)=>{
    try {
        const {id}=req.body;
        const product= await Product.findById(id);
        let user= await User.findById(req.user);

        let i=0;
        for(i=0; i<user.cart.length; i++){
            if(user.cart[i].product._id.equals(product._id)){
                //found in cart
                user.cart[i].quantity+=1;
                break;
            }
        }
        if(i==user.cart.length){
            //not found in cart
            user.cart.push({product, quantity:1});
        }

        user = await user.save();
        res.json(user);
    } catch (err) {
        res.status(500).json({error: err.message})
    }
})

userRouter.delete('/api/remove-from-cart', auth, async(req, res)=> {
    try {
        const {id} = req.body;
        const product= await Product.findById(id);
        let user= await User.findById(req.user);

        for(let i =0; i<user.cart.length; i++){
            if(user.cart[i].product._id.equals(product._id)){
                if(user.cart[i].quantity==1){
                    user.cart.splice(i,1);
                }else{
                    user.cart[i].quantity-=1;
                }
            }
        }

        await user.save();
        res.json(user);
    } catch (err) {
        res.status(500).json({error: err.message});
    }
})

module.exports= userRouter;