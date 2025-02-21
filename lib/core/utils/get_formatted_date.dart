import 'package:intl/intl.dart';

String getFormattedDate(DateTime dateTime){
  return DateFormat('yyyy-MM-dd').format(dateTime);
}