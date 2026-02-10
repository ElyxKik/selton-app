# 🏨 Selton Hotel - Application Mobile Premium

Application mobile Flutter haut de gamme pour l'hôtel de luxe Selton.

## ✨ Fonctionnalités

### 🔐 Authentification
- Connexion / Inscription
- Récupération de mot de passe
- Authentification Google

### 🏠 Écrans Principaux
- **Splash Screen** animé avec logo premium
- **Onboarding** 3 pages interactives
- **Home** avec accès rapide aux services
- **Navigation** bottom bar intuitive

### 🛏️ Réservations
- Liste des chambres disponibles
- Détails des chambres (Suite Royale, Présidentielle, Deluxe...)
- Système de réservation
- Historique des réservations

### 🍽️ Restaurant & Bar
- Menu gastronomique
- Carte des cocktails signature
- Prix et descriptions détaillés

### 🎯 Services
- Spa & Wellness
- Salle de sport
- Piscine
- Navette aéroport

### 👤 Profil
- Informations personnelles
- Moyens de paiement
- Paramètres
- Déconnexion

## 🎨 Design System

### Palette de Couleurs
- **Or Premium** : `#D4AF37` (couleur principale)
- **Noir Élégant** : `#1A1A1A`
- **Blanc Pur** : `#FFFFFF`
- **Gris Clair** : `#F5F5F5`

### Typographie
- **Titres** : Playfair Display (serif élégant)
- **Corps** : Montserrat (sans-serif moderne)

### Composants
- Boutons personnalisés avec animations
- Champs de texte premium
- Cards avec ombres douces
- Gradients or et noir

## 🏗️ Architecture

```
lib/
├── main.dart
├── core/
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_theme.dart
│   ├── router/
│   │   └── app_router.dart
│   └── widgets/
│       ├── custom_button.dart
│       └── custom_text_field.dart
└── features/
    ├── splash/
    ├── onboarding/
    ├── auth/
    ├── home/
    ├── rooms/
    ├── restaurant/
    ├── services/
    ├── bookings/
    ├── profile/
    └── main/
```

## 🚀 Installation

### Prérequis
- Flutter SDK 3.0+
- Dart 3.0+

### Étapes

1. **Cloner le projet**
```bash
cd selton
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Créer les dossiers assets**
```bash
mkdir -p assets/images assets/icons assets/fonts assets/animations
```

4. **Télécharger les polices** (optionnel)
- Playfair Display : https://fonts.google.com/specimen/Playfair+Display
- Montserrat : https://fonts.google.com/specimen/Montserrat

Placer les fichiers `.ttf` dans `assets/fonts/`

5. **Lancer l'application**
```bash
flutter run
```

## 📦 Dépendances Principales

- **flutter_riverpod** : State management
- **go_router** : Navigation déclarative
- **flutter_animate** : Animations fluides
- **shimmer** : Effets de chargement
- **smooth_page_indicator** : Indicateurs de page
- **dio** : Appels API
- **shared_preferences** : Stockage local

## 🎯 Navigation

### Routes Disponibles
- `/splash` - Écran de démarrage
- `/onboarding` - Introduction
- `/login` - Connexion
- `/register` - Inscription
- `/` - Navigation principale
- `/rooms` - Liste des chambres
- `/rooms/:id` - Détail d'une chambre
- `/booking/:roomId` - Réservation
- `/menu` - Menu restaurant
- `/cocktails` - Carte des cocktails
- `/services` - Services de l'hôtel
- `/bookings-history` - Historique
- `/profile` - Profil utilisateur

## 🔧 Configuration

### Thème
Le thème est centralisé dans `lib/core/theme/app_theme.dart` et utilise Material Design 3.

### Couleurs
Personnalisables dans `lib/core/theme/app_colors.dart`.

### Styles de Texte
Modifiables dans `lib/core/theme/app_text_styles.dart`.

## 📱 Écrans

### Splash Screen
Animation d'entrée avec logo Selton en or sur fond noir premium.

### Onboarding
3 pages avec illustrations et descriptions des services.

### Home
- Header avec logo
- Cartes de services (Chambres, Restaurant, Bar, Services)
- Chambre mise en avant
- Navigation fluide

### Réservations
- Liste des chambres avec prix
- Détails complets
- Système de réservation simplifié

## 🎨 UI/UX

### Principes
- **Minimalisme** : Design épuré et élégant
- **Hiérarchie** : Typographie claire et structurée
- **Contraste** : Or sur noir pour un effet premium
- **Espacement** : Marges généreuses pour la respiration
- **Animations** : Transitions fluides et subtiles

### Composants Réutilisables
- `CustomButton` : Bouton avec loading et variantes
- `CustomTextField` : Champ de texte stylisé
- Cards personnalisées pour chaque contexte

## 🔮 Améliorations Futures

### Fonctionnalités
- [ ] Intégration API backend réelle
- [ ] Paiement en ligne (Stripe/PayPal)
- [ ] Notifications push
- [ ] Chat avec le concierge
- [ ] Réalité augmentée pour visiter les chambres
- [ ] Programme de fidélité
- [ ] Multi-langues (FR/EN/ES)
- [ ] Mode sombre

### Technique
- [ ] Tests unitaires et d'intégration
- [ ] CI/CD avec GitHub Actions
- [ ] Analytics (Firebase/Mixpanel)
- [ ] Crash reporting (Sentry)
- [ ] Performance monitoring

## 📄 Licence

Projet privé - Tous droits réservés © 2024 Selton Hotel

## 👨‍💻 Développement

Développé avec ❤️ en Flutter

---

**Note** : Cette application est un prototype premium. Pour la production, ajoutez :
- Backend API sécurisé
- Authentification JWT
- Base de données
- Système de paiement
- Tests complets
