import 'package:flutter/material.dart';
import 'package:my_flutter_app/main_page.dart';

class Dropdown extends StatelessWidget {
  const Dropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 150,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/goflybg.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Positioned(
                bottom: 10,
                right: 20,
                child: Text(
                  'GoFly',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Image.asset(
              'assets/aviao.gif',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          CustomImageButton(
            'Return to Home',
            () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MainPage()));
            },
            'assets/goflybg.jpg',
          ),
          CustomImageButton(
            'Flight Status',
            () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FlightStatusPage()));
            },
            'assets/goflybg.jpg', // Button background image URL
          ),
          CustomImageButton(
            'Ticket Details',
            () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const TicketDetailsPage()));
            },
            'assets/goflybg.jpg',
          ),
          CustomImageButton(
            'About Us',
            () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AboutUsPage()));
            },
            'assets/goflybg.jpg',
          ),
        ],
      ),
    );
  }
}

// Custom Image Button Widget with background image
Widget CustomImageButton(String text, Function() onPressed, String imageUrl) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onPressed,
      child: Ink(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageUrl), // Button background image
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ),
  );
}

class FlightStatusPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  FlightStatusPage({super.key});

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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            const Text(
              'Flight Status',
              style: TextStyle(
                  color: Colors.purple,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Input field
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Flight Number/PNR',
              ),
            ),
            const SizedBox(height: 20),
            // Check button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  // Show alert
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Flight Status'),
                        content: Text('Flight status for: ${_controller.text}'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Check'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TicketDetailsPage extends StatelessWidget {
  const TicketDetailsPage({super.key});

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
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            Text(
              'Ticket Details',
              style: TextStyle(
                  color: Colors.purple,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            TicketCard(),
            TicketCard(),
            TicketCard(),
          ],
        )
        // Footer Navigation Bar

        );
  }
}

// Ticket Card Widget with background image
class TicketCard extends StatelessWidget {
  const TicketCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 150,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'assets/goflybg.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Text inside the  card
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Flight Number: 12345',
                            style: TextStyle(color: Colors.white)),
                        Text('Destination: XYZ',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

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
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About us',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'We are GoFly, providing you the best flight booking experience. Our services span across the globe, with seamless travel solutions.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Our goal is to make your travel convenient and affordable.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
