
import 'package:shared_preferences/shared_preferences.dart';
import '../model/cart_model.dart';
import '../service/db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CartProvider with ChangeNotifier{

  DBHelper db = DBHelper() ;
  int _counter = 0 ;
  int get counter => _counter;

  double _totalPrice = 0.0 ;
  double get totalPrice => _totalPrice;

  double get totalAmount => _totalPrice;

  late Future<List<Cart>> _cart ;
  Future<List<Cart>> get cart => _cart ;

  Future<List<Cart>> getData () async {
    _cart = db.getCartList();
    return _cart ;
  }


  // Phương thức để xóa toàn bộ giỏ hàng
  Future<void> clearCart() async {
    await db.clearCart(); // Xóa dữ liệu trong cơ sở dữ liệu
    _counter = 0; // Đặt lại số lượng
    _totalPrice = 0.0; // Đặt lại tổng giá
    _setPrefItems();
    notifyListeners(); // Thông báo rằng có sự thay đổi // Thông báo rằng có sự thay đổi
  }

  void _setPrefItems()async{
    SharedPreferences prefs = await SharedPreferences.getInstance() ;
    prefs.setInt('cart_item', _counter);
    prefs.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

  void _getPrefItems()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_item') ?? 0;
    _totalPrice = prefs.getDouble('total_price') ?? 0.0;

    if (_counter < 0) {
      _counter = 0;
      _setPrefItems(); // Cập nhật lại giá trị vào SharedPreferences
    }
    notifyListeners();
  }


  void addTotalPrice (double productPrice){
    _totalPrice = _totalPrice +productPrice ;
    _setPrefItems();
    notifyListeners();
  }

  void removeTotalPrice (double productPrice){
    _totalPrice = _totalPrice  - productPrice ;
    _setPrefItems();
    notifyListeners();
  }

  double getTotalPrice (){
    _getPrefItems();
    return  _totalPrice ;
  }


  void addCounter (){
    _counter++;
    _setPrefItems();
    notifyListeners();
  }

  void removerCounter (){
    if (_counter > 0) {
      _counter--;
      _setPrefItems();
      notifyListeners();
    }
  }

  int getCounter (){
    _getPrefItems();
    return  _counter ;

  }
}
