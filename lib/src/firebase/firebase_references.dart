import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

final authCurrentUser = auth.currentUser!.uid;
final userRF = firestore.collection("UserData");
final popularProductsRF = firestore.collection("PopularProducts");
final favouriteProductRF = firestore.collection("FavouriteProducts");
final cartProductRF = firestore.collection("CartProducts");
