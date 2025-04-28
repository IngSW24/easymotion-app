import 'package:flutter_dotenv/flutter_dotenv.dart';

final String? apiURL = dotenv.env["API_URL"];
final String? staticURL = dotenv.env["STATIC_URL"];
final String? registerUrl = dotenv.env["REGISTER_URL"];
