import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('fr')); // Français par défaut

  void setLocale(Locale locale) {
    state = locale;
  }

  void clearLocale() {
    state = const Locale('fr');
  }
}
