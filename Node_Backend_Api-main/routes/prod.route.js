const express = require('express')

const {getProduct,getProducts,createProduct,updateProduct,deleteProduct} = require('../controller/prod.controller')


const routes = express.Router();

routes.get('/:id',getProduct)
routes.get('/',getProducts)
routes.post('/', createProduct)
routes.put('/:id',updateProduct)
routes.delete('/:id',deleteProduct)

module.exports = routes