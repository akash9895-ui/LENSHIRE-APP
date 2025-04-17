import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lenshire/index.dart';

class PaymentPage extends StatefulWidget {
  final double amount;
  final String paymentDescription;
  final String bookingId;
  final String bookingType; // 'package' or 'custom'

  const PaymentPage({
    Key? key,
    required this.amount,
    required this.paymentDescription,
    required this.bookingId,
    required this.bookingType,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _cardController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _isProcessing = false;

  double get paymentAmount =>
      widget.bookingType == 'custom' ? widget.amount * 0.2 : widget.amount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: const AppBarLogo(),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment',
              style: AppTextStyles.heading2.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            // Payment Summary Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: AppColors.card,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Summary',
                      style: AppTextStyles.sectionTitle
                          .copyWith(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Description', widget.paymentDescription),
                    if (widget.bookingType == 'custom') ...[
                      _buildDetailRow(
                          'Full Amount', '\$${widget.amount.toStringAsFixed(2)}'),
                      _buildDetailRow('Advance Payable (20%)',
                          '\$${paymentAmount.toStringAsFixed(2)}'),
                    ] else
                      _buildDetailRow(
                          'Amount', '\$${widget.amount.toStringAsFixed(2)}'),
                    const SizedBox(height: 16),
                    const Divider(color: AppColors.divider),
                    _buildDetailRow(
                      widget.bookingType == 'custom'
                          ? 'Total Advance Payable'
                          : 'Total Payable',
                      '\$${paymentAmount.toStringAsFixed(2)}',
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Card Details Section
            Text(
              'Card Details',
              style: AppTextStyles.sectionTitle
                  .copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _cardController,
                    decoration: InputDecoration(
                      labelText: 'Card Number',
                      hintText: '4242 4242 4242 4242',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.divider),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.error),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.error),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter card number';
                      }
                      if (!RegExp(r'^\d{16}$').hasMatch(value)) {
                        return 'Enter a valid 16-digit card number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _expiryController,
                          decoration: InputDecoration(
                            labelText: 'MM/YY',
                            hintText: '12/25',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.divider),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.primary),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.error),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.error),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter expiry date';
                            }
                            if (!RegExp(r'^(0[1-9]|1[0-2])/(\d{2})$')
                                .hasMatch(value)) {
                              return 'Enter valid MM/YY';
                            }
                            final parts = value.split('/');
                            final month = int.parse(parts[0]);
                            final year = int.parse('20${parts[1]}');
                            final now = DateTime.now();
                            final expiryDate = DateTime(year, month + 1, 1);
                            if (expiryDate.isBefore(now)) {
                              return 'Card has expired';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _cvvController,
                          decoration: InputDecoration(
                            labelText: 'CVV',
                            hintText: '123',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.divider),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.primary),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.error),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.error),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter CVV';
                            }
                            if (!RegExp(r'^\d{3,4}$').hasMatch(value)) {
                              return 'Enter valid 3-4 digit CVV';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Payment Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Pay \$${paymentAmount.toStringAsFixed(2)}',
                        style: AppTextStyles.button,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textHint,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            'Invalid Card Details',
            style: AppTextStyles.sectionTitle.copyWith(color: AppColors.error),
          ),
          content: Text(
            'Please check your card number, expiry date, or CVV.',
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
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      print('Processing ${widget.bookingType} payment for ID ${widget.bookingId}');

      // Convert bookingId to integer if necessary
      int bookingId;
      try {
        bookingId = int.parse(widget.bookingId);
      } catch (e) {
        throw Exception('Invalid booking ID format: ${widget.bookingId}');
      }

      // Validate bookingId exists
      if (widget.bookingType == 'package') {
        final packageBooking = await Supabase.instance.client
            .from('User_tbl_packagebooking')
            .select('id')
            .eq('id', bookingId)
            .maybeSingle();
        print('Package booking query result: $packageBooking');
        if (packageBooking == null) {
          throw Exception('Package booking ID $bookingId not found');
        }
      } else if (widget.bookingType == 'custom') {
        final customBooking = await Supabase.instance.client
            .from('User_tbl_custom_package')
            .select('id')
            .eq('id', bookingId)
            .maybeSingle();
        print('Custom booking query result: $customBooking');
        if (customBooking == null) {
          throw Exception('Custom booking ID $bookingId not found');
        }
      } else {
        throw Exception('Invalid booking type: ${widget.bookingType}');
      }

      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));

      // Update status based on booking type
      if (widget.bookingType == 'package') {
        await Supabase.instance.client
            .from('User_tbl_packagebooking')
            .update({'packagebooking_status': 3})
            .eq('id', bookingId);
        print('Updated package booking status to 3 for ID $bookingId');
      } else if (widget.bookingType == 'custom') {
        await Supabase.instance.client
            .from('User_tbl_custom_package')
            .update({'custom_status': 3})
            .eq('id', bookingId);
        print('Updated custom booking status to 3 for ID $bookingId');
      }

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            'Payment Successful',
            style: AppTextStyles.sectionTitle,
          ),
          content: Text(
            widget.bookingType == 'custom'
                ? 'Your advance payment of \$${paymentAmount.toStringAsFixed(2)} for ${widget.paymentDescription} was successful.'
                : 'Your payment of \$${paymentAmount.toStringAsFixed(2)} for ${widget.paymentDescription} was successful.',
            style: AppTextStyles.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                'OK',
                style: AppTextStyles.actionLink,
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Payment error for ${widget.bookingType} ID ${widget.bookingId}: $e');
      // Show error dialog with specific message
      String errorMessage;
      if (e.toString().contains('not found')) {
        errorMessage = 'Booking not found. Please check the booking ID.';
      } else if (e.toString().contains('Invalid booking type')) {
        errorMessage = 'Invalid booking type. Contact support.';
      } else if (e.toString().contains('Invalid booking ID format')) {
        errorMessage = 'Invalid booking ID format. Please try again.';
      } else {
        errorMessage = 'An error occurred: $e';
      }
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            'Payment Failed',
            style: AppTextStyles.sectionTitle.copyWith(color: AppColors.error),
          ),
          content: Text(
            errorMessage,
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
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  void dispose() {
    _cardController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }
}