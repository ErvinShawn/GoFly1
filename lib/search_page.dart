import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'result_page.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController sourceController = TextEditingController();
    final TextEditingController destinationController = TextEditingController();
    final TextEditingController dateController = TextEditingController();

    Future<void> selectDate(BuildContext context) async {
      DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
      );

      if (selectedDate != null) {
        String formattedDate =
            "${selectedDate.toLocal()}".split(' ')[0]; // YYYY-MM-DD format
        dateController.text =
            formattedDate; // Set the selected date in the text field
      }
    }

    // Function to show dialog popups
    Future<void> showPopup(BuildContext context, String message) async {
      return showDialog<void>(
        context: context,
        barrierDismissible:
            false, // Dialog cannot be dismissed by tapping outside
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Search Result'),
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
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }

    void searchFlights() async {
      // Check if the user is signed in
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        showPopup(context, 'You need to be signed in to search for flights.');
        return;
      }

      // Fetch data from Firestore
      String source = sourceController.text;
      String destination = destinationController.text;
      String date = dateController.text;

      if (source.isEmpty || destination.isEmpty || date.isEmpty) {
        showPopup(context, 'Please fill in all fields.');
        return;
      }

      // Parse the selected date
      DateTime selectedDate = DateTime.parse(date);
      DateTime startOfDay =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      DateTime endOfDay = startOfDay.add(const Duration(days: 1));

      try {
        // Query Firestore with consistent collection name 'Flights'
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Flights') // Use 'Flights' collection name here
            .where('source', isEqualTo: source)
            .where('destination', isEqualTo: destination)
            .where('arrival_time', isGreaterThanOrEqualTo: startOfDay)
            .where('arrival_time', isLessThan: endOfDay)
            .get();

        // Check if documents are retrieved
        if (querySnapshot.docs.isEmpty) {
          showPopup(context, 'No flights found for the selected criteria.');
        } else {
          showPopup(context, 'Flight found!');
          // Pass the results to the ResultPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultPage(flights: querySnapshot.docs),
            ),
          );
        }
      } catch (e) {
        // Handle any errors
        print('Error fetching flights: $e');
        showPopup(context, 'Failed to fetch flights.');
      }
    }

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
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: sourceController,
              decoration: const InputDecoration(
                labelText: 'From (Source)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: destinationController,
              decoration: const InputDecoration(
                labelText: 'To (Destination)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: () {
                selectDate(context);
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: searchFlights,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
              child: const Text(
                'Search',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
