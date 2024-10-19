import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For date formatting

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController airlineController = TextEditingController();
  final TextEditingController flightNumberController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController economyPriceController = TextEditingController();
  final TextEditingController businessPriceController = TextEditingController();
  final TextEditingController firstClassPriceController =
      TextEditingController();
  final TextEditingController seatsEconomyController = TextEditingController();
  final TextEditingController seatsBusinessController = TextEditingController();
  final TextEditingController seatsFirstClassController =
      TextEditingController();
  final TextEditingController statusController = TextEditingController();

  DateTime? departureDate;
  DateTime? arrivalDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flight Details'),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildTextField('Airline', airlineController),
            buildTextField('Flight number', flightNumberController),
            buildTextField('Source', sourceController),
            buildTextField('Destination', destinationController),
            buildDatePicker('Select Departure Date', (selectedDate) {
              setState(() {
                departureDate = selectedDate;
              });
            }, departureDate),
            buildDatePicker('Select Arrival Date', (selectedDate) {
              setState(() {
                arrivalDate = selectedDate;
              });
            }, arrivalDate),
            buildTextField('Duration', durationController),
            buildTextField('Economy price', economyPriceController),
            buildTextField('No of seats (Economy)', seatsEconomyController),
            buildTextField('Business price', businessPriceController),
            buildTextField('No of seats (Business)', seatsBusinessController),
            buildTextField('First class price', firstClassPriceController),
            buildTextField(
                'No of seats (First Class)', seatsFirstClassController),
            buildTextField('Status (true/false)', statusController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await saveFlightDetails(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                minimumSize: Size(200, 50),
              ),
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveFlightDetails(BuildContext context) async {
    if (departureDate == null || arrivalDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select both departure and arrival dates')),
      );
      return;
    }

    try {
      // Parse status as boolean
      bool flightStatus = statusController.text.toLowerCase() == 'true';

      // Prepare the data to be saved to Firestore
      Map<String, dynamic> flightData = {
        'flight_name': airlineController.text,
        'flight_number': flightNumberController.text,
        'source': sourceController.text,
        'destination': destinationController.text,
        'departure_time': Timestamp.fromDate(departureDate!),
        'arrival_time': Timestamp.fromDate(arrivalDate!),
        'Prices': [
          int.parse(economyPriceController.text), // Economy
          int.parse(businessPriceController.text), // Business
          int.parse(firstClassPriceController.text) // First Class
        ],
        'Seats': [
          int.parse(seatsEconomyController.text), // Economy
          int.parse(seatsBusinessController.text), // Business
          int.parse(seatsFirstClassController.text) // First Class
        ],
        'Status': flightStatus,
      };

      // Save to Firestore
      await FirebaseFirestore.instance.collection('Flights').add(flightData);

      // Show a success message and navigate back
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Flight added successfully!')));
      Navigator.pop(context);
    } catch (e) {
      // Show an error message in case of failure
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to add flight: $e')));
    }
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildDatePicker(String label, Function(DateTime) onDateSelected,
      DateTime? selectedDate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(selectedDate != null
            ? DateFormat('dd/MM/yyyy').format(selectedDate)
            : label),
        trailing: Icon(Icons.calendar_today),
        onTap: () async {
          DateTime? pickedDate = await pickDate(context);
          if (pickedDate != null) {
            onDateSelected(pickedDate);
          }
        },
      ),
    );
  }

  Future<DateTime?> pickDate(BuildContext context) async {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
  }
}
