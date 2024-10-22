import 'package:flutter/material.dart';

class CSBM extends StatelessWidget {
  const CSBM({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Chính sách bảo mật',
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
                      '1.GIỚI THIỆU',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                    '1.1 Chào mừng bạn đến với nền tảng ứng dụng di động ShopFigure'
                    'được vận hành bởi B2014566'
                    'ShopFigure nghiêm túc thực hiện trách nhiệm của mình liên quan đến bảo mật thông tin theo các quy định về bảo vệ bí mật thông tin cá nhân của pháp luật Việt Nam (“Luật riêng tư”)'
                    'và cam kết tôn trọng quyền riêng tư và sự quan tâm của tất cả người dùng đối với ứng dụng di động của chúng tôi. Người dùng có nghĩa là người đăng ký tài khoản với chúng tôi để sử dụng các Dịch Vụ,'
                    ' bao gồm cả người mua và người bán (gọi chung và gọi riêng là “Các Người Dùng”, “bạn” hoặc “của bạn”). Chúng tôi nhận biết tầm quan trọng của dữ liệu cá nhân mà bạn đã tin tưởng giao cho chúng tôi '
                    'và tin rằng chúng tôi có trách nhiệm quản lý, bảo vệ và xử lý dữ liệu cá nhân của bạn một cách thích hợp. Chính sách bảo mật này ("Chính sách bảo mật" hay "Chính sách") '
                    'được thiết kế để giúp bạn hiểu được cách thức chúng tôi thu thập, sử dụng, tiết lộ và/hoặc xử lý dữ liệu cá nhân mà bạn đã cung cấp cho chúng tôi và/hoặc lưu giữ về bạn, '
                    'cho dù là hiện nay hoặc trong tương lai, cũng như để giúp bạn đưa ra quyết định sáng suốt trước khi cung cấp cho chúng tôi bất kỳ dữ liệu cá nhân nào của bạn.'),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                    '1.2. "Dữ Liệu Cá Nhân" hay "dữ liệu cá nhân" có nghĩa là dữ liệu, dù đúng hay không, về một cá nhân mà thông qua đó có thể được xác định được danh tính,'
                    ' hoặc từ dữ liệu đó và thông tin khác mà một tổ chức có hoặc có khả năng tiếp cận. Các ví dụ thường gặp về dữ liệu cá nhân có thể gồm có tên,'
                    ' số chứng minh nhân dân và thông tin liên hệ.'),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                    '1.3. Bằng việc sử dụng Các Dịch Vụ, đăng ký một tài khoản với chúng tôi hoặc truy cập Nền tảng, bạn xác nhận và đồng ý rằng bạn chấp nhận các phương pháp, yêu cầu, và/hoặc chính sách được mô tả trong Chính sách bảo mật này,'
                    ' và theo đây bạn xác nhận bạn đã biết rõ và đồng ý toàn bộ cho phép chúng tôi thu thập, sử dụng, tiết lộ và/hoặc xử lý dữ liệu cá nhân của bạn như mô tả trong đây. '
                    'NẾU BẠN KHÔNG ĐỒNG Ý CHO PHÉP XỬ LÝ DỮ LIỆU CÁ NHÂN CỦA BẠN NHƯ MÔ TẢ TRONG CHÍNH SÁCH NÀY, VUI LÒNG KHÔNG SỬ DỤNG CÁC DỊCH VỤ CỦA CHÚNG TÔI HAY TRUY CẬP NỀN TẢNG HOẶC TRANG WEB CỦA CHÚNG TÔI.'
                    ' Nếu chúng tôi thay đổi Chính sách bảo mật của mình, chúng tôi sẽ thông báo cho bạn bao gồm cả thông qua việc đăng tải những thay đổi đó hoặc Chính sách bảo mật sửa đổi trên Nền tảng của chúng tôi.'
                    ' Trong phạm vi pháp luật cho phép, việc tiếp tục sử dụng các Dịch Vụ hoặc Nền Tảng, bao gồm giao dịch của bạn, được xem là bạn đã công nhận và đồng ý với các thay đổi trong Chính Sách Bảo Mật này.'),
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: Text(
                      '2.COOKIES',
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
                    '5.1. Đôi khi chúng tôi hoặc các nhà cung cấp dịch vụ được cho phép và các đối tác quảng cáo của chúng tôi có thể sử dụng "cookie" '
                    'hoặc các tính năng khác để cho phép chúng tôi hoặc các bên thứ ba thu thập hoặc chia sẻ thông tin liên quan đến việc sử dụng của bạn đối với Dịch vụ hoặc Nền tảng của chúng tôi.'
                    ' Các tính năng này sẽ giúp chúng tôi cải thiện Nền tảng và Các Dịch Vụ chúng tôi cung cấp, giúp chúng tôi đề xuất các dịch vụ và tính năng mới, và/hoặc cho phép chúng tôi và các đối tác quảng cáo của chúng tôi cung cấp các nội dung có liên quan hơn đến bạn.'
                    ' "Cookie" là các mã danh định được lưu trữ trên máy tính hoặc thiết bị di động của bạn lưu trữ các dữ liệu về máy tính hoặc thiết bị, bằng cách nào và khi nào Các Dịch Vụ hoặc Nền tảng được sử dụng hay truy cập,'
                    ' bởi bao nhiêu người và để theo dõi những hoạt động trong Các Nền tảng của chúng tôi. Chúng tôi có thể liên kết thông tin cookie với dữ liệu cá nhân. Cookie cũng liên kết với thông tin về những nội dung bạn đã chọn để mua sắm và các trang web mà bạn đã xem. '
                    'Thông tin này được sử dụng để theo dõi giỏ hàng, để chuyển tải nội dung phù hợp với sở thích của bạn, để cho phép các đối tác cung cấp dịch vụ quảng cáo cung cấp dịch vụ quảng cáo trên các trang thông qua mạng Internet và để thực hiện phân tích dữ liệu và hoặc theo dõi việc sử dụng Dịch vụ'),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                    '5.2. Bạn có thể từ chối sử dụng cookie bằng cách chọn các thiết lập thích hợp trên trình duyệt hoặc thiết bị của bạn. Tuy nhiên, vui lòng lưu ý rằng nếu bạn thực hiện thao tác này bạn có thể không sử dụng được các chức năng đầy đủ của Nền tảng hoặc Các Dịch Vụ của chúng tôi.'),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
