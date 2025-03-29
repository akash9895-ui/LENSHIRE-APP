import 'package:flutter/material.dart';
import 'package:lenshire/custompackage.dart';
import 'package:lenshire/packagebooking.dart';

class PhotographerDetailsPage extends StatelessWidget {
  const PhotographerDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data
    final photographer = {
      'name': 'Sarah Johnson',
      'email': 'sarah.johnson@example.com',
      'contact': '+1 (555) 123-4567',
      'address': '123 Photography Lane, Studio 5',
      'place': 'New York, NY',
    };

    final packages = [
      {
        'name': 'Basic Package',
        'details': '2 hours of shooting, 30 edited photos',
        'price': '250',
      },
      {
        'name': 'Standard Package',
        'details': '4 hours of shooting, 60 edited photos',
        'price': '450',
      },
      {
        'name': 'Premium Package',
        'details': 'Full day coverage, 100+ edited photos',
        'price': '800',
      },
      {
        'name': 'Event Package',
        'details': '5 hours of event coverage, 80 edited photos',
        'price': '600',
      },
    ];

    final gallery = [
      {'caption': 'Wedding Photography'},
      {'caption': 'Portrait Session'},
      {'caption': 'Commercial Shoot'},
      {'caption': 'Family Portrait'},
      {'caption': 'Product Photography'},
      {'caption': 'Outdoor Session'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Photographer Details'),
        backgroundColor: const Color(0xFF5a67d8),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildPhotographerCard(context, photographer), // Pass context here
            const SizedBox(height: 24),
            const Text(
              'Packages',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5a67d8),
              ),
            ),
            _buildPackagesList(context, packages),
            const SizedBox(height: 24),
            const Text(
              'Gallery',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5a67d8),
              ),
            ),
            _buildGalleryGrid(gallery),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotographerCard(BuildContext context, Map<String, dynamic> photographer) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.account_circle, size: 100, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              photographer['name'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.email, photographer['email']),
            _buildInfoRow(Icons.phone, photographer['contact']),
            _buildInfoRow(Icons.location_on, photographer['address']),
            _buildInfoRow(Icons.place, photographer['place']),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context, // Use the context passed to this method
                  MaterialPageRoute(
                    builder: (context) => const CustomPackageRequestPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5a67d8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text('Request Custom Package'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildPackagesList(BuildContext context, List<Map<String, dynamic>> packages) {
    if (packages.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No packages available'),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: packages.length,
      itemBuilder: (context, index) {
        return _buildPackageCard(context, packages[index]);
      },
    );
  }

  Widget _buildPackageCard(BuildContext context, Map<String, dynamic> package) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.photo_library, size: 40, color: Colors.grey),
            const SizedBox(height: 8),
            Text(
              package['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              package['details'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Text(
              'Price: \$${package['price']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PackageBookingPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5a67d8),
                minimumSize: const Size(double.infinity, 36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text('Book Now'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGalleryGrid(List<Map<String, dynamic>> gallery) {
    if (gallery.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No gallery items available'),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: gallery.length,
      itemBuilder: (context, index) {
        return _buildGalleryItem(gallery[index]);
      },
    );
  }

  Widget _buildGalleryItem(Map<String, dynamic> item) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Expanded(
            child: const Icon(Icons.photo, size: 60, color: Colors.grey),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(item['caption']),
          ),
        ],
      ),
    );
  }
}