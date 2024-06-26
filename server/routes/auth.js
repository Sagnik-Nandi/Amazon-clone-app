//IMPORTs
const express = require("express");
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require("../models/user");
const auth = require("../middleware/auth");


// A Router doesn't .listen() for requests on its own. 
// It's useful for separating your application into multiple modules -- 
// creating a Router in each that the app can require() and .use() as middleware. 
const authRouter= express.Router(); 

//dummy get and put requests
authRouter.get('/api/signup', async (req, res)=> {
    res.json(`${req.body['name']}, Thank you for connecting`);
})

authRouter.put('/api/signup', async (req, res) =>{
    try {
        //Get the data from a client
        const {name, email, password} = req.body;
    
        //Find any existing user by same email
        //(Email must be unique to the user)
        const existingUser = await User.findOne({email});
        if (!existingUser) {
            return res.status(400).json({msg: "User was nnot found"});
            //Status code 400 is for bad request(client side error)
        }
    
        //Before saving, encode (hash) the password such that 
        //it does not get stolen form our database
        const hashedPassword = await bcrypt.hash(password, 8);

        //Updating data in database
        existingUser['name']=name;
        existingUser['email']=email;
        existingUser['password']=hashedPassword;

        var user = await existingUser.save(); 
        //also saves version no. and a unique id
    
        //Return the data to client side (Success)
        res.json({user}); //default status code is 200 (OK)
        
    } catch (err) {
        //simplifies error handling
        res.status(500).json({error: err.message});
    }
})


//Creating a system for a new user to sign-up
//And post this data to mongodb
authRouter.post('/api/signup', async (req, res)=>{
    
    try {
        //Get the data from a client
        const {name, email, password} = req.body;
    
        //Check any existing user by same email
        //(Email must be unique to the user)
        const existingUser = await User.findOne({email});
        if (existingUser) {
            return res.status(400).json({msg: "User with same email already exists"});
            //Status code 400 is for bad request(client side error)
        }
    
        //Before saving, encode (hash) the password such that 
        //it does not get stolen form our database
        const hashedPassword = await bcrypt.hash(password, 8);

        //Saving data in database
        var user = new User({
            name,
            email,
            password: hashedPassword,
        })
        user = await user.save(); 
        //also saves version no. and a unique id
    
        //Return the data to client side (Success)
        res.json({user}); //default status code is 200 (OK)
        
    } catch (err) {
        //simplifies error handling
        res.status(500).json({error: err.message});
    }
})

// creating a sign-in route
authRouter.post('/api/signin', async (req, res)=>{
    try{
        const {email, password} = req.body;
        
        //check email
        const user = await User.findOne({email});
        if (!user) {
            return res.status(400).json({msg: "User with this email doesn't exist"});
            //Status code 400 is for bad request(client side error)
        }
        //check password
        //use compare function
        const passwordMatch = await bcrypt.compare(password, user.password);
        if(!passwordMatch){
            return res.status(400).json({msg: "Incorrect password"});
            //Status code 400 is for bad request(client side error)
        }

        //generate token for authorization
        const token = jwt.sign({id: user._id}, "secretKey");
        //save the token to our database
        res.json({token, ...user._doc});
        //...here the post request comes in
    }catch(err){
        //simplifies error handling
        res.status(500).json({error: err.message});
    }
})


//token validation api
//this one need not be post but works anyway
authRouter.post('/api/validate', async (req, res)=> {
    try{
        //token is passed thru the header not the body
        const token = req.header('x-auth-token');
        if(!token) return res.json(false);

        const verified= jwt.verify(token, 'secretKey');
        if(!verified) return res.json(false);
        
        const user= await User.findById(verified.id);
        if(!user) return res.json(false);

        return res.json(true);
    }catch(err){
        //simplifies error handling
        res.status(500).json({error: err.message});
    }
})

//get user data from app memory via shared preference
//auth is a middleware which just validates 
// and help store user details
authRouter.get('/', auth, async (req, res)=>{
    try {
        const user = await User.findById(req.user);
        res.json({...user._doc, token: req.token});
    } catch (err) {
        //simplifies error handling
        res.status(500).json({error: err.message});
    }
})

module.exports = authRouter;