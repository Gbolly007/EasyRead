// import 'dart:convert';
//
// import 'package:flutter/services.dart';
// import 'package:stripe_payment/stripe_payment.dart';
// import 'package:http/http.dart' as http;
//
// class StripeTransactionResponse {
//   String message;
//   bool success;
//   StripeTransactionResponse({this.message, this.success});
// }
//
// class StripeService {
//   static String apiBase = "https://api.stripe.com//v1";
//   static String secret = "sk_test_51IhAEBBjziI9vKWJwQSYwG4sOiYYGxsBhWjL9VvuTs6pkXZ2RTiB6sLd42hsaymXcXzGQZNo5zABPRfCwgwOo31o00IkyjDcGP";
//   static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
//
//   static Map<String, String> headers = {
//     'Authorization': 'Bearer ${StripeService.secret}',
//     'Content-Type': 'application/x-www-form-urlencoded'
//   };
//
//   static init() {
//     // StripePayment.setOptions(
//     //   StripeOptions(
//     //     publishableKey: "pk_test_51IhAEBBjziI9vKWJOjSummj3Uah9T1VQT7Lwp62FZxtteLybgyqawBDlT6kaPVJL9qzSN0LakyUAReAsMLBJR46g00fLBZwDAy",
//     //     merchantId: "Test",
//     //     androidPayMode: 'test',
//     //   ),
//     // );
//   }
//
//   static Future<StripeTransactionResponse> payViaExistingCard(
//       {String amount, String currency, CreditCard card}) async {
//     try {
//       var paymentMethod = await StripePayment.createPaymentMethod(
//           PaymentMethodRequest(card: card));
//       var paymentIntent =
//       await StripeService.createPaymentIntent(amount, currency);
//       var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
//           clientSecret: paymentIntent['client_secret'],
//           paymentMethodId: paymentMethod.id));
//       if (response.status == 'succeeded') {
//         return new StripeTransactionResponse(
//             message: 'Transaction successful', success: true);
//       } else {
//         return new StripeTransactionResponse(
//             message: 'Transaction failed', success: false);
//       }
//     } on PlatformException catch (err) {
//       return StripeService.getPlatformExceptionErrorResult(err);
//     } catch (err) {
//       return new StripeTransactionResponse(
//           message: 'Transaction failed: ${err.toString()}', success: false);
//     }
//   }
//
//   static getPlatformExceptionErrorResult(err) {
//     String message = 'Something went wrong';
//     if (err.code == 'cancelled') {
//       message = 'Transaction cancelled';
//     }
//
//     return new StripeTransactionResponse(message: message, success: false);
//   }
//
//   static Future<Map<String, dynamic>> createPaymentIntent(
//       String amount, String currency) async {
//     try {
//       Map<String, dynamic> body = {
//         'amount': amount,
//         'currency': currency,
//         'payment_method_types[]': 'card',
//       };
//
//       var uri = new Uri.https("api.stripe.com", "/v1/payment_intents");
//
//       var response =
//       await http.post(uri, body: body, headers: StripeService.headers);
//       return jsonDecode(response.body);
//     } catch (err) {
//       print('err charging user: ${err.toString()}');
//     }
//     return null;
//   }
// }