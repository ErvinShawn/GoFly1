import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? currentUser;
  String name = '', email = '', phone = '', dob = '', location = '';

  bool isEditMode = false; // Track whether the user is in edit mode

  // Fetch current user details on initialization
  @override
  void initState() {
    super.initState();
    currentUser = _auth.currentUser;
    if (currentUser != null) {
      setState(() {
        name = currentUser!.displayName ?? '';
        email = currentUser!.email ?? '';
      });
      // Load additional profile details from Firestore if available
      _loadProfileData();
    }
  }

  // Load the additional profile data from Firestore
  Future<void> _loadProfileData() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(currentUser!.uid).get();
      if (doc.exists) {
        setState(() {
          phone = doc['phone'] ?? '';
          dob = doc['dob'] ?? '';
          location = doc['location'] ?? '';
        });
      }
    } catch (e) {
      print('Error loading profile data: $e');
    }
  }

  // Save the profile data to Firestore
  Future<void> _saveProfileData() async {
    try {
      await _firestore.collection('users').doc(currentUser!.uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'dob': dob,
        'location': location,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display name (non-editable)
            TextField(
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: name),
              enabled: false, // Non-editable
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

            // Date of birth (editable in edit mode)
            TextField(
              decoration: const InputDecoration(
                labelText: 'Date of Birth',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: dob),
              enabled: isEditMode, // Editable only in edit mode
              onChanged: (value) {
                dob = value;
              },
            ),
            const SizedBox(height: 16),

            // Location (editable in edit mode)
            TextField(
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: location),
              enabled: isEditMode, // Editable only in edit mode
              onChanged: (value) {
                location = value;
              },
            ),
            const SizedBox(height: 16),

            // Edit or Save button
            isEditMode
                ? ElevatedButton(
                    onPressed: _saveProfileData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                    ),
                    child: Text(
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
                    child: Text(
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
              child: Text(
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
