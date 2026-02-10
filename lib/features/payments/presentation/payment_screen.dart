import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_button.dart';

class PaymentScreen extends StatefulWidget {
  final String bookingType;
  final String bookingId;

  const PaymentScreen({
    super.key,
    required this.bookingType,
    required this.bookingId,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = false;

  String _selectedMethod = 'card_visa';

  String get _collectionName {
    switch (widget.bookingType) {
      case 'room':
        return 'bookings';
      case 'restaurant':
        return 'restaurant_bookings';
      case 'hall':
        return 'hall_bookings';
      case 'shuttle':
        return 'shuttle_bookings';
      default:
        return widget.bookingType;
    }
  }

  String get _screenTitle {
    switch (widget.bookingType) {
      case 'room':
        return 'PAIEMENT CHAMBRE';
      case 'restaurant':
        return 'PAIEMENT RESTAURANT';
      case 'hall':
        return 'PAIEMENT SALLE';
      case 'shuttle':
        return 'PAIEMENT NAVETTE';
      default:
        return 'PAIEMENT';
    }
  }

  String get _methodLabel {
    switch (_selectedMethod) {
      case 'card_visa':
        return 'Carte Visa';
      case 'card_mastercard':
        return 'Carte MasterCard';
      case 'card_amex':
        return 'Carte American Express';
      case 'mm_mpesa':
        return 'M-Pesa (RDC)';
      case 'mm_orange_money':
        return 'Orange Money (RDC)';
      case 'mm_afrimoney':
        return 'Afrimoney (RDC)';
      case 'mm_airtel_money':
        return 'Airtel Money (RDC)';
      default:
        return _selectedMethod;
    }
  }

  Future<void> _confirmPayment() async {
    setState(() => _isLoading = true);

    try {
      final bookingRef = FirebaseFirestore.instance.collection(_collectionName).doc(widget.bookingId);
      final snapshot = await bookingRef.get();

      if (!snapshot.exists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Réservation introuvable.'), backgroundColor: Colors.red),
          );
        }
        return;
      }

      await bookingRef.update({
        'payed': true,
        'payedAt': FieldValue.serverTimestamp(),
        'paymentMethod': _selectedMethod,
        'paymentMethodLabel': _methodLabel,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Paiement effectué (simulé).'), backgroundColor: Colors.green),
        );
        context.go('/bookings-history');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur paiement: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
              context.go('/');
            }
          },
        ),
        title: Text(
          _screenTitle,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choisissez une méthode de paiement',
              style: TextStyle(
                fontFamily: 'Playfair',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            _Section(
              title: 'Carte bancaire',
              child: Column(
                children: [
                  _MethodTile(
                    title: 'Visa',
                    subtitle: 'Paiement sécurisé par carte',
                    icon: Icons.credit_card,
                    value: 'card_visa',
                    groupValue: _selectedMethod,
                    onChanged: (v) => setState(() => _selectedMethod = v),
                  ),
                  _MethodTile(
                    title: 'MasterCard',
                    subtitle: 'Paiement sécurisé par carte',
                    icon: Icons.credit_card,
                    value: 'card_mastercard',
                    groupValue: _selectedMethod,
                    onChanged: (v) => setState(() => _selectedMethod = v),
                  ),
                  _MethodTile(
                    title: 'American Express',
                    subtitle: 'Paiement sécurisé par carte',
                    icon: Icons.credit_card,
                    value: 'card_amex',
                    groupValue: _selectedMethod,
                    onChanged: (v) => setState(() => _selectedMethod = v),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _Section(
              title: 'Mobile Money (RDC)',
              child: Column(
                children: [
                  _MethodTile(
                    title: 'M-Pesa',
                    subtitle: 'Paiement via mobile money',
                    icon: Icons.phone_iphone,
                    value: 'mm_mpesa',
                    groupValue: _selectedMethod,
                    onChanged: (v) => setState(() => _selectedMethod = v),
                  ),
                  _MethodTile(
                    title: 'Orange Money',
                    subtitle: 'Paiement via mobile money',
                    icon: Icons.phone_iphone,
                    value: 'mm_orange_money',
                    groupValue: _selectedMethod,
                    onChanged: (v) => setState(() => _selectedMethod = v),
                  ),
                  _MethodTile(
                    title: 'Afrimoney',
                    subtitle: 'Paiement via mobile money',
                    icon: Icons.phone_iphone,
                    value: 'mm_afrimoney',
                    groupValue: _selectedMethod,
                    onChanged: (v) => setState(() => _selectedMethod = v),
                  ),
                  _MethodTile(
                    title: 'Airtel Money',
                    subtitle: 'Paiement via mobile money',
                    icon: Icons.phone_iphone,
                    value: 'mm_airtel_money',
                    groupValue: _selectedMethod,
                    onChanged: (v) => setState(() => _selectedMethod = v),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.secondaryBlack,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Méthode',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    _methodLabel,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            CustomButton(
              text: 'PAYER (SIMULÉ)',
              onPressed: _confirmPayment,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Playfair',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;

  const _MethodTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryGold.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primaryGold.withOpacity(0.6) : Colors.white.withOpacity(0.08),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? AppColors.primaryGold : Colors.white54, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: (v) {
                if (v == null) return;
                onChanged(v);
              },
              activeColor: AppColors.primaryGold,
            ),
          ],
        ),
      ),
    );
  }
}
