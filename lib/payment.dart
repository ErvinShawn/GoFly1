import 'package:flutter/material.dart';
import 'package:upi_india/upi_india.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  UpiIndia _upiIndia = UpiIndia();
  UpiResponse? _transaction;

  String bookingId = '1000';
  String userId = '100';
  double amount = 1.00; // Default payment amount

  Future<void> initiateTransaction() async {
    UpiResponse response = await _upiIndia.startTransaction(
      app: UpiApp.googlePay, // Specify Google Pay as the UPI app
      receiverUpiId: 'ervindacosta17@oksbi', // Example UPI ID (replace with real one)
      receiverName: 'Ervin Da Costa', // Example merchant name
      transactionRefId: 'TID123456789', // Example transaction reference ID
      transactionNote: 'Payment for booking', // Description of payment
      amount: amount, // Amount to be paid
    );

    setState(() {
      _transaction = response;
    });
  }

  Widget displayTransactionStatus() {
    if (_transaction == null) {
      return const Text("Transaction Status: Not Initiated");
    }
    switch (_transaction!.status) {
      case UpiPaymentStatus.SUCCESS:
        return const Text("Transaction Status: Success");
      case UpiPaymentStatus.FAILURE:
        return const Text("Transaction Status: Failure");
      case UpiPaymentStatus.SUBMITTED:
        return const Text("Transaction Status: Submitted");
      default:
        return const Text("Transaction Status: Unknown");
    }
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
            const SizedBox(height: 20),
            buildTextFieldRow('BookingID:', bookingId),
            const SizedBox(height: 10),
            buildTextFieldRow('  User  ID:  ', userId),
            const SizedBox(height: 10),
            buildTextFieldRow('   Amount:  ', '₹$amount'),
            const SizedBox(height: 20),
            buildPaymentContainer(context),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "please click on the 'Confirm' button to initiate the transaction",
                style: TextStyle(color: Colors.pink),
              ),
            ),
            const SizedBox(height: 20),
            displayTransactionStatus(),
            const Spacer(),
            buildConfirmButton(context),
          ],
        ),
      ),
    );
  }

  Widget buildTextFieldRow(String label, String value) {
    return Row(
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            readOnly: true,
            decoration: InputDecoration(
              hintText: value,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
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
          const SizedBox(height: 10),
          /*TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const QRCodePage()));
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey[500],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            ),
            child: const Text(
              'Click here for QR',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),*/
        ],
      ),
    );
  }

  


  Widget buildConfirmButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        initiateTransaction(); // Initiating UPI transaction on Confirm button click
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
