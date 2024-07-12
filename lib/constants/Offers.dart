import 'package:flutter/material.dart';
import 'package:photogenerator/app_ui/custom_images.dart';
import 'package:photogenerator/models/offer.dart';

class Offers {
  static List<Offer> get _offers => [
        Offer(
          id: "free",
          bannerText: null,
          bannerColor: null,
          illustration: CustomPngs.others__free_gain,
          price: 0,
          credits: 1,
          bonus: 0,
        ),
        Offer(
          id: "buy_credits_10",
          bannerText: null,
          bannerColor: null,
          illustration: CustomPngs.others__small_gain,
          price: 1,
          credits: 10,
          bonus: 0,
        ),
        Offer(
          id: "buy_credits_50",
          bannerText: "Populaire",
          bannerColor: Colors.blue[900],
          illustration: CustomPngs.others__medium_gain,
          price: 5,
          credits: 50,
          bonus: 10,
        ),
        Offer(
          id: "buy_credits_200",
          bannerText: "Avantageux",
          bannerColor: Colors.green[800],
          illustration: CustomPngs.others__big_gain,
          price: 20,
          credits: 200,
          bonus: 100,
        ),
      ];

  static Offer get freeOffer => _offers.firstWhere((o) => o.price == 0);
  static List<Offer> get chargedOffers =>
      _offers.where((o) => o.price != 0).toList();
}
