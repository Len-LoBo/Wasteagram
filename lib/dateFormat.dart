  import 'package:intl/intl.dart';
  
  String dateTimeToString(DateTime dateTime) {
    return DateFormat('EEEE, MMMM d, ' 'yyyy').format(dateTime);
  }