import 'package:get/get.dart';

import '../firebase/firebase_references.dart';

class CartController extends GetxController {
  //= ---- Total Amount of Cart Products -----
  double get productTotalAmount {
    double totalAmount = 0.0;
    final productRf = cartProductRF.doc(authCurrentUser).collection("products");
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
}
