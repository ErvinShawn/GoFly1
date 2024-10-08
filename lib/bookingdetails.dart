import 'package:flutter/material.dart';
import 'dart:math'; // For generating random Booking ID

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final Random _random = Random();
  String _bookingId = '';
  String? _selectedSeat;
  String? _selectedMeal;
  int _mealCount = 0;
  int _ticketPrice = 5000; // Example price
  int _mealPrice = 200; // Example meal price per item
  final List<String> _availableSeats = [
    '1-E',
    '2-E',
    '3-E',
    '4-E',
    '5-E',
    '6-E',
    '7-E',
    '8-E',
    '9-E',
    '10-E',
    '1-B',
    '2-B',
    '3-B',
    '4-B',
    '5-B',
    '6-B',
    '7-B',
    '8-B',
    '1-F',
    '2-F',
    '3-F',
    '4-F',
    '5-F'
  ];

  @override
  void initState() {
    super.initState();
    _bookingId = _generateBookingId();
  }

  String _generateBookingId() {
    return 'GF${_random.nextInt(1000000).toString().padLeft(6, '0')}';
  }

  int _calculateTotalAmount() {
    return _ticketPrice + (_mealPrice * _mealCount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GoFly ',
          style: TextStyle(fontSize: 24),
          selectionColor: Colors.white,
        ),
        centerTitle: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 135, 0, 176),
                Color.fromARGB(255, 219, 0, 186)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle('Booking ID:'),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    _bookingId,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Flight Details:'),
              const SizedBox(height: 10),
              _buildFlightDetailsRow('Flight Number', 'GF123'),
              _buildFlightDetailsRow('Flight Name', 'GoFly Express'),
              _buildFlightDetailsRow('Source', 'New York (JFK)'),
              _buildFlightDetailsRow('Destination', 'Los Angeles (LAX)'),
              _buildFlightDetailsRow('Departure', '10:00 AM'),
              _buildFlightDetailsRow('Arrival', '1:00 PM'),
              const SizedBox(height: 20),
              _buildSectionTitle('Select Seat:'),
              const SizedBox(height: 10),
              _buildDropdown(_availableSeats, _selectedSeat, (value) {
                setState(() {
                  _selectedSeat = value;
                });
              }),
              const SizedBox(height: 20),
              _buildSectionTitle('Catering Options:'),
              const SizedBox(height: 10),
              _buildDropdown(
                  ['Veg Meal', 'Non-Veg Meal', 'Vegan Meal', 'No Meal'],
                  _selectedMeal, (value) {
                setState(() {
                  _selectedMeal = value;
                });
              }),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Meal Quantity:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      _buildQuantityButton(Icons.remove, () {
                        setState(() {
                          if (_mealCount > 0) _mealCount--;
                        });
                      }),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          _mealCount.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      _buildQuantityButton(Icons.add, () {
                        setState(() {
                          _mealCount++;
                        });
                      }),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildTotalAmount(),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 192, 88, 211),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 15),
                  ),
                  onPressed: () {
                    // Navigate to the Payment Page
                  },
                  child: const Text(
                    'Proceed to Pay',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlightDetailsRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title:',
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
    );
  }

  Widget _buildDropdown(List<String> items, String? selectedItem,
      ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedItem,
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      color: const Color.fromARGB(227, 199, 17, 166),
    );
  }

  Widget _buildTotalAmount() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Amount:',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87),
            ),
            Text(
              '₹${_calculateTotalAmount()}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
