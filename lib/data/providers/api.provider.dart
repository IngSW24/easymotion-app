import 'package:easymotion_app/data/common/constants.dart';
import '../../api-client-generated/schema.swagger.dart';

class ApiProvider {
  static final baseUrl = Uri.parse(API_URL);
  final Schema schema = Schema.create(baseUrl: baseUrl);
}
