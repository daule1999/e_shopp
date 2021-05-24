import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './pages/signup.dart';
import './pages/login.dart';
import './pages/start.dart';
import './pages/home.dart';
import './components/shop.dart';
import './pages/products/items.dart';
import './pages/products/subCategory.dart';
import './pages/shoppingBag.dart';
import './pages/checkout/addCreditCard.dart';
import './pages/checkout/paymentMethod.dart';
import './pages/checkout/shippingAddress.dart';
import './pages/checkout/shippingMethod.dart';
import './pages/products/particularItem.dart';
import './pages/checkout/placeOrder.dart';
import './pages/profile/userProfile.dart';
import './pages/profile/editProfile.dart';
import './pages/profile/setting.dart';
import './pages/profile/contactUs.dart';
import './pages/products/wishlist.dart';
import './components/orders/orderHistory.dart';
import './pages/onBoardingScreen/onboardingScreen.dart';
import './pages/adminPanel.dart';
import "./components/successPage.dart";

bool firstTime;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  firstTime = (prefs.getBool('initScreen') ?? false);
  if (!firstTime) {
    prefs.setBool('initScreen', true);
  }
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: firstTime ? '/' : '/onBoarding',
      routes: {
        '/': (context) => Start(),
        '/login': (context) => Login(),
        '/signup': (context) => SignUp(),
        '/home': (context) => Home(),
        '/shop': (context) => Shop(),
        '/subCategory': (context) => SubCategory(),
        '/items': (context) => Items(),
        '/particularItem': (context) => ParticularItem(),
        '/bag': (context) => ShoppingBag(),
        '/wishlist': (context) => WishList(),
        '/checkout/addCreditCard': (context) => AddCreditCard(),
        '/checkout/address': (context) => ShippingAddress(),
        '/checkout/shippingMethod': (context) => ShippingMethod(),
        '/checkout/paymentMethod': (context) => PaymentMethod(),
        '/checkout/placeOrder': (context) => PlaceOrder(),
        '/profile': (context) => UserProfile(),
        '/profile/settings': (context) => ProfileSetting(),
        '/profile/edit': (context) => EditProfile(),
        '/profile/contactUs': (context) => ContactUs(),
        '/placedOrder': (context) => OrderHistory(),
        "/onBoarding": (context) => OnBoardingScreen(),
        "/admin": (context) => AdminPanel(),
        "/success": (context) => SuccesPage()
      },
      theme: ThemeData(
          bottomSheetTheme:
              BottomSheetThemeData(backgroundColor: Colors.white)),
    );
  }
}
