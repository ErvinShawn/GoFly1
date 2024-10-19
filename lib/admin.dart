import 'package:flutter/material.dart';
import 'adminfunctions.dart';

class AdminButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GoFly'),
        backgroundColor: Colors.transparent,
        flexibleSpace: Image(
          image: AssetImage('assets/goflybg.jpg'),
          fit: BoxFit.cover,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'UPDATE',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50),
                backgroundColor: Colors.purple,
              ),
              child: const Text(
                'Flight Status',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'UPLOAD',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/flights');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50),
                backgroundColor: Colors.purple,
              ),
              child: const Text(
                'Flights',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/WelcomePage');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50),
                backgroundColor: Colors.purple,
              ),
              child: const Text(
                'Log Out',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
