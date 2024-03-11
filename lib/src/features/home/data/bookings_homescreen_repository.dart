import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/constants/firestore_constants.dart';
import 'package:naytto/src/features/authentication/domain/app_user.dart';
import 'package:naytto/src/features/home/domain/announcement.dart';
import 'package:naytto/src/features/home/domain/bookings_homescreen.dart';

final apartmentsBookingsProvider = StreamProvider.autoDispose<List<Bookings>>(
  (ref) async* {
    final _firestore = FirebaseFirestore.instance;

    final String housingCooperativeName =
        ref.watch(AppUser().provider).housingCooperative;
    final String apartmentid = ref.watch(AppUser().provider).apartmentId;
    //Used in how many bookings is shown
    final int showbookings = ref.watch(AppUser().provider).bookingsShown;

    yield* _firestore
        .collection(FirestoreCollections.housingCooperative)
        .doc(housingCooperativeName)
        .collection(FirestoreCollections.bookings)
        .where(FirestoreFields.bookingApartmentID, isEqualTo: apartmentid)
        // .where('type', isEqualTo: "sauna")
        // .orderBy('timestamp', descending: true)

        // .snapshots()
        // .map((querySnapshot) => querySnapshot.docs
        //     .map((doc) => Bookings.fromMap(doc.data(), doc.id))
        //     .toList());

        //Chatgpt:s Wild sorting system number II
        //Shows ALL saunas first and then sorts others with timestamp
        .snapshots()
        .map((querySnapshot) {
      final documents = querySnapshot.docs;
      final saunaBookings = <Bookings>[];
      final allBookings = <Bookings>[];

      for (final doc in documents) {
        final booking = Bookings.fromMap(doc.data(), doc.id);
        if (booking.type == "sauna") {
          saunaBookings.add(booking);
        } else {
          allBookings.add(booking);
        }
      }
      saunaBookings.sort((a, b) {
        if (a.timestamp != null && b.timestamp != null) {
          return a.timestamp!.compareTo(b.timestamp!);
        } else {
          return 0;
        }
      });
      allBookings.sort((a, b) {
        if (a.timestamp != null && b.timestamp != null) {
          return a.timestamp!.compareTo(b.timestamp!);
        } else {
          return 0;
        }
      });
      final result = [...saunaBookings, ...allBookings];
      return result.take(showbookings).toList();
    });
  },
);
