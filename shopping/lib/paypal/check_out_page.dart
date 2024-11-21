import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';
import '../screens/product_list.dart';


class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    // Truy cập Cart từ Provider
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PayPal Checkout",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Center(
        child: TextButton(
          onPressed: () async {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => PaypalCheckout(
                sandboxMode: true,
                clientId: "AVneN727WSZm3ozKvUIxuri_Sx1reD6UI0qhgt5pwWD8mcOsBfHao-mnZMk1SjEd7fzMGJxTXB8jy73A",
                secretKey: "EKcHVh4UxUeEPw6niSKfVo5lSVWbeuxoLG0YGBVQCAYtP7xo7j05sMbMsBjdZ7iFV32CnRv0oJYgaG4T",
                returnURL: "success.snippetcoder.com",
                cancelURL: "cancel.snippetcoder.com",
                transactions: [
                  {
                    "amount": {
                      "total": cart.totalPrice.toString(), // Sử dụng totalPrice
                      "currency": "USD",
                      "details": {
                        "subtotal": cart.totalPrice.toString(), // Sử dụng totalPrice
                        "shipping": '0',
                        "shipping_discount": 0,
                      },
                    },
                    "description": "The payment transaction description.",
                    "item_list": const {
                      "items": [
                        // Bạn có thể lấy danh sách sản phẩm trong giỏ hàng để tạo danh sách items
                      ],
                    },
                  },
                ],
                note: "Contact us for any questions on your order.",
                onSuccess: (Map params) async {
                  print("onSuccess: $params");
                  await cart.clearCart();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Container(
                        height: 30, // Tăng chiều cao của SnackBar
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Order placed successfully!',
                          style: TextStyle(fontSize: 12, color: Colors.white), // Màu chữ trắng
                        ),
                      ),
                      backgroundColor: Colors.green, // Màu nền xanh
                    ),
                  );
                  // Điều hướng đến màn hình ProductListScreen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ProductListScreen()),
                  );
                },
                onError: (error) {
                  print("onError: $error");
                  Navigator.pop(context);
                },
                onCancel: () {
                  print('cancelled:');
                },
              ),
            ));
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(1),
              ),
            ),
          ),
          child: const Text('Checkout'),
        ),
      ),
    );
  }
}