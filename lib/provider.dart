import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_future/data/postal_code.dart';

StateProvider<String> postalCodeProvider = StateProvider((ref) => '');
FutureProvider<PostalCode> apiProvider = FutureProvider((ref) async {
  final postalCode = ref.watch(postalCodeProvider.notifier).state;
  if (postalCode.length != 7) {
    throw Exception("postal code must be 7 characters");
  }
  final upper = postalCode.substring(0, 3);
  final lower = postalCode.substring(3);

  final apiUrl =
      'https://madefor.github.io/postal-code-api/api/v1/$upper/$lower.json';
  final apiUri = Uri.parse(apiUrl);

  http.Response response = await http.get(apiUri);

  if (response.statusCode != 200) {
    throw Exception("No Postal Code");
  }
  var jsonData = json.decode(response.body);
  return PostalCode.fromJson(jsonData);
});
