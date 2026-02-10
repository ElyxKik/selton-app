import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

class BookingDetailScreen extends StatelessWidget {
  final String bookingType;
  final String bookingId;

  const BookingDetailScreen({
    super.key,
    required this.bookingType,
    required this.bookingId,
  });

  String get _collectionName {
    switch (bookingType) {
      case 'room':
        return 'bookings';
      case 'restaurant':
        return 'restaurant_bookings';
      case 'hall':
        return 'hall_bookings';
      case 'shuttle':
        return 'shuttle_bookings';
      default:
        return bookingType;
    }
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

  String _formatTime(DateTime date) => '${date.hour.toString().padLeft(2, '0')}h${date.minute.toString().padLeft(2, '0')}';

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return AppColors.warning;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  Widget _buildHeaderImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        height: 220,
        color: AppColors.secondaryBlack,
        child: const Center(
          child: Icon(Icons.image_outlined, color: Colors.white24, size: 60),
        ),
      );
    }

    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      imageUrl,
      height: 220,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: 220,
          color: AppColors.secondaryBlack,
          child: const Center(
            child: Icon(Icons.broken_image_outlined, color: Colors.white24, size: 60),
          ),
        );
      },
    );
  }

  Widget _infoRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlack,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/bookings-history');
            }
          },
        ),
        title: const Text(
          'DÉTAIL RÉSERVATION',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection(_collectionName).doc(bookingId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Erreur: ${snapshot.error}', style: const TextStyle(color: Colors.white)),
            );
          }

          if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryGold));
          }

          final doc = snapshot.data;
          if (doc == null || !doc.exists) {
            return const Center(child: Text('Réservation introuvable', style: TextStyle(color: Colors.white)));
          }

          final data = doc.data() ?? <String, dynamic>{};

          final status = (data['status'] as String?) ?? 'pending';
          final payed = (data['payed'] as bool?) ?? false;
          final paymentMethodLabel = (data['paymentMethodLabel'] as String?) ?? '';

          final title = switch (bookingType) {
            'room' => (data['roomName'] as String?) ?? 'Chambre',
            'hall' => (data['hallName'] as String?) ?? 'Salle',
            'restaurant' => (data['restaurantName'] as String?) ?? 'Restaurant',
            'shuttle' => 'Navette',
            _ => 'Réservation',
          };

          final imageUrl = data['imageUrl'] as String?;

          DateTime? mainDate;
          if (bookingType == 'hall' && data['startTime'] != null) {
            final v = data['startTime'];
            mainDate = v is Timestamp ? v.toDate() : (v is DateTime ? v : null);
          } else if (bookingType == 'shuttle' && data['scheduledTime'] != null) {
            final v = data['scheduledTime'];
            mainDate = v is Timestamp ? v.toDate() : (v is DateTime ? v : null);
          } else if (bookingType == 'restaurant' && data['bookingDate'] != null) {
            final v = data['bookingDate'];
            mainDate = v is Timestamp ? v.toDate() : (v is DateTime ? v : null);
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                  child: Stack(
                    children: [
                      _buildHeaderImage(imageUrl),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getStatusColor(status).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: _getStatusColor(status).withOpacity(0.5)),
                          ),
                          child: Text(
                            status.toUpperCase(),
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _getStatusColor(status),
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Playfair',
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (mainDate != null)
                        Text(
                          '${_formatDate(mainDate)} à ${_formatTime(mainDate)}',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),

                      const SizedBox(height: 24),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryBlack,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.08)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Détails',
                              style: TextStyle(
                                fontFamily: 'Playfair',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),

                            if (bookingType == 'room') ...[
                              _infoRow(label: 'Type', value: 'Chambre'),
                              if (data['checkInDate'] != null)
                                _infoRow(
                                  label: 'Check-in',
                                  value: _formatDate((data['checkInDate'] as Timestamp).toDate()),
                                ),
                              if (data['checkOutDate'] != null)
                                _infoRow(
                                  label: 'Check-out',
                                  value: _formatDate((data['checkOutDate'] as Timestamp).toDate()),
                                ),
                              _infoRow(label: 'Invités', value: '${data['guests'] ?? ''}'),
                            ] else if (bookingType == 'hall') ...[
                              _infoRow(label: 'Type', value: 'Salle'),
                              _infoRow(label: 'Durée', value: '${data['hours'] ?? ''} h'),
                              _infoRow(label: 'Participants', value: '${data['attendees'] ?? ''}'),
                              if ((data['notes'] as String?)?.isNotEmpty == true)
                                _infoRow(label: 'Notes', value: data['notes'] as String),
                            ] else if (bookingType == 'shuttle') ...[
                              _infoRow(label: 'Type', value: 'Navette'),
                              _infoRow(label: 'Trajet', value: '${data['tripType'] ?? ''}'),
                              _infoRow(label: 'Passagers', value: '${data['passengers'] ?? ''}'),
                              if ((data['flightNumber'] as String?)?.isNotEmpty == true)
                                _infoRow(label: 'Vol', value: data['flightNumber'] as String),
                            ] else if (bookingType == 'restaurant') ...[
                              _infoRow(label: 'Type', value: 'Restaurant'),
                              _infoRow(label: 'Personnes', value: '${data['guests'] ?? ''}'),
                              if ((data['preference'] as String?)?.isNotEmpty == true)
                                _infoRow(label: 'Préférence', value: data['preference'] as String),
                              if ((data['allergies'] as String?)?.isNotEmpty == true)
                                _infoRow(label: 'Allergies', value: data['allergies'] as String),
                            ],

                            if (data['totalPrice'] != null) _infoRow(label: 'Total', value: '\$${data['totalPrice']}'),
                            _infoRow(label: 'Payé', value: payed ? 'Oui' : 'Non'),
                            if (paymentMethodLabel.isNotEmpty) _infoRow(label: 'Méthode', value: paymentMethodLabel),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
