import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:save_food/providers/food_provider.dart';
import 'package:save_food/providers/user_provider.dart';
import 'package:save_food/utils/stripe_key.dart';

import 'navigation_screen.dart';

class StripePayment {
  Map<String, dynamic>? paymentIntent;

  Future<void> makePayment(context, totalPrice, foodId) async {
    String price = (double.parse(totalPrice) * 100).toInt().toString();
    try {
      paymentIntent = await createPaymentIntent(price, 'AUD');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          googlePay: const PaymentSheetGooglePay(
              testEnv: true, currencyCode: "AUD", merchantCountryCode: "AUS"),
          merchantDisplayName: 'Niraj Shrestha',
        ),
      );
      // Display payment sheet
      await displayPaymentSheet(context, foodId);
    } catch (e) {
      print("Exception during payment: $e");
    }
  }

  Future<void> displayPaymentSheet(context, foodId) async {
    try {
      // Present the payment sheet to the user
      await Stripe.instance.presentPaymentSheet();

      // If payment is successful, update Firestore
      await updateFirestoreAfterPayment(context, foodId);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Paid successfully")),
      );

      // Clear payment intent
      paymentIntent = null;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => NavigationScreen()),
          (route) => false);
    } on StripeException catch (e) {
      print('Stripe Error: $e');
      // Payment was canceled or failed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment Cancelled")),
      );
    } catch (e) {
      print("Error displaying payment sheet: $e");
    }
  }

  Future<void> updateFirestoreAfterPayment(context, foodId) async {
    try {
      // Get the current user information
      final user = Provider.of<UserProvider>(context, listen: false).user;

      // Update Firestore with the user details for the accepted food
      await Provider.of<FoodProvider>(context, listen: false).updateFood(
        context,
        acceptingUserId: user.uuid, // The current user's ID
        acceptingUserName: user.name ?? "", // The current user's name
        foodId: foodId, // The foodId passed from the previous screen
      );
    } catch (e) {
      print("Error updating Firestore: $e");
    }
  }

  Future<Map<String, dynamic>?> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': ((int.parse(amount))).toString(),
        // Stripe expects the amount in cents
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${StripeKey.stripeSecretKey}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      print('Payment Intent Body: ${response.body.toString()}');
      return jsonDecode(response.body.toString());
    } catch (err) {
      print('Error creating Payment Intent: ${err.toString()}');
    }
    return null;
  }
}
