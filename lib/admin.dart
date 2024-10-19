import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'adminfunctions.dart'; // Your AdminPage

class AdminButton extends StatefulWidget {
  @override
  _AdminButtonState createState() => _AdminButtonState();
}

class _AdminButtonState extends State<AdminButton> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  Future<void> _loginAndCheckAdmin() async {
  setState(() {
    isLoading = true;
    errorMessage = '';
  });

  String email = _emailController.text;
  String password = _passwordController.text;

  try {
    // Check Firestore collection 'users' for matching email and password
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var userDoc = querySnapshot.docs.first.data() as Map<String, dynamic>?;

      // Null safety check for 'userDoc' and 'is_admin'
      if (userDoc != null && userDoc['is_admin'] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()),
        );
      } else {
        setState(() {
          errorMessage = 'Access Denied: Not an Admin';
        });
      }
    } else {
      setState(() {
        errorMessage = 'Invalid Email or Password';
      });
    }
  } catch (e) {
    setState(() {
      errorMessage = 'Error: ${e.toString()}';
    });
  }

  setState(() {
    isLoading = false;
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GoFly'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        flexibleSpace: Image(
          image: AssetImage('assets/goflybg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Admin Login',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _loginAndCheckAdmin,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 50),
                  backgroundColor: Colors.purple,
                ),
                child: isLoading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
