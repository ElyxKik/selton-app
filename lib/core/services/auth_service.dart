import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Utilisateur actuel
  User? get currentUser => _auth.currentUser;

  // Stream des changements d'état
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Connexion
  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Inscription
  Future<void> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    // 1. Créer l'utilisateur Auth
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // 2. Créer le document User dans Firestore
    if (credential.user != null) {
      final nameParts = fullName.split(' ');
      final firstName = nameParts.first;
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      await _firestore.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'email': email,
        'fullName': fullName,
        'firstName': firstName,
        'lastName': lastName,
        'role': 'client',
        'memberStatus': 'classic', // Statut par défaut
        'points': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      // Mettre à jour le nom d'affichage Auth
      await credential.user!.updateDisplayName(fullName);
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
