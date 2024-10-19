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

  DateTime? departureDateTime;
  DateTime? arrivalDateTime;

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
            buildDateTimePicker('Select Departure Time', (selectedDateTime) {
              setState(() {
                departureDateTime = selectedDateTime;
              });
            }, departureDateTime),
            buildDateTimePicker('Select Arrival Time', (selectedDateTime) {
              setState(() {
                arrivalDateTime = selectedDateTime;
              });
            }, arrivalDateTime),
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
                minimumSize: Size(
                    200, 50), // Match the button dimensions from the design
              ),
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveFlightDetails(BuildContext context) async {
    if (departureDateTime == null || arrivalDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select both departure and arrival times')),
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
        'departure_time': Timestamp.fromDate(departureDateTime!),
        'arrival_time': Timestamp.fromDate(arrivalDateTime!),
        'prices': [
          int.parse(economyPriceController.text), // Economy
          int.parse(businessPriceController.text), // Business
          int.parse(firstClassPriceController.text) // First Class
        ],
        'seats': [
          int.parse(seatsEconomyController.text), // Economy
          int.parse(seatsBusinessController.text), // Business
          int.parse(seatsFirstClassController.text) // First Class
        ],
        'status': flightStatus,
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

  Widget buildDateTimePicker(String label,
      Function(DateTime) onDateTimeSelected, DateTime? selectedDateTime) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(selectedDateTime != null
            ? DateFormat('dd/MM/yyyy HH:mm').format(selectedDateTime)
            : label),
        trailing: Icon(Icons.calendar_today),
        onTap: () async {
          DateTime? pickedDate = await pickDate(context);
          if (pickedDate == null) return;

          TimeOfDay? pickedTime = await pickTime(context);
          if (pickedTime == null) return;

          DateTime combinedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          onDateTimeSelected(combinedDateTime);
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

  Future<TimeOfDay?> pickTime(BuildContext context) async {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }
}
