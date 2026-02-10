import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/auth_provider.dart';

class BookingsHistoryScreen extends ConsumerStatefulWidget {
  const BookingsHistoryScreen({super.key});

  @override
  ConsumerState<BookingsHistoryScreen> createState() => _BookingsHistoryScreenState();
}

class _BookingsHistoryScreenState extends ConsumerState<BookingsHistoryScreen> {
  final StreamController<List<_BookingItem>> _bookingsController = StreamController<List<_BookingItem>>();
  final List<StreamSubscription> _subscriptions = [];

  @override
  void initState() {
    super.initState();
    // Initialisation après le premier build pour avoir accès au ref
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initStreams();
    });
  }

  void _initStreams() {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    // Listes locales pour stocker les données de chaque collection
    List<_BookingItem> roomBookings = [];
    List<_BookingItem> restaurantBookings = [];
    List<_BookingItem> shuttleBookings = [];
    List<_BookingItem> hallBookings = [];

    // Fonction pour combiner et émettre
    void emitCombined() {
      final allBookings = [...roomBookings, ...restaurantBookings, ...shuttleBookings, ...hallBookings];
      // Tri du plus récent au plus ancien
      allBookings.sort((a, b) => b.date.compareTo(a.date));
      _bookingsController.add(allBookings);
    }

    // 1. Chambres
    _subscriptions.add(
      FirebaseFirestore.instance
          .collection('bookings')
          .where('userId', isEqualTo: user.uid)
          .snapshots()
          .listen((snapshot) {
        roomBookings = snapshot.docs.map((doc) {
          final data = doc.data();
          final checkIn = (data['checkInDate'] as Timestamp).toDate();
          final checkOut = (data['checkOutDate'] as Timestamp).toDate();
          final nights = checkOut.difference(checkIn).inDays;

          return _BookingItem(
            id: doc.id,
            type: BookingType.room,
            typeKey: 'room',
            title: data['roomName'] ?? 'Chambre',
            subtitle: '$nights nuits',
            date: checkIn,
            formattedDate: '${_formatDate(checkIn)} - ${_formatDate(checkOut)}',
            price: '\$${data['totalPrice'] ?? 0}',
            status: data['status'] ?? 'Confirmé',
            isUpcoming: checkIn.isAfter(DateTime.now()),
            imageUrl: data['imageUrl'] as String?,
          );
        }).toList();
        emitCombined();
      }),
    );

    // 2. Restaurant
    _subscriptions.add(
      FirebaseFirestore.instance
          .collection('restaurant_bookings')
          .where('userId', isEqualTo: user.uid)
          .snapshots()
          .listen((snapshot) {
        restaurantBookings = snapshot.docs.map((doc) {
          final data = doc.data();
          final date = (data['bookingDate'] as Timestamp).toDate();
          
          return _BookingItem(
            id: doc.id,
            type: BookingType.restaurant,
            typeKey: 'restaurant',
            title: data['restaurantName'] ?? 'Restaurant Le Selton',
            subtitle: '${data['guests'] ?? 2} personnes',
            date: date,
            formattedDate: '${_formatDate(date)} à ${_formatTime(date)}',
            price: '', // Pas de prix affiché pour resto généralement
            status: data['status'] ?? 'Confirmé',
            isUpcoming: date.isAfter(DateTime.now()),
            imageUrl: data['imageUrl'] as String?,
          );
        }).toList();
        emitCombined();
      }),
    );

    // 3. Navette
    _subscriptions.add(
      FirebaseFirestore.instance
          .collection('shuttle_bookings')
          .where('userId', isEqualTo: user.uid)
          .snapshots()
          .listen((snapshot) {
        shuttleBookings = snapshot.docs.map((doc) {
          final data = doc.data();
          final date = (data['scheduledTime'] as Timestamp).toDate();
          final type = data['tripType'] == 'airport_to_hotel' ? 'Aéroport -> Hôtel' : 'Hôtel -> Aéroport';

          return _BookingItem(
            id: doc.id,
            type: BookingType.shuttle,
            typeKey: 'shuttle',
            title: 'Navette VIP',
            subtitle: type,
            date: date,
            formattedDate: '${_formatDate(date)} à ${_formatTime(date)}',
            price: '\$${data['totalPrice'] ?? 0}',
            status: data['status'] ?? 'Confirmé',
            isUpcoming: date.isAfter(DateTime.now()),
            imageUrl: data['imageUrl'] as String?,
          );
        }).toList();
        emitCombined();
      }),
    );

    // 4. Salles
    _subscriptions.add(
      FirebaseFirestore.instance
          .collection('hall_bookings')
          .where('userId', isEqualTo: user.uid)
          .snapshots()
          .listen((snapshot) {
        hallBookings = snapshot.docs.map((doc) {
          final data = doc.data();
          final date = (data['startTime'] as Timestamp).toDate();

          final hours = (data['hours'] as num?)?.toInt() ?? 1;
          final attendees = (data['attendees'] as num?)?.toInt() ?? 0;

          return _BookingItem(
            id: doc.id,
            type: BookingType.hall,
            typeKey: 'hall',
            title: data['hallName'] ?? 'Salle',
            subtitle: '$attendees pers. • $hours h',
            date: date,
            formattedDate: '${_formatDate(date)} à ${_formatTime(date)}',
            price: data['totalPrice'] != null ? '\$${data['totalPrice']}' : '',
            status: data['status'] ?? 'Confirmé',
            isUpcoming: date.isAfter(DateTime.now()),
            imageUrl: data['imageUrl'] as String?,
          );
        }).toList();
        emitCombined();
      }),
    );
  }

  @override
  void dispose() {
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    _bookingsController.close();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}h${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: AppColors.primaryBlack,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/');
                  }
                },
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: const Text(
                'MES RÉSERVATIONS',
                style: TextStyle(
                  fontFamily: 'Playfair',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.5),
                    radius: 1.5,
                    colors: [
                      AppColors.secondaryBlack,
                      AppColors.primaryBlack,
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          if (user == null)
            const SliverFillRemaining(
              child: Center(child: Text('Veuillez vous connecter', style: TextStyle(color: Colors.white))),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: StreamBuilder<List<_BookingItem>>(
                stream: _bookingsController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return SliverFillRemaining(
                      child: Center(child: Text('Erreur: ${snapshot.error}', style: const TextStyle(color: Colors.white))),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator(color: AppColors.primaryGold)),
                    );
                  }

                  final bookings = snapshot.data ?? [];
                  if (bookings.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(child: Text('Aucune réservation trouvée', style: TextStyle(color: Colors.white))),
                    );
                  }

                  final upcomingBookings = bookings.where((b) => b.isUpcoming).toList();
                  final historyBookings = bookings.where((b) => !b.isUpcoming).toList();

                  final children = <Widget>[];
                  
                  if (upcomingBookings.isNotEmpty) {
                    children.add(
                      const Text(
                        'À venir',
                        style: TextStyle(
                          fontFamily: 'Playfair',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGold,
                        ),
                      ),
                    );
                    children.add(const SizedBox(height: 24));
                    children.addAll(upcomingBookings.map((item) => _BookingCard(item: item)));
                    children.add(const SizedBox(height: 40));
                  }

                  if (historyBookings.isNotEmpty) {
                    children.add(
                      const Text(
                        'Historique',
                        style: TextStyle(
                          fontFamily: 'Playfair',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    );
                    children.add(const SizedBox(height: 24));
                    children.addAll(historyBookings.map((item) => _BookingCard(item: item)));
                  }
                  
                  return SliverList(
                    delegate: SliverChildListDelegate(children),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

enum BookingType { room, restaurant, shuttle, hall }

class _BookingItem {
  final String id;
  final BookingType type;
  final String typeKey;
  final String title;
  final String subtitle;
  final DateTime date;
  final String formattedDate;
  final String price;
  final String status;
  final bool isUpcoming;
  final String? imageUrl;

  _BookingItem({
    required this.id,
    required this.type,
    required this.typeKey,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.formattedDate,
    required this.price,
    required this.status,
    required this.isUpcoming,
    required this.imageUrl,
  });
}

class _BookingCard extends StatelessWidget {
  final _BookingItem item;

  const _BookingCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = item.isUpcoming 
        ? AppColors.primaryGold.withOpacity(0.2)
        : AppColors.secondaryBlack;

    IconData getIcon() {
      switch (item.type) {
        case BookingType.room: return Icons.bed_rounded;
        case BookingType.restaurant: return Icons.restaurant_rounded;
        case BookingType.shuttle: return Icons.airport_shuttle_rounded;
        case BookingType.hall: return Icons.meeting_room_rounded;
      }
    }

    Widget buildHeaderImage() {
      final url = item.imageUrl;
      if (url == null || url.isEmpty) {
        return Center(
          child: Icon(
            getIcon(),
            size: 60,
            color: Colors.white.withOpacity(0.1),
          ),
        );
      }

      if (url.startsWith('assets/')) {
        return Image.asset(url, fit: BoxFit.cover, width: double.infinity, height: double.infinity);
      }

      return Image.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Icon(
              getIcon(),
              size: 60,
              color: Colors.white.withOpacity(0.1),
            ),
          );
        },
      );
    }

    return InkWell(
      onTap: () => context.go('/booking/${item.typeKey}/${item.id}'),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: AppColors.secondaryBlack,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: Container(
                height: 140,
                color: color,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    buildHeaderImage(),
                    Container(color: Colors.black.withOpacity(0.25)),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(item.status).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _getStatusColor(item.status).withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          item.status.toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(item.status),
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontFamily: 'Playfair',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (item.price.isNotEmpty)
                      Text(
                        item.price,
                        style: TextStyle(
                          fontFamily: 'Playfair',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: item.isUpcoming ? AppColors.primaryGold : Colors.white.withOpacity(0.5),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildFeature(Icons.calendar_today_rounded, item.formattedDate),
                    const SizedBox(width: 16),
                    _buildFeature(Icons.info_outline_rounded, item.subtitle),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryGold.withOpacity(item.isUpcoming ? 1.0 : 0.3)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'VOIR LES DÉTAILS',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGold.withOpacity(item.isUpcoming ? 1.0 : 0.7),
                        letterSpacing: 1,
                      ),
                    ),
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

  Widget _buildFeature(IconData icon, String text) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white54),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                color: Colors.white54,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmé':
      case 'confirmed':
        return AppColors.primaryGold;
      case 'en attente':
      case 'pending':
        return Colors.orange;
      case 'terminé':
      case 'completed':
        return Colors.grey;
      case 'annulé':
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.white;
    }
  }
}
