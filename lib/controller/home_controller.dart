import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project1/model/product/product.dart';

class HomeController extends GetxController{

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference productiveCollection;

  TextEditingController productNameCtrl=TextEditingController();
  TextEditingController productDescriptionCtrl=TextEditingController();
  TextEditingController productImgCtrl=TextEditingController();
  TextEditingController productPriceCtrl=TextEditingController();
  String category='general';
  String brand='unbranded';
  bool offer=false;

  List<Product> products=[];


  @override
  void onInit() async{
    productiveCollection=firestore.collection('products');
    await fetchProducts();
    super.onInit();
  }
  addProduct(){
    try {
      DocumentReference doc=productiveCollection.doc();
      Product product=Product(
            id: doc.id,
            name: productNameCtrl.text,
            category: category,
            description: productDescriptionCtrl.text,
            price:double.tryParse(productPriceCtrl.text) ,
            brand: brand,
            image: productImgCtrl.text,
            offer: offer,
          );
      final productJson=product.toJson();
      doc.set(productJson);
      Get.snackbar('Success', 'Product Added Successfully',colorText: Colors.green);
      setValuesDefault();
    } catch (e) {
      Get.snackbar('Error', e.toString(),colorText: Colors.red);
      print(e);
    }
  }

  fetchProducts() async {
    try {
      QuerySnapshot productSnapshot = await productiveCollection.get();
      final List<Product> retrievedProducts = productSnapshot.docs.map(
              (doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      products.clear();
      products.assignAll(retrievedProducts);
      Get.snackbar("Success", "Product fetch successfully",colorText: Colors.green);
    }catch(e){
      Get.snackbar("Error",e.toString(),colorText: Colors.red);
      print(e);
    }finally{
      update();
    }
  }

  deleteProduct(String id) async{
    try {
      await productiveCollection.doc(id).delete();
      fetchProducts();
    }catch(e){
      Get.snackbar("Error",e.toString(),colorText: Colors.red);
      print(e);
    }
  }

    setValuesDefault(){
    productNameCtrl.clear();
    productDescriptionCtrl.clear();
    productImgCtrl.clear();
    productPriceCtrl.clear();
    category='general';
    brand='unbranded';
    offer=false;
    update();
    }

}