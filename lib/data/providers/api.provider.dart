import '../../api-client-generated/schema.swagger.dart';

final baseUrl = Uri.parse('https://api.easymotion.it');

class ApiProvider {
  final Schema schema = Schema.create(baseUrl: baseUrl);
}
