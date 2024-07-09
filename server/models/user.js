const mongoose = require('mongoose');
const { productSchema } = require('./product');

//create a user model structure with validation
const userSchema = mongoose.Schema({
    name:{
        required: true,
        type:String,
        trim:true
    },
    email:{
        required: true,
        type:String,
        trim:true,
        validate:{
            validator: (value) => {
                //using regex to validate
                const re =   /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
                return value.match(re);
            },
            //alternate
            message: "Please enter a valid email"
        },

    },
    password:{
        required:true,
        type:String,
        validate:{
            validator: (value) => {
                return value.length>=8;
            },
            message: "Password does not contain 8 characters"
        },
    },
    address:{
        type:String,
        default:""
    },
    type:{
        type:String,
        default:"user"
    },
    cart:[
        {
            product: productSchema,
            quantity: {
                type: Number,
                required: true
            }
        }
    ]
});

//create user model by passing the schema
const User = mongoose.model("User", userSchema);

module.exports= User;