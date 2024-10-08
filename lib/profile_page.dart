import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? currentUser;
  String name = '', email = '', phone = '', dob = '', address = '', age = '';

  bool isEditMode = false; // Track whether the user is in edit mode
  DateTime? selectedDate; // For storing selected date of birth

  // Fetch current user details on initialization
  @override
  void initState() {
    super.initState();
    currentUser = _auth.currentUser;
    if (currentUser != null) {
      setState(() {
        email = currentUser!.email ?? '';
      });
      // Load additional profile details from Firestore if available
      _loadProfileData();
    }
  }

  // Load the additional profile data from Firestore
  Future<void> _loadProfileData() async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(currentUser!.email)
          .get(); // Use email as document ID
      if (doc.exists) {
        setState(() {
          name = doc['name'] ?? '';
          phone = doc['PhNum'] ?? '';
          dob = doc['dob'] ?? '';
          selectedDate = dob.isNotEmpty ? DateTime.parse(dob) : null;
          address = doc['address'] ?? '';
          age = doc['age']?.toString() ?? ''; // Make sure it's a string
        });
      }
    } catch (e) {
      print('Error loading profile data: $e');
    }
  }

  // Save the profile data to Firestore
  Future<void> _saveProfileData() async {
    try {
      await _firestore.collection('users').doc(currentUser!.email).set({
        'name': name,
        'PhNum': phone,
        'dob': dob,
        'address': address,
        'age': int.tryParse(age), // Save age as an integer
        'email': email,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      setState(() {
        isEditMode = false; // Exit edit mode after saving
      });
    } catch (e) {
      print('Error saving profile data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900), // Adjust as necessary
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dob = DateFormat('yyyy-MM-dd').format(picked); // Format the DOB
        _calculateAge(picked); // Calculate age based on selected date
      });
    }
  }

  // Function to calculate age from the date of birth
  void _calculateAge(DateTime dob) {
    DateTime today = DateTime.now();
    int ageCalc = today.year - dob.year;

    // Check if the user hasn't had their birthday this year
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      ageCalc--;
    }

    setState(() {
      age = ageCalc.toString(); // Update the age field
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display name (editable in edit mode)
            TextField(
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: name),
              enabled: isEditMode,
              onChanged: (value) {
                name = value;
              },
            ),
            const SizedBox(height: 16),

            // Display email (non-editable)
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: email),
              enabled: false, // Non-editable
            ),
            const SizedBox(height: 16),

            // Phone number (editable in edit mode)
            TextField(
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: phone),
              enabled: isEditMode, // Editable only in edit mode
              onChanged: (value) {
                phone = value;
              },
            ),
            const SizedBox(height: 16),

            GestureDetector(
              onTap: isEditMode ? () => _selectDate(context) : null,
              child: AbsorbPointer(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: dob),
                  enabled: isEditMode, // Editable only in edit mode
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Address (editable in edit mode)
            TextField(
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: address),
              enabled: isEditMode, // Editable only in edit mode
              onChanged: (value) {
                address = value;
              },
            ),
            const SizedBox(height: 16),

            // Age (non-editable, calculated automatically)
            TextField(
              decoration: const InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: age),
              enabled: false, // Age is non-editable
            ),
            const SizedBox(height: 16),

            // Edit or Save button
            isEditMode
                ? ElevatedButton(
                    onPressed: _saveProfileData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                    ),
                    child: const Text(
                      'Save Profile',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isEditMode = true; // Enter edit mode
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
            const SizedBox(height: 16),

            // Log Out button
            ElevatedButton(
              onPressed: () {
                _auth.signOut();
                Navigator.pushNamed(context, '/entry');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 247, 1, 255),
              ),
              child: const Text(
                'Log Out',
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
