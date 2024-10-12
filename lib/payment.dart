import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Razorpay _razorpay;
  String _transaction = '';

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear(); // Removing listeners on dispose
  }

  // Open Razorpay checkout
  void openCheckout() {
    var options = {
      'key': 'YOUR_RAZORPAY_API_KEY', // Replace with your Razorpay key
      'amount': 100, // Amount in paise (50000 paise = ₹500)
      'name': 'GoFly',
      'description': 'Flight Booking Payment',
      'prefill': {
        'contact': '1234567890',
        'email': 'test@razorpay.com',
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    
      _razorpay.open(options);
    
  }

  // Payment Success handler
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      _transaction = 'Payment Successful: ${response.paymentId}';
    });
    //print('Payment Successful: ${response.paymentId}');
  }

  // Payment Error handler
  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      _transaction = 'Payment Failed: ${response.code} - ${response.message}';
    });
    //print('Payment Failed: ${response.code} - ${response.message}');
  }

  // External Wallet handler
  void _handleExternalWallet(ExternalWalletResponse response) {
    setState(() {
      _transaction = 'External Wallet Selected: ${response.walletName}';
    });
    //print('External Wallet Selected: ${response.walletName}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GoFly'),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/goflybg.jpg'), // AppBar background image
              fit: BoxFit.cover,
            ),
          ),
        ),
        backgroundColor:
            Colors.transparent, // To make the background image visible
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Center(
              child: Text(
                'Payment',
                style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
            buildPaymentContainer(context),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Please click on the 'Confirm' button to initiate the transaction",
                style: TextStyle(color: Colors.pink),
              ),
            ),
            const SizedBox(height: 20),
            const Spacer(),
            buildConfirmButton(context),
            const SizedBox(height: 20),
            if (_transaction.isNotEmpty)
              Text(
                _transaction,
                style: const TextStyle(
                    color: Colors.green, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage('assets/goflybg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset('assets/gpay.jpg', height: 30, width: 30),
              const SizedBox(width: 20),
              const Text(
                'GPay',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('UPI ID:',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'UPI ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'QR',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildConfirmButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        openCheckout(); // Initiate transaction on Confirm button click
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30),
        width: double.infinity,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/goflybg.jpg'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text(
            'CONFIRM',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
