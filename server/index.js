//IMPORT PACKAGES
const express = require('express');
const mongoose = require('mongoose');

//IMPORT FROM FILES
const authRouter= require('./routes/auth');

//INITIALIZATION
const PORT = 3000;
const api = express();
const password = encodeURIComponent("MongoDB#01");
const connectDB = `mongodb+srv://sagnik:${password}@cluster0.hck2gqj.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0`;

//middleware
api.use(express.json());
api.use(authRouter);

//Connections
mongoose.connect(connectDB).then(() =>{ 
    //this is a promise object..similar to future in dart
    console.log("Connection successful");
}).catch((e) => {
    console.log("Error: ", e);
});

//Listen
api.listen(PORT, "0.0.0.0", () => {
    console.log("hello");
    console.log(`listening to ${PORT}`);
})