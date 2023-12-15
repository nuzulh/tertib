import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String parseTimeStamp(Timestamp timeStamp) => DateFormat(
      "EEEE, d MMMM yyyy - HH:mm",
      "id_ID",
    ).format(
      Timestamp(
        timeStamp.seconds,
        timeStamp.nanoseconds,
      ).toDate(),
    );
