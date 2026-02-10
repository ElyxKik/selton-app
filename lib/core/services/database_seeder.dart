import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseSeeder {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> seedAll() async {
    try {
      await seedRooms();
      await seedServices();
      await seedRestaurantMenu();
      await seedExperiences();
      print('✅ Base de données initialisée avec succès !');
    } catch (e) {
      print('❌ Erreur lors de l\'initialisation : $e');
    }
  }

  // 1. Initialisation des Chambres
  Future<void> seedRooms() async {
    final rooms = [
      {
        'id': 'suite-royale',
        'name': 'Suite Royale',
        'type': 'suite',
        'description': 'Une suite luxueuse avec vue panoramique sur la ville, lit king-size, salle de bain en marbre italien et services premium 24h/24.',
        'pricePerNight': 450,
        'capacity': 2,
        'size': '65 m²',
        'view': 'Vue Panoramique',
        'images': ['assets/images/rooms/royal.jpg'],
        'amenities': ['Vue panoramique', 'Lit King-size', 'Salle de bain marbre', 'Balcon privé', 'Mini-bar', 'Service 24h/24'],
        'isAvailable': true,
        'rating': 4.9,
      },
      {
        'id': 'chambre-deluxe',
        'name': 'Chambre Deluxe',
        'type': 'deluxe',
        'description': 'Chambre élégante avec tout le confort moderne, décoration raffinée et vue sur le jardin.',
        'pricePerNight': 280,
        'capacity': 2,
        'size': '45 m²',
        'view': 'Vue Jardin',
        'images': ['assets/images/rooms/deluxe.jpg'],
        'amenities': ['Vue jardin', 'Lit Queen-size', 'Salle de bain moderne', 'Bureau', 'Coffre-fort', 'WiFi haut débit'],
        'isAvailable': true,
        'rating': 4.7,
      },
      {
        'id': 'suite-presidentielle',
        'name': 'Suite Présidentielle',
        'type': 'suite',
        'description': 'La suite la plus luxueuse de l\'hôtel avec salon séparé, jacuzzi privé et terrasse panoramique.',
        'pricePerNight': 850,
        'capacity': 4,
        'size': '120 m²',
        'view': 'Vue Mer',
        'images': ['assets/images/rooms/presidential.jpg'],
        'amenities': ['Terrasse panoramique', '2 Chambres', 'Jacuzzi privé', 'Salon séparé', 'Cuisine équipée', 'Majordome personnel'],
        'isAvailable': true,
        'rating': 5.0,
      },
    ];

    for (var room in rooms) {
      await _firestore.collection('rooms').doc(room['id'] as String).set(room);
    }
    print(' -> Collection "rooms" créée.');
  }

  // 2. Initialisation des Services
  Future<void> seedServices() async {
    final services = [
      {
        'id': 'spa-wellness',
        'title': 'Spa & Bien-être',
        'category': 'wellness',
        'description': 'Massages, sauna, hammam et soins du visage.',
        'price': 90,
        'duration': '1h',
        'isBookable': true,
      },
      {
        'id': 'navette-vip',
        'title': 'Navette Aéroport',
        'category': 'transport',
        'description': 'Transfert privé en limousine ou van de luxe.',
        'price': 140,
        'duration': 'Aller simple',
        'isBookable': true,
      },
      {
        'id': 'service-etage',
        'title': 'Service en Chambre',
        'category': 'dining',
        'description': 'Carte gastronomique disponible 24h/24.',
        'price': null, // Prix à la carte
        'duration': null,
        'isBookable': false,
      },
    ];

    for (var service in services) {
      await _firestore.collection('services').doc(service['id'] as String).set(service);
    }
    print(' -> Collection "services" créée.');
  }

  // 3. Initialisation du Menu Restaurant
  Future<void> seedRestaurantMenu() async {
    final menu = [
      {
        'name': 'Foie Gras Maison',
        'category': 'starter',
        'description': 'Chutney de figues, brioche toastée',
        'price': 32,
        'isAvailable': true,
      },
      {
        'name': 'Filet de Bœuf Rossini',
        'category': 'main',
        'description': 'Pommes sarladaises, sauce périgourdine',
        'price': 55,
        'isAvailable': true,
      },
      {
        'name': 'Sphère Chocolat Or',
        'category': 'dessert',
        'description': 'Cœur coulant caramel, éclats de noisettes',
        'price': 24,
        'isAvailable': true,
      },
      {
        'name': 'Selton Gold',
        'category': 'cocktail',
        'description': 'Champagne, Liqueur de pêche, Paillettes d\'or',
        'price': 26,
        'isAvailable': true,
        'isSignature': true,
      },
    ];

    for (var item in menu) {
      await _firestore.collection('restaurant_menu').add(item);
    }
    print(' -> Collection "restaurant_menu" créée.');
  }

  // 4. Initialisation des Expériences
  Future<void> seedExperiences() async {
    final experiences = [
      {
        'title': 'Dîner Privé',
        'subtitle': 'Une soirée inoubliable',
        'description': "Profitez d'un dîner gastronomique exclusif dans l'intimité de votre suite.",
        'price': 180,
        'duration': '3h',
        'category': 'dining',
      },
      {
        'title': 'Soirée Jazz',
        'subtitle': 'Au Lounge Bar',
        'description': "Vivez une soirée musicale unique au Lounge Bar avec les meilleurs artistes jazz.",
        'price': 60,
        'duration': 'Soirée',
        'category': 'event',
      },
      {
        'title': 'City Tour',
        'subtitle': 'Découvrez la ville',
        'description': "Partez à la découverte des secrets de la ville avec notre guide expert.",
        'price': 240,
        'duration': '4h',
        'category': 'activity',
      },
    ];

    for (var exp in experiences) {
      await _firestore.collection('experiences').add(exp);
    }
    print(' -> Collection "experiences" créée.');
  }
}
