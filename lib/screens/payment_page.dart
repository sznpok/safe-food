import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:save_food/providers/food_provider.dart';
import 'package:save_food/providers/user_provider.dart';

class StripePaymentScreen extends StatefulWidget {
  final String foodId; // Pass the foodId for the payment

  const StripePaymentScreen({Key? key, required this.foodId})
      : super(key: key); // Pass foodId in constructor

  @override
  State<StripePaymentScreen> createState() => _StripePaymentScreenState();
}

class _StripePaymentScreenState extends State<StripePaymentScreen> {
  Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe Payment'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Make Payment'),
          onPressed: () async {
            await makePayment();
          },
        ),
      ),
    );
  }

  Future<void> updateFirestoreAfterPayment() async {
    // Get the current user information
    final user = Provider.of<UserProvider>(context, listen: false).user;

    // Update Firestore with the user details for the accepted food
    await Provider.of<FoodProvider>(context, listen: false).updateFood(
      context,
      acceptingUserId: user.uuid, // The current user's ID
      acceptingUserName: user.name ?? "", // The current user's name
      foodId: widget.foodId, // The foodId passed from the previous screen
    );
  }

  Future<void> makePayment() async {
    try {
      // Create payment intent data
      paymentIntent = await createPaymentIntent('100', 'AUD');
      // initialise the payment sheet setup
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Client secret key from payment data
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          googlePay: const PaymentSheetGooglePay(
              // Currency and country code is accourding to India
              testEnv: true,
              currencyCode: "AUD",
              merchantCountryCode: "AUS"),
          // Merchant Name
          merchantDisplayName: 'Niraj Shrestha',
          // return URl if you want to add
          // returnURL: 'flutterstripe://redirect',
        ),
      );
      // Display payment sheet
      displayPaymentSheet();
      final user = Provider.of<UserProvider>(context, listen: false).user;
      await Provider.of<FoodProvider>(context, listen: false).updateFood(
        context,
        acceptingUserId: user.uuid,
        acceptingUserName: user.name ?? "",
        foodId: widget.foodId
      );
      Navigator.pop(context);
    } catch (e) {
      print("exception $e");

      if (e is StripeConfigException) {
        print("Stripe exception ${e.message}");
      } else {
        print("exception $e");
      }
    }
  }

  displayPaymentSheet() async {
    try {
      // "Display payment sheet";
      await Stripe.instance.presentPaymentSheet();
      // Show when payment is done
      // Displaying snackbar for it
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Paid successfully")),
      );
      paymentIntent = null;
    } on StripeException catch (e) {
      // If any error comes during payment
      // so payment will be cancelled
      print('Error: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(" Payment Cancelled")),
      );
    } catch (e) {
      print("Error in displaying");
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': ((int.parse(amount)) * 100).toString(),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      var secretKey =
          "sk_test_51PvLDUHU1CxQxHA6CtDSlO0WW4vxoQG5m8SC6FLHiUKR6FohvrxrJS43KcZle9qCvAUuUw3Wx4V1TcKW6jl7215d001vXU9zL7";
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      print('Payment Intent Body: ${response.body.toString()}');
      return jsonDecode(response.body.toString());
    } catch (err) {
      print('Error charging user: ${err.toString()}');
    }
  }
}
