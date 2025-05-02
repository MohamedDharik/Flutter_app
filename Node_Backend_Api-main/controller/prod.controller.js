const productmodel = require('../model/prod.model');

const getProducts =  async (req, res) => {
    try {
      const allprod = await productmodel.find({})
      res.status(200).json(allprod)
      
    } catch (error) {
      res.status(500).json({message: error.message})
    }
  };

const getProduct = async (req,res)=>{
  try {
    const {id} = req.params
    const specprod = await productmodel.findById(id)
    res.status(200).json(specprod)
  } catch (error) {
    res.status(500).json({message: error.message})
  }
};

const createProduct = async (req , res) =>{
    try {
      const product = await productmodel.create(req.body);
  
      res.status(200).json(product).send("product has been added successfully!!!!!");
    } catch (error) {
      res.status(500).json({message: error.message})
    }
  };

const updateProduct =  async (req, res) =>{
    try {
      const {id} = req.params
      const prod = await productmodel.findByIdAndUpdate(id, req.body)
      if(!prod){
        res.status(404).json({message: "product is not availabe"})
      }
      const updateprod = await productmodel.findById(id)
      
      res.status(200).json(updateprod).send("Product has been updated sucessfully!!!")
    } catch(error){
      res.status(500).json({message:error.message})  
    }
  };

const deleteProduct = async (req,res)=>{
    try {
      const {id} = req.params
      const deleteprod = await productmodel.findByIdAndDelete(id)
      if(!deleteprod){
        res.status(404).json({message: "Product already has been deleted..!!"})
      }
      
      res.status(200).json({message: "The product is deleted successfully!!...."})
      
    } catch (error) {
      res.status(500).json({message:error.message})
    }
  };

module.exports = {
    getProducts,
    getProduct,
    createProduct,
    updateProduct,
    deleteProduct
}
