import 'package:flutter/material.dart';
import 'package:my_flutter_app/bookingdetails.dart';

class FlightDetailsPage extends StatelessWidget {
  const FlightDetailsPage({super.key});

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
              image:
                  AssetImage('assets/goflybg.jpg'), // AppBar background image
              fit: BoxFit.cover,
            ),
          ),
        ),
        backgroundColor:
            Colors.transparent, // To make the background image visible
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Back button
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Flight Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ),
            const SizedBox(height: 15),
            buildReadOnlyField('Airline'),
            buildReadOnlyField('Flight number'),
            buildReadOnlyField('Source'),
            buildReadOnlyField('Destination'),
            buildReadOnlyField('dd/mm/yyyy'),
            buildReadOnlyField('Duration'),
            buildReadOnlyField('Economy price'),
            buildReadOnlyField('No of seats'),
            buildReadOnlyField('Business price'),
            buildReadOnlyField('No of seats'),
            buildReadOnlyField('First class price'),
            buildReadOnlyField('No of seats'),
            buildReadOnlyField('Status'),
            const SizedBox(height: 15),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BookingPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReadOnlyField(String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        enabled: false,
        decoration: InputDecoration(
          labelText: placeholder,
          labelStyle: const TextStyle(color: Colors.purple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          filled: true,
          fillColor: Colors.purple[50],
        ),
      ),
    );
  }
}
