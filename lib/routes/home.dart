import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syboard/models/user_obj.dart';
import 'package:syboard/routes/search_results.dart';
import 'package:syboard/services/service.dart';
import 'package:syboard/utils/dimension.dart';
import 'package:syboard/utils/styles.dart';
import 'package:syboard/utils/color.dart';
import 'package:syboard/models/product.dart';
import 'package:syboard/ui/product_preview.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({Key? key, this.analytics, this.observer}) : super(key: key);
  final FirebaseAnalytics? analytics;
  final FirebaseAnalyticsObserver? observer;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //ProductPreview

  TextEditingController searchTextController = TextEditingController();

  Service db = Service();
  List<Product> allProducts = [];

  Future getAllProduct() async {
    List<Product> temp = await db.getProducts();
    print(temp.length);
    setState(() {
      allProducts = temp;
      print(allProducts.length);
    });
    allProducts.forEach((element) {
      print(element.productName.toString() + element.onSale.toString());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllProduct();
  }

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
          IconButton(
              onPressed: () {
                final user = Provider.of<UserObj?>(context, listen: false);
                if (user == null) {
                  Navigator.popAndPushNamed(context, '/login');
                } else {
                  Navigator.pushNamed(context, '/sell_product');
                }
              },
              icon: const Icon(
                Icons.sell_rounded,
                color: AppColors.primary,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 25),
              child: Row(children: [
                /*  TextField(
                      controller: searchTextController,

                    ),*/
                /*IconButton(
                        onPressed: () {
                        },
                        icon: Icon(Icons.search)
                    ),*/
                Expanded(
                    child: Padding(
                        padding: Dimen.regularPadding,
                        child: TextField(
                          controller: searchTextController,
                          decoration: const InputDecoration(
                            hintText: "Search...",
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                          ),
                        ))),
                IconButton(
                    onPressed: () {
                      if (searchTextController.text != "") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchResult(
                                      analytics: widget.analytics,
                                      observer: widget.observer,
                                      searchQuery: searchTextController.text,
                                    )));
                      }
                    },
                    icon: Icon(Icons.search)),
              ]),
            ),
            Text(
              "Top Products",
              style: kTextTitle,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: Dimen.regularPadding,
                child: Row(
                  children: List.generate(
                      allProducts.length,
                      (index) => Row(children: [
                            productPreview(allProducts[index], context),
                            const SizedBox(width: 8)
                          ])),
                ),
              ),
            ),
            Text(
              "Products on Sale",
              style: kTextTitle,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: Dimen.regularPadding,
                child: Row(
                  children: List.generate(
                      allProducts.length,
                      (index) => Row(children: [
                            (allProducts[index].onSale)
                                ? Container(
                                    margin: EdgeInsets.only(right: 8),
                                    child: productPreview(
                                        allProducts[index], context))
                                : Container(),
                          ])),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
