import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GoFly'),
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image:
                  AssetImage('assets/goflybg.jpg'), // AppBar background image
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
            Center(
              child: Text(
                'Payment',
                style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
            SizedBox(height: 20),
            buildTextFieldRow('BookingID:', 'Booking ID'),
            SizedBox(height: 10),
            buildTextFieldRow('  User  ID:  ', 'User ID'),
            SizedBox(height: 10),
            buildTextFieldRow('   Amount:  ', 'Amount'),
            SizedBox(height: 20),
            buildPaymentContainer(context),
            SizedBox(height: 20),
            Center(
              child: Text(
                "please click on the 'Confirm' button to initiate the transaction",
                style: TextStyle(color: Colors.pink),
              ),
            ),
            Spacer(),
            buildConfirmButton(context),
          ],
        ),
      ),
    );
  }

  Widget buildTextFieldRow(String label, String placeholder) {
    return Row(
      children: [
        Text(label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            readOnly: true, // To simulate backend population of fields
            decoration: InputDecoration(
              hintText: placeholder,
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
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage('assets/goflybg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset('assets/gpay.jpg', height: 30, width: 30),
              SizedBox(width: 20),
              Text(
                'GPay',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text('UPI ID:',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              SizedBox(width: 10),
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
          SizedBox(height: 10),
          Center(
            child: Text(
              'OR',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white),
            ),
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => QRCodePage()));
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey[500],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            ),
            child: Text(
              'Click here for QR',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildConfirmButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => QRCodePage()));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 30),
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/goflybg.jpg'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
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

class QRCodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          'GoFly',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Text(
                'Payment',
                style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
            ),
            SizedBox(height: 20),
            buildQRContainer(),
            Spacer(),
            Center(
              child: Text(
                "please click on the 'confirm' button to complete the transaction",
                style: TextStyle(color: Colors.pink),
              ),
            ),
            SizedBox(height: 20),
            buildConfirmButton(context),
          ],
        ),
      ),
    );
  }

  Widget buildQRContainer() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage('assets/qr_bg.jpg'), // Add QR background
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Center(
            child: Text(
              'QR Code',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: QrImage(
              data: "https://www.example.com", // Example QR data
              version: QrVersions.auto,
              size: 200.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildConfirmButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Add desired functionality on confirm
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/goflybg.jpg'), // Footer background
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            'CONFIRM',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }

  QrImage({required String data, required version, required double size}) {}
}

class QrVersions {
  static var auto;
}
