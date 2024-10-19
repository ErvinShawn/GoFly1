import 'package:flutter/material.dart';
import 'package:my_flutter_app/flightdetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import intl for date formatting

class ResultPage extends StatelessWidget {
  final List<QueryDocumentSnapshot> flights;

  const ResultPage({super.key, required this.flights});

  @override
  Widget build(BuildContext context) {
    print("Number of flights: ${flights.length}"); 
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Search Results',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ),
          Expanded(
            child: flights.isEmpty
                ? const Center(
                    child: Text('No flights found.')) 
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: flights.length,
                    itemBuilder: (context, index) {
                      var flight =
                          flights[index].data() as Map<String, dynamic>;
                      String flightName =
                          flight['flight_name'] ?? 'Unknown Flight';
                      String source = flight['source'] ?? 'Unknown Source';
                      String destination =
                          flight['destination'] ?? 'Unknown Destination';

                      
                      Timestamp arrivalTimestamp = flight['arrival_time'];
                      String arrivalTime = arrivalTimestamp != null
                          ? DateFormat('yyyy-MM-dd – kk:mm')
                              .format(arrivalTimestamp.toDate())
                          : 'Unknown Time';

                      // Get departure time from Firestore
                      Timestamp departureTimestamp = flight['departure_time'];
                      String departureTime = departureTimestamp != null
                          ? DateFormat('yyyy-MM-dd – kk:mm')
                              .format(departureTimestamp.toDate())
                          : 'Unknown Time';

                      // Prices array as integers
                      List<dynamic> prices =
                          flight['Prices'] ?? []; // Corrected to Prices
                      int economyPrice = prices.isNotEmpty
                          ? (prices[0] as num).toInt()
                          : 0; // Changed to int
                      int businessPrice = prices.length > 1
                          ? (prices[1] as num).toInt()
                          : 0; // Changed to int
                      int firstClassPrice = prices.length > 2
                          ? (prices[2] as num).toInt()
                          : 0; // Changed to int

                      // Seats array
                      List<dynamic> seats =
                          flight['Seats'] ?? []; // Corrected to Seats
                      int economySeatCount = seats.isNotEmpty
                          ? (seats[0] as num).toInt()
                          : 0; // Corrected variable name
                      int businessSeatCount =
                          seats.length > 1 ? (seats[1] as num).toInt() : 0;
                      int firstClassSeatCount =
                          seats.length > 2 ? (seats[2] as num).toInt() : 0;

                      return buildResultCard(
                          context,
                          flightName,
                          source,
                          destination,
                          arrivalTime,
                          departureTime,
                          economyPrice,
                          businessPrice,
                          firstClassPrice,
                          economySeatCount,
                          businessSeatCount,
                          firstClassSeatCount);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget buildResultCard(
      BuildContext context,
      String flightName,
      String source,
      String destination,
      String arrivalTime,
      String departureTime,
      int economyPrice,
      int businessPrice,
      int firstClassPrice,
      int economySeatCount,
      int businessSeatCount,
      int firstClassSeatCount) {
    return GestureDetector(
      onTap: () {
       
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlightDetailsPage(
              flightName: flightName,
              source: source,
              destination: destination,
              arrivalTime: arrivalTime,
              departureTime: departureTime,
              economyPrice: economyPrice,
              economySeats: economySeatCount,
              businessPrice: businessPrice,
              businessSeats: businessSeatCount,
              firstClassPrice: firstClassPrice,
              firstClassSeats: firstClassSeatCount,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5, // Adding elevation for shadow effect
        child: Container(
          padding: const EdgeInsets.all(16.0), // Padding for the card
          decoration: BoxDecoration(
            color: Colors.white, // Card background color
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
                color: Colors.purple.withOpacity(0.3)), // Light purple border
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Align to the start
            children: [
              Text(
                'Flight: $flightName',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.flight_takeoff,
                      color: Colors.green), // Departure icon
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      'From: $source',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  // Spacing between From and To
                  const Icon(Icons.flight_land,
                      color: Colors.red), // Arrival icon
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      'To: $destination',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Departure: $departureTime',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    'Arrival: $arrivalTime',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Economy Ticket Price: ₹${economyPrice.toString()}', // Displaying as integer
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
