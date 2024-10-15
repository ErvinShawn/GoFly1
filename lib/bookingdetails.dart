import 'package:flutter/material.dart';
import 'dart:math'; // For generating random Booking ID
import 'package:cloud_firestore/cloud_firestore.dart';
import 'payment.dart';

class BookingPage extends StatefulWidget {
  final String flightName;
  final String source;
  final String destination;
  final String arrivalTime;
  final String departureTime;
  final int economyPrice;
  final int businessPrice;
  final int firstClassPrice;

  const BookingPage({
    super.key,
    required this.flightName,
    required this.source,
    required this.destination,
    required this.arrivalTime,
    required this.departureTime,
    required this.economyPrice,
    required this.businessPrice,
    required this.firstClassPrice,
  });

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final Random _random = Random();
  String _bookingId = '';
  String? _selectedSeat;
  String? _selectedMeal;
  int _mealCount = 0;
  int _ticketPrice = 0;
  int _mealPrice = 0;
  String? _selectedClass = 'Economy';
  final List<String> _availableSeats = ['1', '2', '3', '4', '5'];

  @override
  void initState() {
    super.initState();
    _bookingId = _generateBookingId();
    //default price
    _ticketPrice = widget.economyPrice;
  }

  String _generateBookingId() {
    return 'GF${_random.nextInt(1000000).toString().padLeft(6, '0')}';
  }

  int _calculateMealPrice() {
    switch (_selectedMeal) {
      case 'Non-Veg Meal':
        _mealPrice = 300;
        break;
      case 'Veg Meal':
        _mealPrice = 200;
        break;
      case 'Vegan Meal':
        _mealPrice = 150;
        break;
      default:
        _mealPrice = 0;
    }
    return _mealPrice * _mealCount;
  }

  void _updateTicketPrice(String? selectedClass) {
    setState(() {
      switch (selectedClass) {
        case 'Business':
          _ticketPrice = widget.businessPrice;
          break;
        case 'First Class':
          _ticketPrice = widget.firstClassPrice;
          break;
        case 'Economy':
        default:
          _ticketPrice = widget.economyPrice;
      }
    });
  }

  int _calculateTotalAmount() {
    return _ticketPrice + _calculateMealPrice();
  }

  Future<void> _saveBooking() async {
    try {
      await FirebaseFirestore.instance.collection('Booking').add({
        'bookingId': _bookingId,
        'flightNumber':
            'flight123', // Replace with the actual flight number if needed
        'flightName': widget.flightName,
        'source': widget.source,
        'destination': widget.destination,
        'departure': widget.departureTime,
        'arrival': widget.arrivalTime,
        'seat': _selectedSeat,
        'meal': _selectedMeal,
        'mealCount': _mealCount,
        'totalAmount': _calculateTotalAmount(),
        'bookingDate': Timestamp.now(),
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving booking: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GoFly ',
          style: TextStyle(fontSize: 24),
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
              const SizedBox(height: 10),
              _buildSectionTitle('Flight Details:'),
              const SizedBox(height: 1),
              _buildFlightDetailsRow('Flight Name', widget.flightName),
              _buildFlightDetailsRow('Source', widget.source),
              _buildFlightDetailsRow('Destination', widget.destination),
              _buildFlightDetailsRow('Departure', widget.departureTime),
              _buildFlightDetailsRow('Arrival', widget.arrivalTime),
              const SizedBox(height: 20),
              _buildSectionTitle('Select Seat Class: '),
              const SizedBox(height: 1),
              _buildDropdown(
                  ['Economy', 'First Class', 'Business'], _selectedClass,
                  (value) {
                setState(() {
                  _selectedClass = value;
                  _updateTicketPrice(value);
                });
              }),
              const SizedBox(height: 1),
              _buildSectionTitle('Select Seat:'),
              const SizedBox(height: 1),
              _buildDropdown(_availableSeats, _selectedSeat, (value) {
                setState(() {
                  _selectedSeat = value;
                });
              }),
              const SizedBox(height: 1),
              _buildSectionTitle('Catering Options:'),
              const SizedBox(height: 1),
              _buildDropdown(
                ['Veg Meal', 'Non-Veg Meal', 'Vegan Meal', 'No Meal'],
                _selectedMeal,
                (value) {
                  setState(() {
                    _selectedMeal = value;
                  });
                },
              ),
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
                    _saveBooking(); // Save the booking first
                    // Navigate to the Payment Page with required details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(
                          bookingId: _bookingId,
                          totalAmount: _calculateTotalAmount(),
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'PROCEED TO PAY',
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

  Widget _buildDropdown(List<String> items, String? selectedItem,
      void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      value: selectedItem,
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildQuantityButton(IconData icon, void Function() onPressed) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
    );
  }

  Widget _buildTotalAmount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Total Amount:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          '₹${_calculateTotalAmount()}',
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
