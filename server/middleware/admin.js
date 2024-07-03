const jwt = require('jsonwebtoken');
const User = require('../models/user');


const admin = async (req, res, next)=> {
    try {
        const token=req.header("x-auth-token");
        if(!token) return res.status(401).json({msg:"No auth token, access denied"});

        const verified = jwt.verify(token, 'secretKey');
        if(!verified) return res.status(401).json({msg:"Token verification failed, access denied"});

        const user = await User.findById(verified.id);
        if(user.type=='user' || user.type=='seller'){
            return res.status(401).json({msg:"Admin authorization failed"});
            // 401 status code is for unauthorized access
        }

        req.user = verified.id; 
        req.token=token;
        //storing the user details in the req itself

        next();
    } catch (err) {
        res.status(500).json({error:err.message});
    }
    
}

module.exports=admin;