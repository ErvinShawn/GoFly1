import 'package:flutter/material.dart';
import 'package:my_flutter_app/bookingdetails.dart';

class FlightDetailsPage extends StatelessWidget {
  final String flightName;
  final String source;
  final String destination;
  final String arrivalTime;
  final String departureTime;
  final int economyPrice;
  final int businessPrice;
  final int firstClassPrice;
  final int economySeats;
  final int businessSeats;
  final int firstClassSeats;

  const FlightDetailsPage({
    super.key,
    required this.flightName,
    required this.source,
    required this.destination,
    required this.arrivalTime,
    required this.departureTime,
    required this.economyPrice,
    required this.businessPrice,
    required this.firstClassPrice,
    required this.economySeats,
    required this.businessSeats,
    required this.firstClassSeats,
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
            const SizedBox(height: 20),
            buildTicketDetailCard('Airline', flightName),
            buildTicketDetailCard('Source', source),
            buildTicketDetailCard('Destination', destination),
            buildTicketDetailCard('Departure', departureTime),
            buildTicketDetailCard('Arrival', arrivalTime),
            buildTicketDetailCard('Economy Price', '₹$economyPrice'),
            buildTicketDetailCard('Economy Seats', economySeats.toString()),
            buildTicketDetailCard('Business Price', '₹$businessPrice'),
            buildTicketDetailCard('Business Seats', businessSeats.toString()),
            buildTicketDetailCard('First Class Price', '₹$firstClassPrice'),
            buildTicketDetailCard(
                'First Class Seats', firstClassSeats.toString()),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BookingPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTicketDetailCard(String title, String value) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.purple.withOpacity(0.5)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5.0,
              offset: Offset(0, 3), // Shadow position
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
