//IMPORT PACKAGES
const express = require('express');
const mongoose = require('mongoose');

//IMPORT FROM FILES
const authRouter= require('./routes/auth');
const adminRouter = require('./routes/admin');

//INITIALIZATION
const PORT = 3000;
const api = express();
const password = encodeURIComponent("<YOUR PASSWORD>");
const connectDB = `<YOUR MONGODB CLUSTER URI>`;

//middleware
api.use(express.json());
api.use(authRouter);
api.use(adminRouter);

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