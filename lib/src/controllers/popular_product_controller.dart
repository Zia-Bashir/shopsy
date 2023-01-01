import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../firebase/firebase_references.dart';

class PopularProductController extends GetxController {
  final ratingValue = '0'.obs;
  RxInt selectedImage = 0.obs;
  RxInt selectedColor = 0.obs;
  RxBool isFavourite = false.obs;
  RxString productSelectedColor = "".obs;

  RxInt quantity = 1.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  displayImage(int index) {
    selectedImage.value = index;
    update();
  }

  selectColor(int index) {
    selectedColor.value = index;
    update();
  }

  getProductRating(String? proId) async {
    await popularProductsRF.doc(proId).get().then((DocumentSnapshot doc) {
      ratingValue.value = doc['rating'].toString();
      update();
    });
  }

  getProductImage(String? proId) async {
    await popularProductsRF.doc(proId).get().then((DocumentSnapshot doc) {
      ratingValue.value = doc['rating'].toString();
      update();
    });
  }

  //= ---- Add to Favourite -----
  addedToFavourite(
    String productId,
    int productIndex,
  ) {
    return favouriteProductRF
        .doc(authCurrentUser)
        .collection("products")
        .doc(productId)
        .set({
      "uid": authCurrentUser,
      "productId": productId,
      "productIndex": productIndex,
      "isFavourite": true
    });
  }

//= ---- Remove from Favourite -----
  reomoveFromFavourite(String productId) {
    return favouriteProductRF
        .doc(authCurrentUser)
        .collection("products")
        .doc(productId)
        .delete();
  }

//= ---- Add to Cart -----
  addedToCart(
    String productId,
    int productIndex,
    String productColor,
    int quantity,
  ) {
    return cartProductRF
        .doc(authCurrentUser)
        .collection("products")
        .doc(productId)
        .set({
      "uid": authCurrentUser,
      "productId": productId,
      "productIndex": productIndex,
      "productColor": productColor,
      "quantity": quantity,
      "price": 49.99,
      "isCart": true
    });
  }

  //= ---- Remove from Favourite -----
  reomoveFromCart(String productId) {
    return cartProductRF
        .doc(authCurrentUser)
        .collection("products")
        .doc(productId)
        .delete();
  }

  //= ---- Total Amount of Cart Products -----
  double get productTotalAmount {
    double totalAmount = 0;
    final productRf = cartProductRF.doc(authCurrentUser).collection("products");
    productRf.get().then((snapshot) {
      for (var doc in snapshot.docs) {
        double price = doc.data()['price'];
        totalAmount += price;
      }
      print('Total price: ${totalAmount.toString()}');
    });

    return totalAmount;
  }

  void setQuantity(bool isIncrement) {
    if (isIncrement) {
      if (quantity >= 10) {
        quantity.value = 10;
      } else {
        quantity = quantity + 1;
      }
    } else {
      if (quantity <= 1) {
        quantity.value = 1;
      } else {
        quantity = quantity - 1;
      }
    }

    update();
  }

  int get getQuantity {
    return quantity.value;
  }
}
