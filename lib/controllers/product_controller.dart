import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductController extends GetxController {
  var products = [].obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  void fetchProducts() async {
    final url = Uri.parse('https://dummyjson.com/products');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      products.value = data['products'];
    } else {
      Get.snackbar("Error", "Failed to load products");
    }
  }
}
