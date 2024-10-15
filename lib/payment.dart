import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'stripe_service.dart';

import 'package:my_flutter_app/stripe_service.dart';

class PaymentPage extends StatelessWidget {
  final String bookingId;
  final int totalAmount;

  const PaymentPage({
    super.key,
    required this.bookingId,
    required this.totalAmount,
  });

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
              image: AssetImage('assets/goflybg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            buildTextFieldRow('Booking ID:', bookingId),
            const SizedBox(height: 10),
            buildTextFieldRow('Amount:', '₹$totalAmount'),
            const SizedBox(height: 20),
            buildPaymentMethodsSection(),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Please click on the 'Confirm' button to initiate the transaction",
                style: TextStyle(color: Colors.pink),
              ),
            ),
            const Spacer(),
            buildConfirmButton(context, totalAmount, bookingId),
          ],
        ),
      ),
    );
  }
}

Widget buildTextFieldRow(String label, String value) {
  return Row(
    children: [
      Text(label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(width: 10),
      Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[400]!),
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    ],
  );
}

Widget buildPaymentMethodsSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Choose Payment Method:',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
      buildCardPaymentOption(),
    ],
  );
}

Widget buildCardPaymentOption() {
  return GestureDetector(
    onTap: () {
      // Optionally handle tap
    },
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.credit_card, size: 30, color: Colors.blue[700]),
          const SizedBox(width: 15),
          const Text(
            'Credit / Debit Card',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}

Widget buildConfirmButton(BuildContext context, int amount, String bookingId) {
  return GestureDetector(
    onTap: () async {
      StripeService.instance.makePayment(amount, bookingId, context);
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.purple,
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
