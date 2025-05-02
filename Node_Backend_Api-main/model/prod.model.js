const { default: mongoose } = require("mongoose");

const prodschema = mongoose.Schema(
    {
        title: {
            type : String,
            required: [ true,"enter a valid product name:"] ,
            
        },
        description: {
            type : String,
            required : false
        },
        price:{
            type : String,
            required : true,
            default :0
        },
        Quantity:{
            type: String,
            required: false,
            default :0
        }
    },
    {
    Timestamp: true
    }
)

const productmodel = mongoose.model("products",prodschema);
module.exports = productmodel;
