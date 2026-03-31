import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RegisterModule {
  @Named('baseUrl')
  @lazySingleton
  String get baseUrl => dotenv.get('BASE_URL', fallback: 'https://dummyjson.com');
}
