# Schéma Firebase Firestore - Selton Hotel

Ce document décrit la structure de la base de données NoSQL Firestore recommandée pour l'application Selton Hotel.

## Collections Principales

### 1. `users` (Collection)
Stocke les profils utilisateurs.
**ID du document :** UID de l'utilisateur (Firebase Auth).

```json
{
  "uid": "string",
  "email": "string",
  "firstName": "string",
  "lastName": "string",
  "phoneNumber": "string",
  "photoUrl": "string",
  "role": "string",            // "client", "admin"
  "memberStatus": "string",    // "classic", "gold", "platinum"
  "points": 2450,              // number
  "createdAt": "Timestamp",
  "fcmToken": "string",        // Token pour notifications push
  
  // Sous-collection "private_data" (lecture seule pour owner)
  "private_data": {
    "settings": {
      "notificationsEnabled": true,
      "biometricEnabled": true
    }
  }
}
```

### 2. `rooms` (Collection)
Catalogue des chambres.
**ID du document :** Auto-généré ou slug (ex: "suite-royale").

```json
{
  "name": "Suite Royale",
  "description": "Une suite luxueuse...",
  "pricePerNight": 450.00,
  "capacity": 2,
  "size": "65 m²",
  "view": "Vue Panoramique",
  "features": ["Wifi", "Balcon", "Jacuzzi"],
  "images": ["url1", "url2"],
  "isAvailable": true,
  "rating": 4.9
}
```

### 3. `bookings` (Collection)
Réservations de chambres.
**ID du document :** Auto-généré.

```json
{
  "userId": "uid_string",
  "roomId": "room_id_string",
  "roomName": "Suite Royale",  // Dénormalisation pour affichage rapide
  "roomImage": "url_string",
  "checkInDate": "Timestamp",
  "checkOutDate": "Timestamp",
  "guests": 2,
  "totalPrice": 1800.00,
  "status": "confirmed",       // "pending", "confirmed", "cancelled", "completed"
  "createdAt": "Timestamp",
  "paymentId": "stripe_charge_id"
}
```

### 4. `experiences` (Collection)
Services et événements (ex: Dîner, Spa, Navette).

```json
{
  "title": "Dîner Privé",
  "subtitle": "Une soirée inoubliable",
  "description": "Description détaillée...",
  "price": 150.00,
  "duration": "3h",
  "category": "dining",        // "dining", "wellness", "transport"
  "imageUrl": "url_string"
}
```

### 5. `menu_items` (Collection)
Carte du restaurant et bar.

```json
{
  "name": "Selton Gold",
  "description": "Champagne, Liqueur de pêche...",
  "price": 22.00,
  "category": "cocktail",      // "cocktail", "starter", "main", "dessert"
  "isSignature": true,
  "imageUrl": "url_string"
}
```

## Règles de Sécurité (Firestore Rules)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper pour vérifier si user est connecté
    function isSignedIn() {
      return request.auth != null;
    }

    // Users : Lecture/Écriture seulement pour soi-même
    match /users/{userId} {
      allow read, write: if isSignedIn() && request.auth.uid == userId;
    }

    // Rooms : Lecture publique, Écriture Admin seulement
    match /rooms/{roomId} {
      allow read: if true;
      allow write: if false; // À restreindre aux admins
    }

    // Bookings : Création ok, Lecture de ses propres réservations
    match /bookings/{bookingId} {
      allow create: if isSignedIn();
      allow read: if isSignedIn() && resource.data.userId == request.auth.uid;
      allow update: if false; // Changement de statut via Backend/Cloud Function recommandé
    }
  }
}
```
