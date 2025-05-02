const express = require('express')
const mongoose = require('mongoose')

const cors = require('cors');
//dotenv file
const dotenv = require('dotenv')
dotenv.config()

//middleware
const app = express()
app.use(express.json());

app.use(cors());

//routing
const Router = require('./routes/prod.route')
app.use('/api/prod',Router)


app.listen( 3000 ,()=>{
    console.log("server is running 3000");
});



mongoose.connect(process.env.dblink)
 .then(()=>{
      console.log("Database connected to nodejs.");  
})
.catch((err)=>{
  console.log("Database not connected",err);
})