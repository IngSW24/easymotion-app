import 'package:intl/intl.dart';

String datetime2local(DateTime dateTime) {
  return DateFormat.yMd().add_Hms().format(dateTime);
}
