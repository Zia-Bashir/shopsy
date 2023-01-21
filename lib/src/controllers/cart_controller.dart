import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../firebase/firebase_references.dart';

class CartController extends GetxController {
  final productPrice = 0.0.obs;
  final productQuantity = 0.obs;

  //= ---- Remove from Cart -----
  reomoveFromCart(String productId) {
    return cartProductRF
        .doc(authCurrentUser)
        .collection("products")
        .doc(productId)
        .delete();
  }

  //= ---- Stream and Updated the Latest Price of Carted Products -----
  updateCartProductPrice() {
    cartProductCollectionRF.get().then((snapshot) {
      for (var i = 0; i < snapshot.docs.length; i++) {
        String productId = snapshot.docs[i]['productId'];
        popularProductsRF.doc(productId).get().then((DocumentSnapshot doc) {
          productPrice.value = doc['price'];
          cartProductCollectionRF.doc(productId).update({
            "price": productPrice.value,
          });
        });
      }
    });
  }

  //= ---- Total Amount of Cart Products -----
  Future<double> get productTotalAmount async {
    RxDouble totalAmount = 0.0.obs;
    await cartProductCollectionRF.get().then((snapshot) {
      for (var i = 0; i < snapshot.docs.length; i++) {
        double price = snapshot.docs[i]['price'] * snapshot.docs[i]['quantity'];
        print("----------------$price");
        totalAmount.value += price;
      }
      print('Total price: ${totalAmount.toString()}');
    });

    return (totalAmount.value * 100.round() / 100);
  }

  //= ---- Total Amount of Cart Products -----
  // double get productTotalAmount {
  //   RxDouble totalAmount = 0.0.obs;
  //   cartProductCollectionRF.get().then((snapshot) {
  //     for (var i = 0; i < snapshot.docs.length; i++) {
  //       double price = snapshot.docs[i]['price'] * snapshot.docs[i]['quantity'];
  //       print("----------------$price");
  //       totalAmount.value += price;
  //     }
  //     print('Total price: ${totalAmount.toString()}');
  //   });

  //   return totalAmount.value;
  // }

  //= ---- Check  Cart Length for Check Out -----
  cartLength() {
    cartProductRF
        .doc(authCurrentUser)
        .collection("products")
        .get()
        .then((QuerySnapshot snapshot) {
      int length = snapshot.docs.length;
      if (length > 0) {
        //* --- Cart Lenght greater then 0 than go for Checkout
        Get.toNamed("/checkout");
      } else {
        Fluttertoast.showToast(
            msg: "Cart is empty", backgroundColor: Colors.red);
      }
    });
  }
}
