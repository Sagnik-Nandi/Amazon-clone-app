const express = require('express');
const userRouter = express.Router();
const auth=require('../middleware/auth');
const User = require('../models/user');
const { Product } = require('../models/product');
const Order = require('../models/order');

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

//remove from cart
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

//save user address
userRouter.post('/api/save-address', auth, async(req, res)=>{
    try {
        const {address} = req.body;
        let user= await User.findById(req.user);

        user.address=address;
        user = await user.save();
        res.json(user);
    } catch (err) {
        res.status(500).json({error: err.message});
    }
})

//order a product
userRouter.post('/api/order-products', auth, async(req, res)=>{
    try {
        const {cart, totalPrice, address} = req.body;
        let items=[];

        for(let i=0; i<cart.length; i++){
            let product = await Product.findById(cart[i].product._id);
            //this gets us product from the admin side
            if(product.quantity >= cart[i].quantity){
                //validates if ordered quantity is available
                product.quantity -= cart[i].quantity;
                items.push({product, quantity: cart[i].quantity});
                await product.save();
            }
            else{
                return res.status(400).json({msg: `${product.name} is out of stock`});
            }
        }

        //update user cart
        let user = await User.findById(req.user);
        user.cart=[];
        user = await user.save();

        //create the order
        let order= new Order({
            items,
            totalPrice,
            address,
            userId: req.user,
            orderedAt: new Date().getTime(),
        })
        order = await order.save();
        res.json(order);

    } catch (err) {
        res.status(500).json({error: err.message});
    }
})

//fetch order details
userRouter.get('/api/fetch-orders', auth, async(req, res)=>{
    try {
        const orders = await Order.find({userId:req.user});
        res.json(orders);
    } catch (err) {
        res.status(500).json({error: err.message});
    }
})
module.exports= userRouter;