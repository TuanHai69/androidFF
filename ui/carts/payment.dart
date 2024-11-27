import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/cart.dart';
import '../../models/comment.dart';
import '../../models/order.dart';
import '../../models/product.dart';
import '../../models/coded.dart';
import '../../models/codeuse.dart';
import '../../services/coded_service.dart';
import '../../services/codeuse_service.dart';
import '../order/order_manager.dart';
import '../products/comment_manager.dart';
import 'cart_manager.dart';

// ignore: must_be_immutable
class PaymentScreen extends StatefulWidget {
  Cart cart;
  final Product product;
  final int totalPrice;

  PaymentScreen({
    super.key,
    required this.cart,
    required this.product,
    required this.totalPrice,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _paymentMethod = 'Trả khi nhận hàng';
  List<Coded> availableCodes = [];
  int discountPercent = 0;
  int finalPrice = 0;
  CodedService codedService = CodedService();
  CodeUseService codeUseService = CodeUseService();
  Coded? selectedCoded;
  OrderManager orderManager = OrderManager();
  Order? currentOrder;

  @override
  void initState() {
    super.initState();
    finalPrice = widget.totalPrice * widget.cart.count;
    fetchAvailableCodes();
    checkAndCreateOrder();
  }

  Future<void> checkAndCreateOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userId = prefs.getString('userId');
    String storeId = widget.cart.storeid;

    if (userId != null) {
      await orderManager.fetchOrdersByUserIdAndStoreId(userId, storeId);
      List<Order> userOrders = orderManager.orders;
      List<Order> pendingOrders =
          userOrders.where((order) => order.state == 'Chờ xác nhận').toList();
      if (pendingOrders.isEmpty) {
        Order newOrder = Order(
          id: '',
          userid: userId,
          storeid: storeId,
          date: DateTime.now(),
          state: 'Chờ xác nhận',
          price: 0,
        );
        await orderManager.addOrder(newOrder);
        await orderManager.fetchOrdersByUserIdAndStoreId(userId, storeId);
        pendingOrders = orderManager.orders
            .where((order) => order.state == 'Chờ xác nhận')
            .toList();
      }
      setState(() {
        currentOrder = pendingOrders.first;
      });
    }
  }

  Future<void> fetchAvailableCodes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if (userId != null) {
      List<Coded> allCodes = await codedService.fetchAllCodeds();
      List<CodeUse> codeUses = await codeUseService.fetchCodeUsesByUser(userId);
      DateTime now = DateTime.now();
      allCodes = allCodes.where((code) {
        return now.isAfter(code.start) && now.isBefore(code.end);
      }).toList();
      List<String> usedCodeIds = codeUses.map((use) => use.codeid).toList();
      setState(() {
        availableCodes =
            allCodes.where((code) => !usedCodeIds.contains(code.id)).toList();
      });
    }
  }

  void onCodeSelected(Coded? code) {
    setState(() {
      selectedCoded = code;
      if (code != null) {
        discountPercent = code.percent;
        finalPrice = (widget.totalPrice *
                widget.cart.count *
                (1 - discountPercent / 100))
            .toInt();
      } else {
        discountPercent = 0;
        finalPrice = widget.totalPrice * widget.cart.count;
      }
    });
  }

  void saveDiscount() {
    double productDiscount = (widget.product.discount.toDouble());
    double codeDiscount = (selectedCoded?.percent.toDouble() ?? 0.0);

    if (productDiscount > 0 && codeDiscount > 0) {
      widget.cart.discount = (productDiscount + codeDiscount) -
          (productDiscount * codeDiscount / 100);
    } else if (productDiscount > 0) {
      widget.cart.discount = productDiscount;
    } else if (codeDiscount > 0) {
      widget.cart.discount = codeDiscount;
    } else {
      widget.cart.discount = 0.0;
    }
  }

  void _confirmPayment() async {
    // Kiểm tra xem người dùng đã nhập địa chỉ giao hàng và số điện thoại người nhận chưa
    if (_addressController.text.isEmpty ||
        _phoneNumberController.text.isEmpty) {
      // Hiển thị thông báo lỗi nếu thiếu thông tin
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Vui lòng nhập địa chỉ giao hàng và số điện thoại người nhận')),
      );
      return;
    }

    // Tiếp tục xử lý nếu người dùng chọn "Trả khi nhận hàng"
    if (_paymentMethod == 'Trả khi nhận hàng') {
      saveDiscount();
      // Cập nhật thông tin cart
      widget.cart = widget.cart.copyWith(
        payment: _paymentMethod,
        note: _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : "",
        discount: widget.cart.discount,
        phonenumber: _phoneNumberController.text,
        address: _addressController.text,
        day: DateTime.now().toIso8601String(),
        orderid: currentOrder?.id,
        state: "done",
      );
      // Cập nhật trạng thái và thông tin order
      Order updatedOrder = currentOrder!.copyWith(
        state: 'Chờ xác nhận',
        date: DateTime.now(),
        price: currentOrder!.price + finalPrice,
      );
      final cartManager = Provider.of<CartManager>(context, listen: false);
      await cartManager.updateCart(widget.cart);
      // Gọi dịch vụ cập nhật cart và order
      await orderManager.updateOrder(updatedOrder);
      CommentManager commentManager = CommentManager();
      await commentManager.fetchCommentsByUser(widget.cart.userid);
      List<Comment> userComments = commentManager.comments;
      if (userComments.isEmpty) {
        // Tạo mới comment nếu không có comment nào
        Comment newComment = Comment(
          id: "",
          userid: widget.cart.userid,
          productid: widget.product.id,
          rate: 0,
          comment: "",
          state: "",
          islike: false,
        );
        await commentManager.addComment(newComment);
      } else {
        // Lọc comment và kiểm tra
        Comment? existingComment = userComments.firstWhereOrNull(
            (comment) => comment.productid == widget.product.id);
        if (existingComment == null) {
          // Tạo mới comment nếu không có comment nào cho productid
          Comment newComment = Comment(
            id: "",
            userid: widget.cart.userid,
            productid: widget.product.id,
            rate: 0,
            comment: "",
            state: "",
            islike: false,
          );
          await commentManager.addComment(newComment);
        } else if (existingComment.state == "Nopay") {
          // Cập nhật comment nếu state là "Nopay"
          Comment updatedComment = existingComment.copyWith(state: "");
          await commentManager.updateComment(updatedComment);
        }
      }

      if (selectedCoded != null) {
        // Lấy userId từ SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userId = prefs.getString('userId'); // Tạo mới CodeUse
        CodeUse newCodeUse = CodeUse(
          id: "",
          userid: userId!,
          codeid: selectedCoded!.id,
          day: DateTime.now(),
        ); // Thêm mới CodeUse
        CodeUseService codeUseService = CodeUseService();
        await codeUseService.addCodeUse(newCodeUse);
      }
      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Xác nhận thanh toán thành công')),
      );

      // Điều hướng người dùng tới trang xác nhận hoặc trang khác (tùy chọn)
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hiển thị thông tin giỏ hàng
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 4,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image:
                              MemoryImage(base64Decode(widget.product.picture)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 4,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 2 / 3,
                        child: Text(
                          widget.product.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      right: MediaQuery.of(context).size.width / 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Giá: ${formatCurrency(widget.totalPrice)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Số lượng: ${widget.cart.count}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Tổng tiền: ${formatCurrency(finalPrice)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (selectedCoded != null) ...[
                      const SizedBox(height: 5),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'Đã giảm: ${discountPercent.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Form thanh toán
              DropdownButtonFormField<Coded>(
                value: selectedCoded,
                decoration: InputDecoration(
                  labelText: 'Mã giảm giá',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: [
                  const DropdownMenuItem<Coded>(
                    value: null,
                    child: Text('Không dùng mã giảm giá'),
                  ),
                  ...availableCodes.map((code) => DropdownMenuItem<Coded>(
                        value: code,
                        child: Text('${code.code} giảm ${code.percent}%'),
                      )),
                ],
                onChanged: onCodeSelected,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _paymentMethod,
                decoration: InputDecoration(
                  labelText: 'Phương thức thanh toán',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: ['Trả khi nhận hàng']
                    .map((method) => DropdownMenuItem(
                          value: method,
                          child: Text(method),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Địa chỉ giao hàng',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Số điện thoại người nhận',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Mô tả',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _confirmPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Xác nhận',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatCurrency(int amount) {
    return '${amount.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}₫';
  }
}
