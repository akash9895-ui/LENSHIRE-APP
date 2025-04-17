import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lenshire/index.dart';
import 'package:lenshire/payment.dart';
import 'package:lenshire/rating.dart';
import 'package:intl/intl.dart';

class MyBookingsPage extends StatelessWidget {
  MyBookingsPage({super.key});

  Future<List<Map<String, dynamic>>> _fetchPackageBookings(String userId) async {
    final response = await Supabase.instance.client
        .from('User_tbl_packagebooking')
        .select('''
          id,
          packagebooking_fordate,
          packagebooking_details,
          packagebooking_status,
          location,
          packagebooking_amount,
          package_id_id,
          Photographer_tbl_package:package_id_id(package_name)
        ''')
        .eq('User_id_id', userId);

    final dateFormatter = DateFormat('yyyy-MM-dd');

    return response.map((booking) {
      String fordate;
      try {
        fordate = dateFormatter
            .format(DateTime.parse(booking['packagebooking_fordate']));
      } catch (e) {
        fordate = 'Invalid Date';
      }

      return {
        'id': booking['id'],
        'package_name': booking['Photographer_tbl_package']['package_name'] ?? 'Unknown',
        'fordate': fordate,
        'location': booking['location'] ?? '',
        'details': booking['packagebooking_details'] ?? '',
        'amount': '\$${booking['packagebooking_amount'].toString()}',
        'status': booking['packagebooking_status'] == 0
            ? 0
            : booking['packagebooking_status'],
        'package_id_id': booking['package_id_id'], // Ensure package_id_id is included
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> _fetchCustomBookings(String userId) async {
    final response = await Supabase.instance.client
        .from('User_tbl_custom_package')
        .select('''
          id,
          event_date,
          location,
          details,
          duration,
          budget,
          custom_status,
          photographer_id_id,
          service_type_id,
          Guest_tbl_photographer("*"),
          Admin_tbl_phototype("*")
        ''')
        .eq('user_id_id', userId);

    final dateFormatter = DateFormat('yyyy-MM-dd');

    return response.map((booking) {
      String eventDate;
      try {
        eventDate = dateFormatter.format(DateTime.parse(booking['event_date']));
      } catch (e) {
        eventDate = 'Invalid Date';
      }

      return {
        'id': booking['id'],
        'photographer_name': booking['Guest_tbl_photographer']['photographer_name'] ?? 'Unknown',
        'service_type': booking['Admin_tbl_phototype']['type_name'] ?? 'Unknown',
        'event_date': eventDate,
        'location': booking['location'] ?? '',
        'details': booking['details'] ?? '',
        'budget': '\$${booking['budget'].toStringAsFixed(2)}',
        'status': booking['custom_status'] == 0 ? 0 : booking['custom_status'],
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    final screenWidth = MediaQuery.of(context).size.width;

    if (userId == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            'Please log in to view your bookings.',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: const AppBarLogo(),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return Future.wait([
            _fetchPackageBookings(userId),
            _fetchCustomBookings(userId),
          ]).then((_) => null);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Bookings',
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.primary,
                  fontSize: screenWidth * 0.06,
                ),
              ),
              SizedBox(height: screenWidth * 0.075),
              Text(
                'Package Bookings',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: screenWidth * 0.045,
                ),
              ),
              const SizedBox(height: 15),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchPackageBookings(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text(
                      'Error: ${snapshot.error}',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.error),
                    );
                  }
                  final packageBookings = snapshot.data ?? [];
                  if (packageBookings.isEmpty) {
                    return Text(
                      'No package bookings found',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textPrimary),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: packageBookings.length,
                    itemBuilder: (context, index) {
                      return _buildPackageBookingCard(
                        context,
                        packageBookings[index],
                        screenWidth,
                      );
                    },
                  );
                },
              ),
              SizedBox(height: screenWidth * 0.075),
              Text(
                'Custom Bookings',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: screenWidth * 0.045,
                ),
              ),
              const SizedBox(height: 15),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchCustomBookings(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text(
                      'Error: ${snapshot.error}',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.error),
                    );
                  }
                  final customBookings = snapshot.data ?? [];
                  if (customBookings.isEmpty) {
                    return Text(
                      'No custom bookings found',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textPrimary),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: customBookings.length,
                    itemBuilder: (context, index) {
                      return _buildCustomBookingCard(
                        context,
                        customBookings[index],
                        screenWidth,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPackageBookingCard(
      BuildContext context, Map<String, dynamic> booking, double screenWidth) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: AppColors.card,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Package: ${booking['package_name']}',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontSize: screenWidth * 0.04,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: screenWidth * 0.02),
            Text(
              'Date: ${booking['fordate']}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontSize: screenWidth * 0.035,
              ),
            ),
            Text(
              'Location: ${booking['location']}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontSize: screenWidth * 0.035,
              ),
            ),
            Text(
              'Details: ${booking['details']}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontSize: screenWidth * 0.035,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Price: ${booking['amount']}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontSize: screenWidth * 0.035,
              ),
            ),
            SizedBox(height: screenWidth * 0.02),
            Text(
              'Status: ${_getPackageStatusText(booking['status'])}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: _getStatusColor(booking['status']),
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.035,
              ),
            ),
            SizedBox(height: screenWidth * 0.02),
            if (booking['status'] == 1)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(
                        amount:
                            double.parse(booking['amount'].replaceAll('\$', '')),
                        paymentDescription: 'Package: ${booking['package_name']}',
                        bookingId: booking['id'].toString(),
                        bookingType: 'package',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, screenWidth * 0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Pay Now',
                  style: AppTextStyles.button.copyWith(
                    fontSize: screenWidth * 0.04,
                  ),
                ),
              ),
            if (booking['status'] == 3)
              FutureBuilder<bool>(
                future: _checkIfRated(booking['id'].toString()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    print('Error checking rating: ${snapshot.error}');
                    return const SizedBox.shrink();
                  }
                  final isRated = snapshot.data ?? false;
                  if (isRated) {
                    return const SizedBox.shrink(); // Hide button if already rated
                  }
                  return ElevatedButton(
                    onPressed: () async {
                      print('Rate Photographer button pressed for booking ID ${booking['id']}');
                      print('Booking data: $booking');
                      try {
                        if (booking['package_id_id'] == null) {
                          throw Exception('Package ID is missing for booking ID ${booking['id']}');
                        }

                        print('Fetching photographer for package_id_id: ${booking['package_id_id']}');
                        final packageResponse = await Supabase.instance.client
                            .from('Photographer_tbl_package')
                            .select('photographer_id_id')
                            .eq('id', booking['package_id_id'])
                            .maybeSingle();

                        if (packageResponse == null) {
                          throw Exception('No package found for ID ${booking['package_id_id']}');
                        }
                        print('Package response: $packageResponse');

                        final photographerId = packageResponse['photographer_id_id'];
                        if (photographerId == null) {
                          throw Exception('Photographer ID is missing in package data');
                        }

                        final photographerResponse = await Supabase.instance.client
                            .from('Guest_tbl_photographer')
                            .select('photographer_name')
                            .eq('photo_id', photographerId)
                            .maybeSingle();

                        if (photographerResponse == null) {
                          throw Exception('No photographer found for ID $photographerId');
                        }
                        print('Photographer response: $photographerResponse');

                        final photographerName = photographerResponse['photographer_name'] as String? ?? 'Unknown';
                        print('Navigating to RatingPage for booking ${booking['id']}');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RatingPage(
                              bookingId: booking['id'].toString(),
                              photographerName: photographerName,
                              serviceType: booking['package_name'] ?? 'Unknown',
                              serviceDate: booking['fordate'] ?? 'Unknown',
                              location: booking['location'] ?? 'Unknown',
                            ),
                          ),
                        );
                      } catch (e) {
                        print('Error fetching photographer: $e');
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            title: Text(
                              'Error',
                              style: AppTextStyles.sectionTitle.copyWith(color: AppColors.error),
                            ),
                            content: Text(
                              e.toString().contains('not found') || e.toString().contains('missing')
                                  ? 'Unable to load booking or photographer details. Please contact support.'
                                  : 'Failed to load photographer details: $e',
                              style: AppTextStyles.bodyMedium,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'OK',
                                  style: AppTextStyles.actionLink,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, screenWidth * 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Rate Photographer',
                      style: AppTextStyles.button.copyWith(
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<bool> _checkIfRated(String bookingId) async {
    try {
      final response = await Supabase.instance.client
          .from('User_tbl_rating')
          .select('id')
          .eq('booking_id', int.parse(bookingId))
          .limit(1);

      return response.isNotEmpty;
    } catch (e) {
      print('Error checking if rated: $e');
      return false; // Assume not rated if query fails
    }
  }

  Widget _buildCustomBookingCard(
      BuildContext context, Map<String, dynamic> booking, double screenWidth) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: AppColors.card,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Photographer: ${booking['photographer_name']}',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontSize: screenWidth * 0.04,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: screenWidth * 0.02),
            Text(
              'Service: ${booking['service_type']}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontSize: screenWidth * 0.035,
              ),
            ),
            Text(
              'Date: ${booking['event_date']}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontSize: screenWidth * 0.035,
              ),
            ),
            Text(
              'Location: ${booking['location']}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontSize: screenWidth * 0.035,
              ),
            ),
            Text(
              'Details: ${booking['details']}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontSize: screenWidth * 0.035,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Budget: ${booking['budget']}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontSize: screenWidth * 0.035,
              ),
            ),
            SizedBox(height: screenWidth * 0.02),
            Text(
              'Status: ${_getCustomStatusText(booking['status'])}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: _getStatusColor(booking['status']),
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.035,
              ),
            ),
            SizedBox(height: screenWidth * 0.02),
            if (booking['status'] == 1)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(
                        amount:
                            double.parse(booking['budget'].replaceAll('\$', '')),
                        paymentDescription:
                            'Custom ${booking['service_type']}',
                        bookingId: booking['id'].toString(),
                        bookingType: 'custom',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, screenWidth * 0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Pay Advance',
                  style: AppTextStyles.button.copyWith(
                    fontSize: screenWidth * 0.04,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getPackageStatusText(int status) {
    switch (status) {
      case 0:
        return 'Pending';
      case 1:
        return 'Accepted';
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
        return 'Accepted';
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