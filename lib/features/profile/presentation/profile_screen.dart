import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(userProfileProvider);
    final currentUser = ref.read(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: CustomScrollView(
        slivers: [
          // AppBar Simplifiée
          SliverAppBar(
            backgroundColor: AppColors.primaryBlack,
            pinned: true,
            centerTitle: true,
            title: const Text(
              'MON PROFIL',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.white,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              onPressed: () => context.go('/home'),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // 1. Profile Header
                  userProfileAsync.when(
                    data: (data) {
                      // On utilise fullName directement
                      final fullNameFromDb = data?['fullName'] as String? ?? '';
                      
                      // Fallback sur firstName + lastName si fullName est vide (pour compatibilité)
                      final firstName = data?['firstName'] as String? ?? '';
                      final lastName = data?['lastName'] as String? ?? '';
                      final compositeName = '$firstName $lastName'.trim();
                      
                      final displayName = fullNameFromDb.isNotEmpty 
                          ? fullNameFromDb 
                          : (compositeName.isNotEmpty ? compositeName : 'Invité');

                      final email = data?['email'] as String? ?? currentUser?.email ?? '';
                      
                      return _ProfileHeader(
                        name: displayName,
                        email: email,
                      );
                    },
                    loading: () => const _ProfileHeader(name: '...', email: '...'),
                    error: (_, __) => const _ProfileHeader(name: 'Erreur', email: ''),
                  ),
                  
                  const SizedBox(height: 40),

                  // 2. Digital Key Card (Active Room)
                  const _ActiveKeyCard(),

                  const SizedBox(height: 40),

                  // 3. Stats Row
                  userProfileAsync.when(
                    data: (data) {
                      final points = data?['points'] as int? ?? 0;
                      final status = data?['memberStatus'] as String? ?? 'Classic';
                      return _UserStats(points: points, status: status);
                    },
                    loading: () => const _StatsRow(stays: '...', points: '...', status: '...'),
                    error: (_, __) => const _StatsRow(stays: '0', points: '0', status: 'Classic'),
                  ),

                  const SizedBox(height: 40),

                  // 4. Menu Options
                  _ProfileOption(
                    icon: Icons.person_outline_rounded,
                    title: 'Informations personnelles',
                    subtitle: 'Modifier vos coordonnées',
                    onTap: () => context.pushNamed('profile-info'),
                  ),
                  _ProfileOption(
                    icon: Icons.payment_rounded,
                    title: 'Moyens de paiement',
                    subtitle: 'Cartes & Facturation',
                    onTap: () => context.pushNamed('profile-payment'),
                  ),
                  _ProfileOption(
                    icon: Icons.settings_outlined,
                    title: 'Paramètres',
                    subtitle: 'Notifications & Confidentialité',
                    onTap: () => context.pushNamed('profile-settings'),
                  ),
                  const SizedBox(height: 24),
                  _ProfileOption(
                    icon: Icons.logout_rounded,
                    title: 'Déconnexion',
                    subtitle: '',
                    isDestructive: true,
                    onTap: () => context.go('/login'),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String email;

  const _ProfileHeader({
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Gold Glow
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGold.withOpacity(0.2),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
            // Avatar Border
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryGold, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    color: AppColors.secondaryBlack,
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            // Gold Member Badge
            Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  'GOLD MEMBER',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          name,
          style: const TextStyle(
            fontFamily: 'Playfair',
            fontSize: 28,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          email,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}

class _ActiveKeyCard extends ConsumerWidget {
  const _ActiveKeyCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null) return const SizedBox.shrink();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .where('userId', isEqualTo: user.uid)
          // On ne peut pas filtrer facilement par date ici sans index composite complexe
          // On va filtrer en mémoire car un utilisateur n'a pas des milliers de réservations
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final now = DateTime.now();
        String? activeRoomName;
        
        for (var doc in snapshot.data!.docs) {
            try {
              final data = doc.data() as Map<String, dynamic>;
              // Vérifier le statut
              final status = data['status'] as String? ?? '';
              if (status.toLowerCase() != 'confirmé' && status.toLowerCase() != 'confirmed') continue;

              if (data['checkIn'] != null && data['checkOut'] != null) {
                final checkIn = (data['checkIn'] as Timestamp).toDate();
                final checkOut = (data['checkOut'] as Timestamp).toDate();
                
                // On considère actif si on est entre checkIn (à 14h disons, mais ici date brute) et checkOut
                // On simplifie : si today >= checkIn et today <= checkOut
                if (now.isAfter(checkIn.subtract(const Duration(hours: 2))) && 
                    now.isBefore(checkOut.add(const Duration(hours: 2)))) {
                    activeRoomName = data['roomName'] as String?;
                    // On prend la première active trouvée
                    break;
                }
              }
            } catch (e) {
              continue;
            }
        }
        
        if (activeRoomName != null) {
            return _DigitalKeyCard(roomNumber: activeRoomName);
        } else {
            return const SizedBox.shrink();
        }
      }
    );
  }
}

class _DigitalKeyCard extends StatefulWidget {
  final String roomNumber;

  const _DigitalKeyCard({required this.roomNumber});

  @override
  State<_DigitalKeyCard> createState() => _DigitalKeyCardState();
}

class _DigitalKeyCardState extends State<_DigitalKeyCard> {
  bool _isUnlocking = false;
  bool _isUnlocked = false;

  void _unlockDoor() async {
    if (_isUnlocking || _isUnlocked) return;

    setState(() => _isUnlocking = true);

    // Simulation du délai réseau/bluetooth
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isUnlocking = false;
        _isUnlocked = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Porte déverrouillée avec succès'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

      // Reset après 5 secondes
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) setState(() => _isUnlocked = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unlockDoor,
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.secondaryBlack.withOpacity(0.8),
              AppColors.secondaryBlack,
              Colors.black,
            ],
          ),
          border: Border.all(
            color: _isUnlocked 
                ? Colors.greenAccent.withOpacity(0.5) 
                : AppColors.primaryGold.withOpacity(0.3),
            width: _isUnlocked ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _isUnlocked 
                  ? Colors.greenAccent.withOpacity(0.2) 
                  : AppColors.primaryGold.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative Pattern
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.03),
                    width: 40,
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'SELTON KEY',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 10,
                              letterSpacing: 2,
                              color: AppColors.primaryGold,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: _isUnlocking
                                ? SizedBox(
                                    height: 14,
                                    width: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primaryGold,
                                    ),
                                  )
                                : Text(
                                    _isUnlocked ? 'VERROUILLAGE DANS 5s' : 'Touchez pour ouvrir',
                                    key: ValueKey(_isUnlocked),
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 12,
                                      color: _isUnlocked 
                                          ? Colors.greenAccent 
                                          : Colors.white.withOpacity(0.5),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      // Chip Icon
                      Container(
                        width: 40,
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGold,
                          borderRadius: BorderRadius.circular(4),
                          gradient: const LinearGradient(
                            colors: [AppColors.primaryGold, AppColors.primaryGoldDark],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: CustomPaint(
                          painter: _ChipPainter(),
                        ),
                      ),
                    ],
                  ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CHAMBRE',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 10,
                              color: Colors.white.withOpacity(0.5),
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.roomNumber,
                            style: const TextStyle(
                              fontFamily: 'Playfair',
                              fontSize: 48,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: _isUnlocked 
                              ? Colors.green.withOpacity(0.2) 
                              : Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: _isUnlocked 
                                ? Colors.green 
                                : Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Icon(
                          _isUnlocked ? Icons.lock_open_rounded : Icons.nfc_rounded,
                          color: _isUnlocked ? Colors.green : Colors.white,
                        ),
                      ),
                    ],
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

class _UserStats extends ConsumerWidget {
  final int points;
  final String status;

  const _UserStats({
    required this.points,
    required this.status,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return const _StatsRow(stays: '0', points: '0', status: 'Classic');
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .where('userId', isEqualTo: user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        String stays = '0';
        
        if (snapshot.hasData) {
          stays = snapshot.data!.docs.length.toString();
        }

        return _StatsRow(
          stays: stays,
          points: points.toString(),
          status: status,
        );
      },
    );
  }
}

class _StatsRow extends StatelessWidget {
  final String stays;
  final String points;
  final String status;

  const _StatsRow({
    required this.stays,
    required this.points,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStat(stays, 'Séjours'),
        Container(width: 1, height: 40, color: Colors.white.withOpacity(0.1)),
        _buildStat(points, 'Points'),
        Container(width: 1, height: 40, color: Colors.white.withOpacity(0.1)),
        _buildStat(status, 'Statut', isStatus: true),
      ],
    );
  }

  Widget _buildStat(String value, String label, {bool isStatus = false}) {
    Color valueColor = AppColors.primaryGold;
    
    if (isStatus) {
      switch (value.toLowerCase()) {
        case 'silver':
          valueColor = Colors.grey.shade300;
          break;
        case 'platinum':
          valueColor = AppColors.platinum;
          break;
        case 'gold':
          valueColor = AppColors.primaryGold;
          break;
        default:
          valueColor = AppColors.primaryGold.withOpacity(0.7);
      }
    }

    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Playfair',
            fontSize: 24,
            color: valueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 12,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.secondaryBlack,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.05),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDestructive 
                    ? Colors.red.withOpacity(0.1)
                    : AppColors.primaryGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isDestructive ? Colors.red : AppColors.primaryGold,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Playfair',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDestructive ? Colors.red : Colors.white,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.white.withOpacity(0.2),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Dessiner des lignes de puce simplifiées
    final w = size.width;
    final h = size.height;
    
    canvas.drawRect(Rect.fromLTWH(w * 0.2, h * 0.2, w * 0.6, h * 0.6), paint);
    canvas.drawLine(Offset(0, h * 0.5), Offset(w * 0.4, h * 0.5), paint);
    canvas.drawLine(Offset(w * 0.6, h * 0.5), Offset(w, h * 0.5), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
