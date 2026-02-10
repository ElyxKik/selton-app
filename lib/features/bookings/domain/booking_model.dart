import 'package:cloud_firestore/cloud_firestore.dart';

enum BookingStatus {
  pending,
  confirmed,
  completed,
  cancelled,
}

class BookingModel {
  final String id;
  final String userId;
  final String roomId;
  final String roomName;
  final String roomImage;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int guests;
  final double totalPrice;
  final BookingStatus status;
  final DateTime createdAt;

  BookingModel({
    required this.id,
    required this.userId,
    required this.roomId,
    required this.roomName,
    required this.roomImage,
    required this.checkInDate,
    required this.checkOutDate,
    required this.guests,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  // Factory pour créer depuis Firestore
  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BookingModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      roomId: data['roomId'] ?? '',
      roomName: data['roomName'] ?? '',
      roomImage: data['roomImage'] ?? '',
      checkInDate: (data['checkInDate'] as Timestamp).toDate(),
      checkOutDate: (data['checkOutDate'] as Timestamp).toDate(),
      guests: data['guests'] ?? 1,
      totalPrice: (data['totalPrice'] ?? 0.0).toDouble(),
      status: BookingStatus.values.firstWhere(
        (e) => e.toString().split('.').last == (data['status'] ?? 'pending'),
        orElse: () => BookingStatus.pending,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Conversion vers Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'roomId': roomId,
      'roomName': roomName,
      'roomImage': roomImage,
      'checkInDate': Timestamp.fromDate(checkInDate),
      'checkOutDate': Timestamp.fromDate(checkOutDate),
      'guests': guests,
      'totalPrice': totalPrice,
      'status': status.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
  
  // Helpers
  int get nights => checkOutDate.difference(checkInDate).inDays;
}
