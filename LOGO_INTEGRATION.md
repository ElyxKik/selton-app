# 🎨 Intégration du Logo Selton

## ✅ Logo Intégré Partout dans l'Application

Le logo `logo_selton.png` a été intégré dans toute l'application Selton Hotel.

---

## 📍 Emplacements du Logo

### **1. 🏠 Page d'Accueil (HomeScreen)**
**Fichier:** `lib/features/home/presentation/home_screen.dart`

**Emplacement:** Header de la SliverAppBar

```dart
Container(
  width: 90,
  height: 90,
  decoration: BoxDecoration(
    color: AppColors.pureWhite,
    borderRadius: BorderRadius.circular(45),
    boxShadow: [
      BoxShadow(
        color: AppColors.primaryGold.withOpacity(0.15),
        blurRadius: 16,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(45),
    child: Image.asset(
      'assets/images/logo_selton.png',
      fit: BoxFit.cover,
    ),
  ),
)
```

**Caractéristiques:**
- ✅ Taille: 90x90 pixels
- ✅ Forme: Circulaire
- ✅ Ombre dorée subtile
- ✅ Fond blanc

---

### **2. 🚀 Splash Screen**
**Fichier:** `lib/features/splash/presentation/splash_screen.dart`

**Emplacement:** Centre de l'écran avec animation

```dart
Container(
  width: 150,
  height: 150,
  decoration: BoxDecoration(
    color: AppColors.pureWhite,
    borderRadius: BorderRadius.circular(75),
    boxShadow: [
      BoxShadow(
        color: AppColors.primaryGold.withOpacity(0.3),
        blurRadius: 30,
        spreadRadius: 10,
      ),
    ],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(75),
    child: Image.asset(
      'assets/images/logo_selton.png',
      fit: BoxFit.cover,
    ),
  ),
)
.animate()
.scale(duration: Duration(milliseconds: 800))
.fadeIn(duration: Duration(milliseconds: 600))
```

**Caractéristiques:**
- ✅ Taille: 150x150 pixels
- ✅ Animation: Scale + FadeIn
- ✅ Ombre dorée importante
- ✅ Premier élément visible de l'app

---

### **3. 📖 Onboarding (Première Page)**
**Fichier:** `lib/features/onboarding/presentation/onboarding_screen.dart`

**Emplacement:** Page 1 du carousel

```dart
Container(
  width: 140,
  height: 140,
  decoration: BoxDecoration(
    color: AppColors.pureWhite,
    borderRadius: BorderRadius.circular(70),
    boxShadow: [
      BoxShadow(
        color: AppColors.primaryGold.withOpacity(0.3),
        blurRadius: 20,
        spreadRadius: 5,
      ),
    ],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(70),
    child: Image.asset(
      'assets/images/logo_selton.png',
      fit: BoxFit.cover,
    ),
  ),
)
```

**Caractéristiques:**
- ✅ Taille: 140x140 pixels
- ✅ Uniquement sur la première page
- ✅ Pages 2 et 3: Icônes thématiques
- ✅ Renforce le branding

---

### **4. 📱 Icône de l'Application (Android & iOS)**

**Configuration:** `pubspec.yaml`

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "logo_selton.png"
  adaptive_icon_background: "#F5EFE0"
  adaptive_icon_foreground: "logo_selton.png"
  remove_alpha_ios: true
```

**Génération:**
```bash
dart run flutter_launcher_icons
```

**Résultat:**
- ✅ **Android:** Icône standard + Adaptive icon
- ✅ **iOS:** Icône avec fond beige (#F5EFE0)
- ✅ **Toutes tailles:** Générées automatiquement
- ✅ **Fichiers créés:**
  - `android/app/src/main/res/mipmap-*/ic_launcher.png`
  - `android/app/src/main/res/mipmap-*/ic_launcher_foreground.png`
  - `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

---

## 🎨 Caractéristiques du Logo

### **Design**
- **Forme:** Circulaire
- **Couleurs:** Beige/crème avec texte bleu marine
- **Éléments:** 
  - Motif décoratif en haut (feuilles/plumes)
  - Texte "SELTON" en gros
  - Texte "HOTEL" en dessous
  - Ligne décorative dorée

### **Utilisation dans l'App**
- **Fond:** Toujours blanc ou beige clair
- **Bordure:** Circulaire (borderRadius = width/2)
- **Ombre:** Dorée avec opacité variable (0.1 à 0.3)
- **Fit:** `BoxFit.cover` pour remplir le conteneur

---

## 📁 Structure des Fichiers

```
selton/
├── logo_selton.png                    ← Logo source (racine)
├── assets/
│   └── images/
│       └── logo_selton.png            ← Logo copié dans assets
├── android/
│   └── app/src/main/res/
│       ├── mipmap-hdpi/ic_launcher.png
│       ├── mipmap-mdpi/ic_launcher.png
│       ├── mipmap-xhdpi/ic_launcher.png
│       ├── mipmap-xxhdpi/ic_launcher.png
│       ├── mipmap-xxxhdpi/ic_launcher.png
│       └── values/colors.xml          ← Couleur de fond adaptive
└── ios/
    └── Runner/Assets.xcassets/
        └── AppIcon.appiconset/        ← Toutes les tailles iOS
```

---

## 🔧 Configuration Technique

### **pubspec.yaml**

```yaml
flutter:
  assets:
    - assets/images/              # Inclut logo_selton.png

dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "logo_selton.png"
  adaptive_icon_background: "#F5EFE0"
  adaptive_icon_foreground: "logo_selton.png"
  remove_alpha_ios: true
```

### **Commandes Exécutées**

```bash
# 1. Créer le dossier assets
mkdir -p assets/images

# 2. Copier le logo
cp logo_selton.png assets/images/logo_selton.png

# 3. Installer les dépendances
flutter pub get

# 4. Générer les icônes
dart run flutter_launcher_icons
```

---

## 🎯 Tailles Utilisées

| Écran | Taille | Forme | Ombre |
|-------|--------|-------|-------|
| **Splash** | 150x150 | Circulaire | Forte (30px blur) |
| **Onboarding** | 140x140 | Circulaire | Moyenne (20px blur) |
| **Home AppBar** | 90x90 | Circulaire | Légère (16px blur) |
| **Icône App** | Variable | Carrée/Ronde | Aucune |

---

## 🎨 Variantes de Style

### **Style 1: Fond Blanc + Ombre Dorée**
```dart
Container(
  decoration: BoxDecoration(
    color: AppColors.pureWhite,
    borderRadius: BorderRadius.circular(radius),
    boxShadow: [
      BoxShadow(
        color: AppColors.primaryGold.withOpacity(0.15),
        blurRadius: 16,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: Image.asset('assets/images/logo_selton.png'),
  ),
)
```

### **Style 2: Fond Transparent + Bordure Dorée**
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(
      color: AppColors.primaryGold,
      width: 2,
    ),
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: Image.asset('assets/images/logo_selton.png'),
  ),
)
```

---

## ✅ Checklist d'Intégration

- [x] Logo copié dans `assets/images/`
- [x] Déclaré dans `pubspec.yaml`
- [x] Intégré dans le **Splash Screen**
- [x] Intégré dans l'**Onboarding** (page 1)
- [x] Intégré dans le **Home Screen** (AppBar)
- [x] Icônes **Android** générées
- [x] Icônes **iOS** générées
- [x] Adaptive icon configurée
- [x] Couleur de fond définie (#F5EFE0)
- [ ] Intégré dans les **AppBars premium** (optionnel)
- [ ] Intégré dans le **Drawer/Menu** (si existant)
- [ ] Intégré dans les **écrans d'erreur** (optionnel)

---

## 🚀 Prochaines Étapes (Optionnel)

### **1. Ajouter le Logo dans les AppBars Premium**

Modifier `luxury_sliver_appbar.dart`, `gradient_sliver_appbar.dart`, et `minimal_sliver_appbar.dart` :

```dart
// Remplacer le logo texte "S" par:
ClipRRect(
  borderRadius: BorderRadius.circular(50),
  child: Image.asset(
    'assets/images/logo_selton.png',
    width: 100,
    height: 100,
    fit: BoxFit.cover,
  ),
)
```

### **2. Ajouter dans le Drawer (Menu Latéral)**

```dart
DrawerHeader(
  decoration: BoxDecoration(
    gradient: AppColors.goldGradient,
  ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: BorderRadius.circular(40),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Image.asset('assets/images/logo_selton.png'),
        ),
      ),
      SizedBox(height: 12),
      Text('SELTON HOTEL', style: TextStyle(color: Colors.white)),
    ],
  ),
)
```

### **3. Ajouter dans les Écrans d'Erreur**

```dart
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Opacity(
        opacity: 0.3,
        child: Image.asset(
          'assets/images/logo_selton.png',
          width: 100,
          height: 100,
        ),
      ),
      SizedBox(height: 24),
      Text('Oups ! Une erreur est survenue'),
    ],
  ),
)
```

---

## 📊 Résumé

Le logo Selton est maintenant **intégré partout** dans l'application :

✅ **Splash Screen** - Premier contact avec l'app  
✅ **Onboarding** - Renforcement du branding  
✅ **Home Screen** - Présence permanente  
✅ **Icônes App** - Android et iOS  

**Le branding est cohérent et professionnel sur toute l'application ! 🎉**
