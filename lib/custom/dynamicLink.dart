import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_ecommerce/screen/produk/produkDetailApi.dart';

class DynamicLinkService {
  Future handleDynamicLink(BuildContext context) async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    handleDeepLink(context, data);
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      handleDeepLink(context, dynamicLink);
    }, onError: (OnLinkErrorException e) async {
      print("Link Failed : ${e.message}");
    });
  }

  void handleDeepLink(BuildContext context, PendingDynamicLinkData data) {
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      print("_handleDeepLink | DeepLink = $deepLink");

      var post = deepLink.pathSegments.contains("getProdukDetail.php");
      if (post) {
        var idProduk = deepLink.queryParameters['idProduk'];
        print(idProduk);
        if (idProduk != null) {
          Route route = MaterialPageRoute(
              builder: (context) => ProdukDetailApi(idProduk));

          Navigator.push(context, route);
        }
      }
    }
  }

  Future<Uri> createdShareLink(String idProduk) async {
    final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
      uriPrefix:
          'https://ecommercewn.page.link', // uriPrefix berdasarkan suggestion pada saat membuat dynamic link pada firebase
      link: Uri.parse(
          'http://192.168.43.3/ecommerce/api/produk/getProdukDetail.php?idProduk=$idProduk'),
      androidParameters:
          AndroidParameters(packageName: 'com.ecommercecc.android'),
    );
    final link = await dynamicLinkParameters.buildUrl();
    final ShortDynamicLink shortDynamicLink =
        await DynamicLinkParameters.shortenUrl(
            link,
            DynamicLinkParametersOptions(
              shortDynamicLinkPathLength:
                  ShortDynamicLinkPathLength.unguessable,
            ));
    return shortDynamicLink.shortUrl;
  }
}
