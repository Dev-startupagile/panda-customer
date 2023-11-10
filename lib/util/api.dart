import 'package:flutter_dotenv/flutter_dotenv.dart';

final apiUrl = dotenv.env['BASE_URL'];
final imageUrl = dotenv.env['ImageUrl'];
final googleApi = dotenv.env['GOOGLE_API']!;
