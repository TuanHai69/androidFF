import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/cart.dart';
import '../../models/product.dart';
import '../carts/cart_manager.dart';
import 'comment_card.dart';
import 'product_manager.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() {
      if (_quantity < widget.product.count) {
        _quantity++;
      } else {
        _showMessage('Số lượng không thể vượt quá ${widget.product.count}');
      }
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 0) {
        _quantity--;
      } else {
        _showMessage('Số lượng không thể nhỏ hơn 0');
      }
    });
  }

  Future<void> _addToCart() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null) {
      _showMessage('Không có userId, không thể tiếp tục');
      return;
    }
    final productManager = Provider.of<ProductManager>(context, listen: false);
    final fetchedProduct = await productManager.fetchProduct(widget.product.id);
    if (fetchedProduct == null) {
      _showMessage('Sản phẩm không hợp lệ, vui lòng thử lại sau ít phút');
      return;
    }
    if (fetchedProduct.count <= 0) {
      _showMessage('Sản phẩm ${fetchedProduct.name} không còn hàng');
      return;
    }

    if (_quantity <= 0) {
      _showMessage('Số lượng sản phẩm không thể bằng 0 hoặc nhỏ hơn');
      return;
    }

    final cartManager = Provider.of<CartManager>(context, listen: false);
    await cartManager.fetchCartsByUserIdAndStoreId(
        userId, widget.product.storeid);
    final carts = cartManager.carts;
    final existingCart = carts.firstWhere(
      (cart) => cart.productid == widget.product.id,
      orElse: () => Cart(
        id: "",
        userid: userId,
        productid: widget.product.id,
        count: _quantity,
        note: '',
        discount: 0,
        storeid: widget.product.storeid,
        state: '1',
      ),
    );
    if (existingCart.id == "") {
      await cartManager.addCart(
        Cart(
          id: "",
          userid: userId,
          productid: widget.product.id,
          count: _quantity,
          note: '',
          discount: 0,
          storeid: widget.product.storeid,
          state: '1',
        ),
      );
    } else {
      await cartManager.updateCart(
        existingCart.copyWith(count: existingCart.count + _quantity),
      );
    }
    productManager.updateProduct(
      fetchedProduct.copyWith(count: fetchedProduct.count - _quantity),
    );
    _showMessage('Đã thêm sản phẩm vào giỏ hàng');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: MemoryImage(base64Decode(widget.product.picture)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.blue[50]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.product.discount > 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Giá: ${formatCurrency(widget.product.cost * _quantity)}',
                            style: const TextStyle(
                              fontSize: 18,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                          const Icon(Icons.arrow_forward, color: Colors.red),
                          Text(
                            formatCurrency((widget.product.cost * _quantity -
                                    (widget.product.cost *
                                        _quantity *
                                        widget.product.discount /
                                        100))
                                .toInt()),
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        'Giá: ${formatCurrency(widget.product.cost * _quantity)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Số lượng: ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${widget.product.count}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, color: Colors.red),
                              onPressed: _decrementQuantity,
                            ),
                            SizedBox(
                              width: 50,
                              child: TextField(
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 8.0),
                                ),
                                keyboardType: TextInputType.number,
                                controller: TextEditingController(
                                    text: _quantity.toString()),
                                onChanged: (value) {
                                  int? newQuantity = int.tryParse(value);
                                  if (newQuantity != null &&
                                      newQuantity >= 0 &&
                                      newQuantity <= widget.product.count) {
                                    setState(() {
                                      _quantity = newQuantity;
                                    });
                                  }
                                },
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.green),
                              onPressed: _incrementQuantity,
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.shopping_cart,
                              color: Colors.blue),
                          onPressed: _addToCart,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nguyên liệu: ${widget.product.material}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('Kích thước: ${widget.product.size}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('Mô tả: ${widget.product.description}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('Bảo hành: ${widget.product.warranty}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('Vận chuyển: ${widget.product.delivery}',
                        style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Đánh giá sản phẩm',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            CommentCard(productId: widget.product.id),
          ],
        ),
      ),
    );
  }

  String formatCurrency(int amount) {
    return '${amount.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}₫';
  }
}
