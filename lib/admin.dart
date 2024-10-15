import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController _airlineController = TextEditingController();
  final TextEditingController _flightNumberController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _seatsEconomyController = TextEditingController();
  final TextEditingController _seatsBusinessController =
      TextEditingController();
  final TextEditingController _seatsFirstClassController =
      TextEditingController();
  final TextEditingController _pricesEconomyController =
      TextEditingController();
  final TextEditingController _pricesBusinessController =
      TextEditingController();
  final TextEditingController _pricesFirstClassController =
      TextEditingController();
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _flightStatusController = TextEditingController();

  DateTime? _selectedArrivalTime;
  DateTime? _selectedDepartureTime;

  Future<void> showPopup(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> createFlight() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      showPopup(context, 'You need to be signed in to add flights.');
      return;
    }

    if (_airlineController.text.isEmpty ||
        _flightNumberController.text.isEmpty ||
        _durationController.text.isEmpty ||
        _seatsEconomyController.text.isEmpty ||
        _seatsBusinessController.text.isEmpty ||
        _seatsFirstClassController.text.isEmpty ||
        _pricesEconomyController.text.isEmpty ||
        _pricesBusinessController.text.isEmpty ||
        _pricesFirstClassController.text.isEmpty ||
        _sourceController.text.isEmpty ||
        _destinationController.text.isEmpty ||
        _flightStatusController.text.isEmpty ||
        _selectedArrivalTime == null ||
        _selectedDepartureTime == null) {
      showPopup(context, 'Please fill in all fields.');
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('Flights').add({
        'airline': _airlineController.text,
        'flight_number': _flightNumberController.text,
        'duration': _durationController.text,
        'seats': {
          'economy': int.tryParse(_seatsEconomyController.text),
          'business': int.tryParse(_seatsBusinessController.text),
          'first_class': int.tryParse(_seatsFirstClassController.text),
        },
        'prices': {
          'economy': double.tryParse(_pricesEconomyController.text),
          'business': double.tryParse(_pricesBusinessController.text),
          'first_class': double.tryParse(_pricesFirstClassController.text),
        },
        'source': _sourceController.text,
        'destination': _destinationController.text,
        'arrival_time': Timestamp.fromDate(_selectedArrivalTime!),
        'departure_time': Timestamp.fromDate(_selectedDepartureTime!),
        'status': _flightStatusController.text,
      });

      showPopup(context, 'Flight added successfully!');

      // Clear the input fields
      _airlineController.clear();
      _flightNumberController.clear();
      _durationController.clear();
      _seatsEconomyController.clear();
      _seatsBusinessController.clear();
      _seatsFirstClassController.clear();
      _pricesEconomyController.clear();
      _pricesBusinessController.clear();
      _pricesFirstClassController.clear();
      _sourceController.clear();
      _destinationController.clear();
      _flightStatusController.clear();
      setState(() {
        _selectedArrivalTime = null;
        _selectedDepartureTime = null; // Reset the date pickers
      });
    } catch (e) {
      print('Error adding flight: $e');
      showPopup(context, 'Failed to add flight.');
    }
  }

  Future<void> _selectArrivalTime(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedArrivalTime ?? now,
      firstDate: now,
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      TimeOfDay? timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedArrivalTime ?? now),
      );

      if (timePicked != null) {
        setState(() {
          _selectedArrivalTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            timePicked.hour,
            timePicked.minute,
          );
        });
      }
    }
  }

  Future<void> _selectDepartureTime(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDepartureTime ?? now,
      firstDate: now,
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      TimeOfDay? timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDepartureTime ?? now),
      );

      if (timePicked != null) {
        setState(() {
          _selectedDepartureTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            timePicked.hour,
            timePicked.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin - Manage Flights'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _airlineController,
              decoration: const InputDecoration(labelText: 'Airline'),
            ),
            TextField(
              controller: _flightNumberController,
              decoration: const InputDecoration(labelText: 'Flight Number'),
            ),
            TextField(
              controller: _durationController,
              decoration:
                  const InputDecoration(labelText: 'Duration (e.g., 2h 30m)'),
            ),
            TextField(
              controller: _seatsEconomyController,
              decoration: const InputDecoration(labelText: 'Seats (Economy)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _seatsBusinessController,
              decoration: const InputDecoration(labelText: 'Seats (Business)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _seatsFirstClassController,
              decoration:
                  const InputDecoration(labelText: 'Seats (First Class)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _pricesEconomyController,
              decoration: const InputDecoration(labelText: 'Prices (Economy)'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _pricesBusinessController,
              decoration: const InputDecoration(labelText: 'Prices (Business)'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _pricesFirstClassController,
              decoration:
                  const InputDecoration(labelText: 'Prices (First Class)'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _sourceController,
              decoration: const InputDecoration(labelText: 'Source'),
            ),
            TextField(
              controller: _destinationController,
              decoration: const InputDecoration(labelText: 'Destination'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedArrivalTime == null
                      ? 'Select Arrival Time'
                      : 'Arrival Time: ${_selectedArrivalTime!.toLocal()}'
                          .split(' ')[0],
                  style: const TextStyle(fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: () => _selectArrivalTime(context),
                  child: const Text('Pick Arrival Time'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDepartureTime == null
                      ? 'Select Departure Time'
                      : 'Departure Time: ${_selectedDepartureTime!.toLocal()}'
                          .split(' ')[0],
                  style: const TextStyle(fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: () => _selectDepartureTime(context),
                  child: const Text('Pick Departure Time'),
                ),
              ],
            ),
            TextField(
              controller: _flightStatusController,
              decoration: const InputDecoration(labelText: 'Flight Status'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: createFlight,
              child: const Text('Create Flight'),
            ),
            const SizedBox(height: 32),
            // List of flights to update status
            // Your existing StreamBuilder code...
          ],
        ),
      ),
    );
  }
}
