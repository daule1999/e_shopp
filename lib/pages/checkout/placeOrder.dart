import '../../services/userService.dart';
import 'package:flutter/material.dart';
import "../../components/loader.dart";
import '../../components/checkout/checkoutAppBar.dart';
import '../../services/checkoutService.dart';
import '../../components/modals/internetConnection.dart';

class PlaceOrder extends StatefulWidget {
  @override
  _PlaceOrderState createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  final GlobalKey<ScaffoldState> _orderScaffoldKey =
      new GlobalKey<ScaffoldState>();
  final GlobalKey<State> keyLoader = new GlobalKey<State>();
  void thirdFunction() {}
  Map<String, dynamic> orderDetails;
  CheckoutService _checkoutService = new CheckoutService();
  UserService _userService = new UserService();

  setOrderData() {
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    setState(() {
      orderDetails = args;
    });
  }

  void showInSnackBar(String msg, Color color) {
    // ignore: deprecated_member_use
    _orderScaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: new Text(msg),
        action: SnackBarAction(
          label: 'Close',
          textColor: Colors.white,
          onPressed: () {
            // ignore: deprecated_member_use
            _orderScaffoldKey.currentState.removeCurrentSnackBar();
          },
        ),
      ),
    );
  }

  placeNewOrder() async {
    bool connectionStatus = await _userService.checkInternetConnectivity();

    if (connectionStatus) {
      Loader.showLoadingScreen(context, keyLoader);
      await _checkoutService.placeNewOrder(orderDetails);
      Navigator.pushReplacementNamed(context, '/success');
    } else {
      internetConnectionDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    setOrderData();
    return Scaffold(
      appBar: CheckoutAppBar('Shopping Bag', 'Place Order', this.thirdFunction),
      body: Container(
        decoration: BoxDecoration(color: Color(0xffF4F4F4)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Column(
            children: <Widget>[
              Text(
                'Check out',
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0),
              ),
              SizedBox(height: 30.0),
              Card(
                color: Colors.white,
                shape:
                    ContinuousRectangleBorder(borderRadius: BorderRadius.zero),
                borderOnForeground: true,
                elevation: 0,
                child: ListTile(
                  title: Text('Payment'),
                  trailing: Text('Cash'),
                ),
              ),
              Card(
                color: Colors.white,
                shape:
                    ContinuousRectangleBorder(borderRadius: BorderRadius.zero),
                borderOnForeground: true,
                elevation: 0,
                child: ListTile(
                  title: Text('Shipping'),
                  trailing: Text(orderDetails['shippingMethod']),
                ),
              ),
              Card(
                color: Colors.white,
                shape:
                    ContinuousRectangleBorder(borderRadius: BorderRadius.zero),
                borderOnForeground: true,
                elevation: 0,
                child: ListTile(
                  title: Text('Total'),
                  trailing: Text('\u{20B9} ${orderDetails['price']}.00'),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width / 1.5,
                    height: 50.0,
                    // ignore: deprecated_member_use
                    child: FlatButton(
                        onPressed: () {
                          placeNewOrder();
                        },
                        child: const Text('Place order',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0)),
                        color: Color(0xff616161),
                        textColor: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
