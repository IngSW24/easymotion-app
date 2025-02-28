import '../../api-client-generated/schema.swagger.dart';

class ApiProvider {
  static final baseUrl = Uri.parse('https://api.easymotion.it');
  final Schema schema = Schema.create(baseUrl: baseUrl);
}
