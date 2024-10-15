import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'consts.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'bookingdetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<void> makePayment(
      int totalamount, String bookingId, BuildContext context) async {
    String paymentId = _generatePaymentId();
    try {
      String? paymentIntentClientSecret =
          await _createPaymentIntent(totalamount, "inr");
      if (paymentIntentClientSecret == null) return;
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentClientSecret,
            merchantDisplayName: "GoFly"),
      );
      await _processPayment();
      await _savePaymentDetails(paymentId, totalamount, 'done', bookingId);
      _showSuccessMessage(context);
    } catch (e) {
      print("Error during payment: $e");
      await _savePaymentDetails(paymentId, totalamount, 'Cancelled', bookingId);
    }
  }

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency,
      };

      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": 'application/x-www-form-urlencoded',
          },
        ),
      );

      // Check if response data is valid
      if (response.statusCode == 200) {
        print("Response Data: ${response.data}");
        return response.data['client_secret'];
      } else {
        print("Error: ${response.statusCode} - ${response.statusMessage}");
      }
    } catch (e) {
      print("Exception in _createPaymentIntent: $e");
    }

    return null;
  }

  String _generatePaymentId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return 'PAY${timestamp}';
  }

  Future<void> _savePaymentDetails(
      String paymentId, int amount, String status, String bookingId) async {
    try {
      await FirebaseFirestore.instance.collection('Payments').add({
        'paymentId': paymentId,
        'amount': amount,
        'status': status,
        'timestamp': Timestamp.now(),
        'bookingId': bookingId,
      });
      print('Payment details saved successfully.');
    } catch (e) {
      print('Error saving payment details: $e');
    }
  }

  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      String a = await Stripe.instance.confirmPaymentSheetPayment().toString();
      print(a);
    } catch (e) {
      print(e);
    }
  }

  String _calculateAmount(int amount) {
    final calculatedAmount = amount * 100; // Convert to cents
    return calculatedAmount.toString();
  }

  void _showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Payment sucessful! Redirecting to home..'),
        duration: Duration(seconds: 3)));

    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/main');
    });
  }
}
