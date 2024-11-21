import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/screens/product_list.dart';

import '../provider/cart_provider.dart';

class PaymentButton extends StatefulWidget {
  @override
  _PaymentButtonState createState() => _PaymentButtonState();
}

class _PaymentButtonState extends State<PaymentButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return ElevatedButton(
      onPressed: () async {
        setState(() {
          _isLoading = true;
        });


        // Thêm độ trễ 2 giây
        await Future.delayed(const Duration(seconds: 1));

        // Giả lập thời gian xử lý đặt hàng
        await cart.clearCart(); // Hàm xử lý đặt hàng

        // Hiển thị thông báo đã đặt hàng thành công
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Container(
              height: 30, // Tăng chiều cao của SnackBar
              alignment: Alignment.centerLeft, // Căn giữa nội dung theo chiều dọc
              child: const Text(
                'Order placed successfully!',
                style: TextStyle(fontSize: 12, color: Colors.white), // Màu chữ trắng
              ),
            ),
            backgroundColor: Colors.green, // Màu nền xanh
          ),
        );
        // Điều hướng đến màn hình ProductListScreen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ProductListScreen()),
              (Route<dynamic> route) => false, // Loại bỏ tất cả các trang trước đó
        );
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Text(
              'Postpaid Payment',
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),
    );
  }
}
