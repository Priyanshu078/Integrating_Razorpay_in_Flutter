import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

void main() {
  runApp(MyApp());
}

  class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Razorpay',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Integrating Razorpay in Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, @required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _amountController = new TextEditingController();
  Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = new Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _paymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _paymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _externalWalletPayment);
  }

  Future<dynamic> _paymentSuccess(PaymentSuccessResponse response) {
    return showDialog(context: context, builder: (context) => dialog("Payment Successful", " Payment Id: ${response.paymentId}" ));
  }

  Future<dynamic> _paymentError(PaymentFailureResponse response) {
    return showDialog(context: context, builder: (context) => dialog("Error Occurred", " Error Code: ${response.code}  Payment Id: ${response.message}" ));
  }

  Future<dynamic> _externalWalletPayment(ExternalWalletResponse response) {
    return showDialog(context: context, builder: (context) => dialog("External Wallet Used", "Wallet Name: ${response.walletName}"));
  }

  Widget dialog(String title, String content){
    return AlertDialog(
      title: Flexible(child: Text(title)),
      content: Flexible(child: Text(content)),
    );
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  void initiateRazorpay() async{
    Map<String, dynamic> options = {
      'key': 'Your Key Id',
      'amount': int.parse(_amountController.text) * 100,
      'name': 'Buy T shirt',
      'description': 'Shopping',
      'prefill': {'contact': '9898989898', 'email': 'priyanshu@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    try{
      _razorpay.open(options);
    }
    catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                    hintText: "Amount",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              MaterialButton(
                height: 50,
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () {
                  initiateRazorpay();
                },
                child: Text(
                  "PAY",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
              ),
            ],
          ),
        ));
  }
}
