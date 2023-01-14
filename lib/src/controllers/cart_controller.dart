import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shopsy/src/screens/check%20out/check_out_screen.dart';

import '../firebase/firebase_references.dart';

class CartController extends GetxController {
  final productPrice = 0.0.obs;
  final productQuantity = 0.obs;
  final totalAmount = 0.0.obs;
  List<dynamic> cartDataList = [];

  @override
  void onInit() {
    super.onInit();
    getTotalAmount();
  }

  getTotalAmount() {
    productRf.get().then((snapshot) {
      for (var cartDoc in snapshot.docs) {
        String productId = cartDoc.data()['productId'];
        productQuantity.value = cartDoc.data()['quantity'];
        Map<String, dynamic> cartData = {
          "productId": productId.toString(),
          "Quantity": productQuantity.value,
        };
        cartDataList.add(cartData);
        print("cartDataList------------$cartDataList");

        // productRf.doc(productId).get().then((doc) {
        //   productPrice.value = doc.data()!["price"];
        //   print("Price------------${productPrice.value}");
        // });
      }
    });

    // Calculate total amount for the product
    // totalAmount.value = productPrice.value * productQuantity.value;
  }

  //= ---- Total Amount of Cart Products -----
  double get productTotalAmount {
    double totalAmount = 0.0;

    productRf.get().then((snapshot) {
      for (var doc in snapshot.docs) {
        double price = doc.data()['price'];
        print("----------------$price");
        totalAmount += price;
        print("----------------$totalAmount");
      }
      print('Total price: ${totalAmount.toString()}');
    });
    update();

    return totalAmount;
  }

  cartLength() {
    cartProductRF
        .doc(authCurrentUser)
        .collection("products")
        .get()
        .then((QuerySnapshot snapshot) {
      int length = snapshot.docs.length;
      if (length > 0) {
        Get.to(() => const CheckOutScreen());
      } else {
        Fluttertoast.showToast(
            msg: "Cart is empty", backgroundColor: Colors.red);
      }
    });
  }
}
