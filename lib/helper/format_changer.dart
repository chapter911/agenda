import 'package:intl/intl.dart';

class FormatChanger {
  double koordinat(String input) {
    return double.parse(
      NumberFormat("###.########", "en_US").format(
        double.parse(input),
      ),
    );
  }

  String jam(String input) {
    return DateFormat('HH:mm').format(
      DateFormat('yyyy-MM-dd HH:mm:ss').parse(
        input.toString(),
      ),
    );
  }

  String tanggalAPI(DateTime input) {
    return DateFormat('yyyy-MM-dd').format(
      DateFormat('yyyy-MM-dd').parse(
        input.toString(),
      ),
    );
  }

  String tanggalAPIString(String input) {
    return DateFormat('yyyy-MM-dd')
        .format(DateFormat('dd-MM-yyyy').parse(input))
        .toString();
  }

  String tanggalJamAPIString(String input) {
    return DateFormat('yyyy-MM-dd HH:mm')
        .format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(input))
        .toString();
  }

  String tanggalIndo(DateTime input) {
    return DateFormat('dd-MM-yyyy').format(
      DateFormat('yyyy-MM-dd').parse(
        input.toString(),
      ),
    );
  }

  String tanggalIndoFromString(String input) {
    return DateFormat('dd-MM-yyyy').format(
      DateFormat('yyyy-MM-dd').parse(
        input.toString(),
      ),
    );
  }

  String tanggalJam(DateTime input) {
    return DateFormat('dd-MM-yyyy HH:mm:ss').format(
      DateFormat('yyyy-MM-dd HH:mm:ss').parse(
        input.toString(),
      ),
    );
  }
}
