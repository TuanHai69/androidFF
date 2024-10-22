import 'package:flutter/material.dart';

class CSBH extends StatelessWidget {
  const CSBH({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Chính sách bảo hành',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: Text(
                      '1. ĐIỀU KIỆN BẢO HÀNH:',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Sản phẩm được bảo hành miễn phí nếu sản phẩm đó hội đủ các điều kiện sau:',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('1 Sản phẩm bị lỗi kỹ thuật do nhà sản xuất'),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                    '2 Còn trong thời hạn bảo hành (trên phiếu bảo hành hoặc trên hệ thống bảo hành điện tử)'),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                    '3 Có hóa đơn điện tử (khi Người mua có yêu cầu) hoặc mã đơn hàng (ID đơn hàng)'),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                    '4 Đối với các sản phẩm điện gia dụng, phiếu / tem bảo hành (và tem niêm phong) của nhà sản xuất (tùy từng hãng) trên sản phẩm còn nguyên vẹn.'),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                    '5 Tất cả các trường hợp khách hàng báo lỗi với thông tin chưa rõ ràng hoặc chưa chắc chắn đều phải chuyển cho Trung Tâm Bảo Hành thẩm định trước khi ra quyết định bảo hành hoặc trả hàng.'),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Những trường hợp không được bảo hành hoặc phát sinh phí bảo hành:',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                    '1 Vi phạm một trong những điều kiện bảo hành miễn phí ở mục A.'),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                    '2 Số series, model sản phẩm không hợp lệ (không khớp với thông tin trên Phiếu bảo hành hoặc trên hệ thống bảo hành điện tử)'),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                    '3 Khách hàng tự ý can thiệp sửa chữa sản phẩm hoặc sửa chữa tại những trung tâm bảo hành không được sự ủy nhiệm của Hãng'),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                    '4 Sản phẩm bị hư hỏng do lỗi người sử dụng, và lỗi hư không nằm trong phạm vi bảo hành của nhà sản xuất'),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: Text(
                      '2. THỜI HẠN BẢO HÀNH:',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                    'Thời hạn bảo hành được tính kể từ ngày mua hàng hoặc ngày nhận được sản phẩm, tùy theo từng sản phẩm của từng nhà sản xuất khác nhau.'),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                    'Đối với sản phẩm bảo hành điện tử, thời hạn bảo hành được tính từ thời điểm kích hoạt bảo hành điện tử'),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                    'Lưu ý: Người Mua có thể gửi yêu cầu hóa đơn VAT tới bộ phận Chăm sóc khách hàng để được hỗ trợ '),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
