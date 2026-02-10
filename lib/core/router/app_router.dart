import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';

import '../../features/splash/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/home/presentation/experience_detail_screen.dart';
import '../../features/rooms/presentation/rooms_list_screen.dart';
import '../../features/rooms/presentation/room_detail_screen.dart';
import '../../features/rooms/presentation/booking_screen.dart';
import '../../features/restaurant/presentation/menu_screen.dart';
import '../../features/restaurant/presentation/cocktails_screen.dart';
import '../../features/restaurant/presentation/table_booking_screen.dart';
import '../../features/services/presentation/services_screen.dart';
import '../../features/shuttle/presentation/shuttle_booking_screen.dart';
import '../../features/halls/presentation/halls_list_screen.dart';
import '../../features/halls/presentation/hall_booking_screen.dart';
import '../../features/payments/presentation/payment_screen.dart';
import '../../features/bookings/presentation/bookings_history_screen.dart';
import '../../features/bookings/presentation/booking_detail_screen.dart';
import '../../features/bookings/presentation/confirmation_success_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/personal_info_screen.dart';
import '../../features/profile/presentation/payment_methods_screen.dart';
import '../../features/profile/presentation/settings_screen.dart';
import '../../features/main/presentation/main_navigation_screen.dart';

/// Provider pour le router de l'application
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(AuthService().authStateChanges),
    redirect: (context, state) {
      final isLoading = authState.isLoading;
      final hasError = authState.hasError;
      final isAuthenticated = authState.value != null;
      
      final isSplash = state.matchedLocation == '/splash';
      
      if (isLoading || hasError) return null;

      final isLoggingIn = state.matchedLocation == '/login' || 
                          state.matchedLocation == '/register' || 
                          state.matchedLocation == '/onboarding' ||
                          state.matchedLocation == '/forgot-password';

      if (!isAuthenticated && !isLoggingIn && !isSplash) {
        return '/login';
      }

      if (isAuthenticated && isLoggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      // Splash Screen
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Onboarding
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      
      // Authentication
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      
      // Main Navigation avec Bottom Nav
      GoRoute(
        path: '/',
        name: 'main',
        builder: (context, state) => const MainNavigationScreen(),
      ),
      
      // Home
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      
      // Experience Detail
      GoRoute(
        path: '/experience-detail',
        name: 'experience-detail',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return ExperienceDetailScreen(
            title: extra['title'] as String,
            subtitle: extra['subtitle'] as String?,
            themeColor: extra['color'] as Color?,
            description: extra['description'] as String,
            price: extra['price'] as String?,
            duration: extra['duration'] as String?,
            imageUrl: extra['imageUrl'] as String?,
            date: extra['date'] as String?,
          );
        },
      ),
      
      // Rooms & Booking
      GoRoute(
        path: '/rooms',
        name: 'rooms',
        builder: (context, state) => const RoomsListScreen(),
      ),
      GoRoute(
        path: '/rooms/:id',
        name: 'room-detail',
        builder: (context, state) {
          final roomId = state.pathParameters['id']!;
          return RoomDetailScreen(roomId: roomId);
        },
      ),
      GoRoute(
        path: '/booking/:roomId',
        name: 'booking',
        builder: (context, state) {
          final roomId = state.pathParameters['roomId']!;
          return BookingScreen(roomId: roomId);
        },
      ),
      
      // Restaurant
      GoRoute(
        path: '/menu',
        name: 'menu',
        builder: (context, state) => const MenuScreen(),
      ),
      GoRoute(
        path: '/table-booking',
        name: 'table-booking',
        builder: (context, state) => const TableBookingScreen(),
      ),
      GoRoute(
        path: '/bar',
        name: 'bar',
        builder: (context, state) => const CocktailsScreen(),
      ),
      
      // Services
      GoRoute(
        path: '/services',
        name: 'services',
        builder: (context, state) => const ServicesScreen(),
      ),
      GoRoute(
        path: '/halls',
        name: 'halls',
        builder: (context, state) => const HallsListScreen(),
      ),
      GoRoute(
        path: '/halls/:id/booking',
        name: 'hall-booking',
        builder: (context, state) {
          final hallId = state.pathParameters['id']!;
          return HallBookingScreen(hallId: hallId);
        },
      ),
      GoRoute(
        path: '/payment/:type/:id',
        name: 'payment',
        builder: (context, state) {
          final type = state.pathParameters['type']!;
          final id = state.pathParameters['id']!;
          return PaymentScreen(bookingType: type, bookingId: id);
        },
      ),
      GoRoute(
        path: '/booking/:type/:id',
        name: 'booking-detail',
        builder: (context, state) {
          final type = state.pathParameters['type']!;
          final id = state.pathParameters['id']!;
          return BookingDetailScreen(bookingType: type, bookingId: id);
        },
      ),
      GoRoute(
        path: '/shuttle',
        name: 'shuttle',
        builder: (context, state) => const ShuttleBookingScreen(),
      ),
      
      GoRoute(
        path: '/booking-success',
        name: 'booking-success',
        builder: (context, state) {
          final email = state.extra as String? ?? 'votre email';
          return ConfirmationSuccessScreen(email: email);
        },
      ),
      
      // Bookings History
      GoRoute(
        path: '/bookings-history',
        name: 'bookings-history',
        builder: (context, state) => const BookingsHistoryScreen(),
      ),
      
      // Profile
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
        routes: [
          GoRoute(
            path: 'info',
            name: 'profile-info',
            builder: (context, state) => const PersonalInfoScreen(),
          ),
          GoRoute(
            path: 'payment',
            name: 'profile-payment',
            builder: (context, state) => const PaymentMethodsScreen(),
          ),
          GoRoute(
            path: 'settings',
            name: 'profile-settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
