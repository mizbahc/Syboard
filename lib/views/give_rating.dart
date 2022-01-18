import 'package:flutter/material.dart';
import 'package:syboard/utils/styles.dart';
import 'package:syboard/utils/color.dart';
import 'package:syboard/models/order.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class GiveRating extends StatefulWidget {
  const GiveRating ({Key? key, required this.order}) : super(key: key);

  final Order order;

  @override
  State<GiveRating> createState() => _GiveRatingState();
}

class _GiveRatingState extends State<GiveRating> {
  num rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/notifications');
              },
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.black54,
                size: 28,
              )),
          const SizedBox(width: 8)
        ],
        title: Row(
          children: [
            const SizedBox(width: 8),
            SizedBox(
                width: 38,
                height: 48,
                child: Image.asset('lib/images/logo_small.png')),
            const SizedBox(width: 8),
            Text(
              'Syboard',
              style: kHeadingTextStyle,
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 2.0,
      ),
      body: Column(
          children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RatingBar(
              minRating: 1,
              initialRating: 1,
              itemCount: 5,
              allowHalfRating: true,
              direction: Axis.horizontal,
              ratingWidget: RatingWidget(
                full:  Icon(Icons.star, color:Colors.yellow.shade700),
                half:  Icon(Icons.star_half,color:Colors.yellow.shade700),
                empty: Icon(Icons.star_border_outlined,color:Colors.yellow.shade700),
              ),
              itemPadding: const EdgeInsets.symmetric(horizontal: 5.0),
              onRatingUpdate: (value) {
                rating = value;
              },
            ),
          ],
        ),
      ]),
    );
  }
}