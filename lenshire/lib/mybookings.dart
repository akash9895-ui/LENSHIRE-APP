import 'package:flutter/material.dart';
import 'package:lenshire/payment.dart';
import 'package:lenshire/rating.dart';

class MyBookingsPage extends StatelessWidget {
  MyBookingsPage({super.key});

  // Mock data for package bookings
  final List<Map<String, dynamic>> packageBookings = [
    {
      'package_name': 'Premium Wedding Package',
      'fordate': '2025-06-15',
      'location': 'Grand Hotel, New York',
      'details': 'Full day coverage with album',
      'amount': '\$1200',
      'status': 1, // 0=Pending, 1=Booked, 2=Rejected, 3=Paid
    },
    {
      'package_name': 'Portrait Session',
      'fordate': '2025-07-20',
      'location': 'Central Park',
      'details': '1 hour outdoor session',
      'amount': '\$250',
      'status': 3,
    },
  ];

  // Mock data for custom bookings
  final List<Map<String, dynamic>> customBookings = [
    {
      'photographer_name': 'Sarah Johnson',
      'service_type': 'Commercial Shoot',
      'event_date': '2025-08-10',
      'location': 'Office Building',
      'details': 'Product photography for catalog',
      'budget': '\$800',
      'status': 1, // 0=Pending, 1=Booked, 2=Rejected, 3=Paid Advance
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'My Bookings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5a67d8),
              ),
            ),
            const SizedBox(height: 30),

            // Package Bookings Section
            const Text(
              'Package Bookings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5a67d8),
              ),
            ),
            const SizedBox(height: 15),

            packageBookings.isEmpty
                ? const Text('No package bookings found')
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    itemCount: packageBookings.length,
                    itemBuilder: (context, index) {
                      return _buildPackageBookingCard(
                          context, packageBookings[index]);
                    },
                  ),

            const SizedBox(height: 30),

            // Custom Bookings Section
            const Text(
              'Custom Bookings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5a67d8),
              ),
            ),
            const SizedBox(height: 15),

            customBookings.isEmpty
                ? const Text('No custom bookings found')
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    itemCount: customBookings.length,
                    itemBuilder: (context, index) {
                      return _buildCustomBookingCard(
                          context, customBookings[index]);
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageBookingCard(
      BuildContext context, Map<String, dynamic> booking) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            Text(
              'Package: ${booking['package_name']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Date: ${booking['fordate']}'),
            Text('Location: ${booking['location']}'),
            Flexible(child: Text('Details: ${booking['details']}')),
            Text('Price: ${booking['amount']}'),
            const SizedBox(height: 8),
            Text(
              'Status: ${_getPackageStatusText(booking['status'])}',
              style: TextStyle(
                color: _getStatusColor(booking['status']),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            if (booking['status'] == 1)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(
                        amount: double.parse(
                            booking['amount'].replaceAll('\$', '')),
                        paymentDescription:
                            'Package: ${booking['package_name']}',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5a67d8),
                  minimumSize: const Size(double.infinity, 36),
                ),
                child: const Text('Pay Now'),
              ),
            if (booking['status'] == 3)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RatingPage(
                        bookingId: booking['id']
                            .toString(), // Add ID to your mock data
                        photographerName: "Sarah Johnson", // From your data
                        serviceType: booking['package_name'],
                        serviceDate: booking['fordate'],
                        location: booking['location'],
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 36),
                ),
                child: const Text('Rate Photographer'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomBookingCard(
      BuildContext context, Map<String, dynamic> booking) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Photographer: ${booking['photographer_name']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Service: ${booking['service_type']}'),
              Text('Date: ${booking['event_date']}'),
              Text('Location: ${booking['location']}'),
              Text('Details: ${booking['details']}'),
              Text('Budget: ${booking['budget']}'),
              const SizedBox(height: 8),
              Text(
                'Status: ${_getCustomStatusText(booking['status'])}',
                style: TextStyle(
                  color: _getStatusColor(booking['status']),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (booking['status'] == 1)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(
                          amount: double.parse(
                              booking['budget'].replaceAll('\$', '')),
                          paymentDescription:
                              'Custom ${booking['service_type']}',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5a67d8),
                    minimumSize: const Size(double.infinity, 36),
                  ),
                  child: const Text('Pay Now'),
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _getPackageStatusText(int status) {
    switch (status) {
      case 0:
        return 'Pending';
      case 1:
        return 'Booked';
      case 2:
        return 'Rejected';
      case 3:
        return 'Paid';
      default:
        return 'Unknown';
    }
  }

  String _getCustomStatusText(int status) {
    switch (status) {
      case 0:
        return 'Pending';
      case 1:
        return 'Booked';
      case 2:
        return 'Rejected';
      case 3:
        return 'Paid Advance';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.red;
      case 3:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
