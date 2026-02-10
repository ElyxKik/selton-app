import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selton_hotel/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/database_seeder.dart';
import '../../../core/providers/locale_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailPromoEnabled = false;
  bool _biometricEnabled = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlack,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n?.settingsTitle.toUpperCase() ?? 'PARAMÈTRES',
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
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader('Général'),
          _buildSwitchTile(
            l10n?.notifications ?? 'Notifications',
            'Recevoir des alertes pour vos séjours',
            _notificationsEnabled,
            (val) => setState(() => _notificationsEnabled = val),
          ),
          
          const SizedBox(height: 32),
          
          _buildSectionHeader('Sécurité'),
          _buildSwitchTile(
            'Face ID / Touch ID',
            'Connexion biométrique sécurisée',
            _biometricEnabled,
            (val) => setState(() => _biometricEnabled = val),
          ),
          
          const SizedBox(height: 32),
          
          _buildSectionHeader('Application'),
          _buildLinkTile(
            '${l10n?.language ?? "Langue"} (${_getLanguageName(currentLocale.languageCode)})', 
            Icons.language,
            onTap: () => _showLanguageSelector(context),
          ),
          _buildLinkTile(l10n?.privacyPolicy ?? 'Politique de confidentialité', Icons.privacy_tip_outlined),
          _buildLinkTile(l10n?.termsOfService ?? 'Conditions générales', Icons.description_outlined),
          
          const SizedBox(height: 40),
          
          TextButton(
            onPressed: () {},
            child: Text(
              'Supprimer mon compte',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                color: Colors.red.withOpacity(0.7),
                decoration: TextDecoration.underline,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Bouton Admin caché (Double tap ou simple clic pour dev)
          Center(
            child: TextButton.icon(
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Initialisation de la DB en cours...')),
                );
                
                await DatabaseSeeder().seedAll();

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Base de données initialisée !'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.cloud_upload, color: Colors.white24),
              label: const Text(
                'Initialiser Database (Admin)',
                style: TextStyle(color: Colors.white24),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en': return 'English';
      case 'zh': return 'Chinese';
      case 'hi': return 'Hindi';
      case 'de': return 'German';
      default: return 'Français';
    }
  }

  void _showLanguageSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.secondaryBlack,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choisir une langue',
              style: TextStyle(
                fontFamily: 'Playfair',
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildLanguageOption('Français', 'fr'),
            _buildLanguageOption('English', 'en'),
            _buildLanguageOption('Chinese (中文)', 'zh'),
            _buildLanguageOption('Hindi (हिन्दी)', 'hi'),
            _buildLanguageOption('German (Deutsch)', 'de'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String label, String code) {
    final isSelected = ref.read(localeProvider).languageCode == code;
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          fontFamily: 'Montserrat',
          color: isSelected ? AppColors.primaryGold : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected ? const Icon(Icons.check, color: AppColors.primaryGold) : null,
      onTap: () {
        ref.read(localeProvider.notifier).setLocale(Locale(code));
        context.pop();
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Playfair',
          fontSize: 20,
          color: AppColors.primaryGold,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.secondaryBlack,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 12,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primaryGold,
        activeTrackColor: AppColors.primaryGold.withOpacity(0.3),
        inactiveThumbColor: Colors.grey,
        inactiveTrackColor: Colors.white.withOpacity(0.1),
      ),
    );
  }

  Widget _buildLinkTile(String title, IconData icon, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.secondaryBlack,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white54, size: 20),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
        onTap: onTap ?? () {},
      ),
    );
  }
}
