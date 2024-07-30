// import 'package:flutter/material.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class OrderPage extends StatefulWidget {
//   @override
//   _OrderPageState createState() => _OrderPageState();
// }

// class _OrderPageState extends State<OrderPage> {
//   late Razorpay _razorpay;
//   late DocumentSnapshot product;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//     _fetchProductDetails();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _razorpay.clear();
//   }

//   Future<void> _fetchProductDetails() async {
//     try {
//       DocumentSnapshot productSnapshot =
//           await _firestore.collection('products').doc('productID').get();
//       setState(() {
//         product = productSnapshot;
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Error fetching product details: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching product details')),
//       );
//     }
//   }

//   void _handlePaymentSuccess(PaymentSuccessResponse response) async {
//     print('Payment success: ${response.paymentId}');
//     User? user = _auth.currentUser;
//     if (user != null) {
//       await _storeOrderDetails(response.paymentId, user.uid);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Payment successful!')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('User not logged in')),
//       );
//     }
//   }

//   void _handlePaymentError(PaymentFailureResponse response) {
//     print('Payment error: ${response.code} - ${response.message}');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Payment failed: ${response.message}')),
//     );
//   }

//   void _handleExternalWallet(ExternalWalletResponse response) {
//     print('External wallet: ${response.walletName}');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//           content: Text('External wallet selected: ${response.walletName}')),
//     );
//   }

//   Future<void> _storeOrderDetails(String paymentId, String userId) async {
//     try {
//       await _firestore.collection('orders').add({
//         'order_id': paymentId,
//         'user_id': userId,
//         'product_id': product.id,
//         'order_name': product['name'],
//         'total_amount': product['price'],
//         'order_date': FieldValue.serverTimestamp(),
//         'status': 'Completed',
//       });
//       print('Order stored in Firestore');
//     } catch (e) {
//       print('Error storing order details: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error storing order details')),
//       );
//     }
//   }

//   void _pay() {
//     var options = {
//       'key': 'YOUR_RAZORPAY_KEY',
//       'amount': product['price'] * 100, // amount in paise
//       'name': 'Acme Corp.',
//       'description': product['description'],
//       'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
//       'external': {
//         'wallets': ['paytm']
//       }
//     };

//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       print('Error opening Razorpay: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error initiating payment')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Order Page'),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Text(
//                     'Order Summary',
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 16),
//                   Card(
//                     elevation: 4,
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Product Name: ${product['name']}',
//                               style: TextStyle(fontSize: 18)),
//                           SizedBox(height: 8),
//                           Text('Price: ₹${product['price']}',
//                               style:
//                                   TextStyle(fontSize: 18, color: Colors.green)),
//                           SizedBox(height: 8),
//                           Text('Description: ${product['description']}',
//                               style: TextStyle(fontSize: 16)),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 32),
//                   ElevatedButton(
//                     onPressed: _pay,
//                     child: Text('Pay Now'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue, // Button color
//                       padding: EdgeInsets.symmetric(vertical: 16),
//                       textStyle: TextStyle(fontSize: 18),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }
