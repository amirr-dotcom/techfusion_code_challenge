import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ThemeBloc extends Cubit<ThemeMode> {
  ThemeBloc() : super(ThemeMode.light);

  void toggleTheme() {
    if (state == ThemeMode.light) {
      emit(ThemeMode.dark);
    } else {
      emit(ThemeMode.light);
    }
  }
  
  void setTheme(ThemeMode mode) => emit(mode);
}
