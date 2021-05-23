// ignore: unused_import
import 'dart:collection';
// ignore: unused_import
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/userService.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProductService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference _productReference =
      FirebaseFirestore.instance.collection('products');
  CollectionReference _categoryReference =
      FirebaseFirestore.instance.collection('category');
  CollectionReference _subCategoryReference =
      FirebaseFirestore.instance.collection('subCategory');
  UserService _userService = new UserService();
  List subCategoryList = [];

  Future<List> listSubCategories(String categoryId) async {
    QuerySnapshot subCategoryRef = await _subCategoryReference
        .where('categoryId', isEqualTo: categoryId)
        .get();
    List subCategoryList = [];
    for (int i = 0; i < subCategoryRef.docs.length; i++) {
      Map subCategory = subCategoryRef.docs[i].data();
      String image = await getProductsImage(subCategory['imageId']);
      subCategoryList.add({
        'imageId': image,
        'name': subCategory['name'],
        'id': subCategoryRef.docs[i].id
      });
    }
    print(subCategoryList.toString());
    return subCategoryList;
  }

  Future<String> getProductsImage(String imageId) async {
    final ref = FirebaseStorage.instance.ref().child('$imageId.jpg');
    // print(ref);
    // print("41");
    // String url = await ref.getDownloadURL();
    String url = ref.fullPath;
    // print("Url 43" + url);
    return url;
  }

  Future<List> newItemArrivals() async {
    Random rdn = new Random();
    List<Map<String, dynamic>> itemList = [];

    int randomNumber = 1 + rdn.nextInt(20);
    QuerySnapshot itemsRef = await _productReference
        .orderBy('name')
        .startAt([randomNumber])
        .limit(5)
        .get();
    for (QueryDocumentSnapshot docRef in itemsRef.docs) {
      Map<String, dynamic> items = new Map();
      Map subNewitem = docRef.data();
      // print(subNewitem["imageId"][0]);
      // print("60");
      // String image = await getProductsImage(docRef[0].data()["imageId"][0]);
      String image = await getProductsImage(subNewitem["imageId"][0]);
      // print("63" + image);
      items['image'] = image;
      items['name'] = subNewitem['name'];
      items['productId'] = docRef.id;
      itemList.add(items);
    }
    print("itemList" /*+ itemList.toString()*/);
    return itemList;
  }

  Future<List> featuredItems() async {
    List<Map<String, String>> itemList = [];
    QuerySnapshot itemsRef = await _productReference.limit(15).get();
    for (DocumentSnapshot docRef in itemsRef.docs) {
      Map<String, String> items = new Map();
      // print("73");
      Map subFeaturedItems = docRef.data();
      // print(subFeaturedItems['imageId'][0].runtimeType);
      // print("75");
      String image = await getProductsImage(subFeaturedItems['imageId'][0]);
      // print("77");
      items['image'] = image;
      items['name'] = subFeaturedItems['name'];
      items['price'] = subFeaturedItems['price'].toString();
      items['productId'] = docRef.id;
      // print("82");
      itemList.add(items);
      // print("84");
    }
    print("itemList" /*+ itemList.toString()*/);
    return itemList;
  }

  Future<List> listSubCategoryItems(String subCategoryId) async {
    List<Map<String, String>> itemsList = [];
    QuerySnapshot productRef = await _productReference
        .where("subCategory", isEqualTo: subCategoryId)
        .get();

    for (DocumentSnapshot docRef in productRef.docs) {
      print(docRef);
      // Map<String, String> items = new Map();
      // items['image'] = await getProductsImage(docRef.data['imageId'][0]);
      // items['name'] = docRef.data()['name'];
      // items['price'] = docRef.data()['price'].toString();
      // items['productId'] = docRef.id;
      // itemsList.add(items);
    }
    print("itemList" + itemsList.toString());
    return itemsList;
  }

  Future<List> listCategories() async {
    QuerySnapshot _categoryRef = await _categoryReference.get();
    List<Map<String, String>> categoryList = [];
    // for (DocumentSnapshot dataRef in _categoryRef.docs) {
    //   Map<String, String> category = new Map();
    //   print(dataRef[0].data()['name'] + " 107");
    //   category['name'] = dataRef[0].data()['name'];
    //   category['image'] = dataRef[0].data()['image'];
    //   category['id'] = dataRef.id;
    //   print("Category at 111 " + category.toString());
    //   categoryList.add(category);
    // }
    // final allData = _categoryRef.docs.map((doc) => doc.data()).toList();
    // print("130");
    for (DocumentSnapshot dataRef in _categoryRef.docs) {
      Map<String, String> category = new Map();
      Map subFeaturedItems = dataRef.data();
      category['name'] = subFeaturedItems['name'];
      category['image'] = subFeaturedItems['image'];
      category['id'] = dataRef.id;
      categoryList.add(category);
    }
    print("categoryList 137" /*+ categoryList.toString()*/);
    return categoryList;
  }

  // ignore: missing_return
  Future<String> addItemToWishlist(String productId) async {
    String msg;
    String uid = await _userService.getUserId();
    List<dynamic> wishlist = <dynamic>[];
    QuerySnapshot userRef = await _firestore
        .collection('users')
        .where('userId', isEqualTo: uid)
        .get();
    Map userData = userRef.docs[0].data();
    String documentId = userRef.docs[0].id;
    if (userData.containsKey('wishlist')) {
      wishlist = userData['wishlist'];
      if (wishlist.indexOf(productId) == -1) {
        wishlist.add(productId);
      } else {
        msg = 'Product existed in Wishlist';
        print("msg" + msg.toString());
        return msg;
      }
    } else {
      wishlist.add(productId);
    }
    await _firestore
        .collection('users')
        .doc(documentId)
        .update({'wishlist': wishlist}).then((value) {
      msg = 'Product added to wishlist';
      print("msg" + msg.toString());
      return msg;
    });
  }

  Future<Map> particularItem(String productId) async {
    DocumentSnapshot prodRef = await _productReference.doc(productId).get();
    Map<String, dynamic> itemDetail = new Map();
    // print("178");
    Map subitemDetail = prodRef.data();
    // print(subitemDetail);
    // itemDetail['image'] =
    //     await getProductsImage(prodRef[0].data()['imageId'][0]);
    itemDetail['image'] = await getProductsImage(subitemDetail['imageId'][0]);
    // print("181");
    // itemDetail['color'] = prodRef[0].data()['color'];
    // itemDetail['size'] = prodRef[0].data()['size'];
    // itemDetail['price'] = prodRef[0].data()['price'];
    // itemDetail['name'] = prodRef[0].data()['name'];
    itemDetail['color'] = subitemDetail['color'];
    itemDetail['size'] = subitemDetail['size'];
    itemDetail['price'] = subitemDetail['price'];
    itemDetail['name'] = subitemDetail['name'];
    itemDetail['productId'] = productId;
    print("itemDetail" /* + itemDetail.toString()*/);
    return itemDetail;
  }
}

class NewArrival {
  final String name;
  final String image;

  NewArrival({this.name, this.image});
}
