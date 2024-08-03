<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký nhà bán</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>
    <link rel="stylesheet" href="/site/upload/dang-ky-nha-ban/static/css/seller-register.css">
</head>
<body>
    <div id="sr--top"></div>
    <!-- Navbar -->
    <nav class="sr--navbar navbar navbar-expand-md bg-white navbar-light">
        <div class="container-fluid">
          <a class="navbar-brand pr-md-4" href="#">
            <img class="sr--logo" src="/site/upload/dang-ky-nha-ban/static/img/sr--logo.png" alt="Đại Sàn">
        </a>
      
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#sr--navbar">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="sr--navbar">
            <ul class="navbar-nav">
                <li class="nav-item mr-md-4">
                    <a class="nav-link text-dark" href="#" data-type="sr--move" data-target="#sr--top">Nền tảng</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-dark" href="#" data-type="sr--move" data-target="#sr--customer">Câu chuyện thành công</a>
                </li>
            </ul>
            </div>
        
            <a class="btn btn-primary d-none d-md-block rounded-pill sr--bg-primary px-4" href="#" data-type="sr--move" data-target="#sr--top">Bắt đầu bán hàng</a>
        </div>
    </nav>
    <!-- Hero - Register Form -->
    <div class="sr--hero">
        <div class="sr--hero-mask"></div>
        <div class="sr--hero-container d-md-flex">
            <div class="sr--hero-left sr--col-md-1_2">
                <h1>
                    Bán Hàng Trực Tuyến Trên Daisan.vn
                </h1>
                <ul class="pl-4 pl-md-5">
                    <li>Hơn 40 triệu khách hàng đang hoạt động</li>
                    <li>Hoa hồng bán hàng cao lên tới 30%</li>
                    <li>Hướng dẫn trực tiếp từ chuyên gia địa phương</li>
                </ul>
                <p>
                    Tiếp cận hàng triệu khách hàng B2B để nắm bắt cơ hội kinh doanh trên khắp thế giới
                </p>
            </div>
            <div class="sr--hero-right sr--col-md-1_2">
                <div class="sr--hero-right-mask"></div>
                <div class="sr--hero-form">
                    <div class="sr--hero-form-subtitle pb-4">
                        Cho chúng tôi biết một số thông tin về doanh nghiệp của bạn để tư vấn viên của chúng tôi liên hệ với bạn trong vòng 24 giờ
                    </div>
                    <div class="row no-gutters">
                        <div class="col-6 pr-2">
                            <div class="form-group">
                                <label for="sr--form-firstname"><small>Tên</small></label>
                                <input type="text" class="form-control" id="sr--form-firstname" placeholder="">
                                <small class="sr--error mt-1 text-danger d-none"></small>
                            </div>
                        </div>
                        <div class="col-6 pl-2">
                            <div class="form-group">
                                <label for="sr--form-lastname"><small>Họ</small></label>
                                <input type="text" class="form-control" id="sr--form-lastname" placeholder="">
                                <small class="sr--error mt-1 text-danger d-none"></small>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="sr--form-email"><small>Email</small></label>
                        <input type="email" class="form-control" id="sr--form-email" placeholder="">
                        <small class="sr--error mt-1 text-danger d-none"></small>
                    </div>
                    <div class="form-group">
                        <label for="sr--form-phone"><small>Số điện thoại</small></label>
                        <input type="text" class="form-control" id="sr--form-phone" placeholder="">
                        <small class="sr--error mt-1 text-danger d-none"></small>
                    </div>
                    <div class="form-group">
                        <label for="sr--form-company"><small>Tên công ty</small></label>
                        <input type="text" class="form-control" id="sr--form-company" placeholder="">
                        <small class="sr--error mt-1 text-danger d-none"></small>
                    </div>
                    
                    <div class="pt-2 pb-4 pb-md-0">
                        <button class="sr--btn-signup btn btn-outline-primary rounded-pill text-white border-white w-100">Tham gia ngay</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Model Register -->
    <div class="modal fade" id="sr--signup-success" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
        <div class="modal-header">
            <h5 class="modal-title">Đăng ký thành công</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
            </button>
        </div>
        <div class="modal-body">
            Thông tin đăng ký của bạn đã được gửi đến hệ thống, chúng tôi sẽ liên hệ lại bạn để xác nhận!
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
        </div>
        </div>
    </div>
    </div>

    <!-- About -->
    <div class="sr--about sr--bg pt-5 pb-5">
        <div class="container">
            <h2 class="text-center">
                Daisan.vn là nền tảng thương mại điện tử B2B quốc tế hỗ trợ doanh nghiệp Việt Nam xuất khẩu trực tuyến trên toàn cầu
            </h2>
        </div>
    </div>
    <!-- Service -->
    <div class="sr--service sr--bg pb-2 pb-md-5 border-bottom">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <div class="sr--reponsive-frame mb-4 mb-md-0">
                        <iframe src="https://www.youtube.com/embed/1AZhUn_qrKU" title="[DAISAN.VN] - Sàn TMĐT B2B" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
                    </div>
                </div>
                <div class="col-md-6">
                    <p>
                        Gói “Định hướng” – hỗ trợ các doanh nghiệp mới bao gồm Dịch Vụ 90 Ngày hỗ trợ gia nhập sàn thương mại và Các Dịch Vụ Cộng Thêm
                    </p>
                    <p>
                        Gói “Tăng tốc” - ứng dụng các giải pháp công nghệ bao gồm Giải Pháp Marketing Thông Minh và Các Công Cụ Quản Lý Kỹ Thuật Số
                    </p>
                    <p>
                        Gói “Phát triển năng lực” – thiết kế riêng cho SMEs Việt Nam, bao gồm Lộ trình “Xuất Khẩu Thành Công” , Khóa học online “Cùng Đồng Hành” và Các khóa đào tạo chuyên môn xuất khẩu
                    </p>
                </div>
            </div>
        </div>
    </div>

    <!-- Business Step -->
    <div class="sr--business mb-4 mb-md-5">
        <div class="container">
            <h2 class="text-center pt-5 pb-4 pb-md-5 sr--heading">4 Bước Để Mở Rộng Kinh Doanh Cùng Daisan.vn</h2>
            <div class="row">
                <div class="col-md-3">
                    <div class="sr--step pl-4 border-left">
                        <div class="row">
                            <div class="col-6 col-md-12">
                                <div class="sr--item-link sr--pointer py-2 py-md-3 sr--active">
                                    Bước 1: Tạo minisite
                                </div>
                            </div>
                            <div class="col-6 col-md-12">
                                <div class="sr--item-link sr--pointer py-2 py-md-3">
                                    Bước 2: Quảng cáo
                                </div>
                            </div>
                            <div class="col-6 col-md-12">
                                <div class="sr--item-link sr--pointer py-2 py-md-3">
                                    Bước 3: Phân tích dữ liệu
                                </div>
                            </div>
                            <div class="col-6 col-md-12">
                                <div class="sr--item-link sr--pointer py-2 py-md-3">
                                    Bước 4: Dịch vụ riêng
                                </div>
                            </div>
                        </div>
                    </div>
                    
                </div>
                <div class="col-md-9 pt-4 pt-md-0">
                    <div class="row align-items-center sr--body">
                        <div class="col-md-5">
                            <h3 class="pb-2">
                                Thiết lập cửa hàng giới thiệu thương hiệu của bạn.
                            </h3>
                            <p class="pb-2">
                                Hãy tạo sự khác biệt với đối thủ cạnh tranh bằng một cửa hàng đầy đủ dành riêng cho sản phẩm của bạn - không cần kỹ năng thiết kế hoặc lập trình!
                            </p>
                            <div class="pb-2">
                                <a href="#" class="btn btn-primary sr--bg-primary px-4 rounded-pill">Tìm hiểu thêm</a>
                            </div>
                        </div>
                        <div class="col-md-7">
                            <div>
                                <img class="img-fluid" src="https://s.alicdn.com/@img/tfs/TB1O3ROHND1gK0jSZFyXXciOVXa-1818-1440.png" alt="">
                            </div>
                        </div>
                    </div>
                    <div class="row align-items-center sr--body d-none">
                        <div class="col-md-5">
                            <h3 class="pb-2">
                                Tiết kiệm ngân sách và tăng mức độ hiển thị lên tới 120% bằng một bộ công cụ quảng cáo thông minh.
                            </h3>
                            <p class="pb-2">
                                Từ các báo cáo hệ thống, khách hàng thực hiện quảng cáo từ khóa (KWA) đã đạt được kết quả chuyển đổi tốt hơn so với các doanh nghiệp không sử dụng.
                            </p>
                            <div class="pb-2">
                                <a href="#" class="btn btn-primary sr--bg-primary px-4 rounded-pill">Tìm hiểu thêm</a>
                            </div>
                        </div>
                        <div class="col-md-7">
                            <div>
                                <img class="img-fluid" src="https://s.alicdn.com/@img/tfs/TB11cBPHKH2gK0jSZJnXXaT1FXa-1818-1440.png" alt="">
                            </div>
                        </div>
                    </div>
                    <div class="row align-items-center sr--body d-none">
                        <div class="col-md-5">
                            <h3 class="pb-2">
                                Tối ưu hóa mọi hoạt động của bạn bằng dữ liệu chuyên sâu và thông tin chi tiết về khách hàng.
                            </h3>
                            <p class="pb-2">
                                Cải thiện hiệu suất với bảng điều khiển cung cấp thông tin chi tiết về mức độ hiển thị sản phẩm, số lượt click, mức chi tiêu, chi phí trung bình, lượt ghé thăm cửa hàng và nhiều thông tin khác.
                            </p>
                            <div class="pb-2">
                                <a href="#" class="btn btn-primary sr--bg-primary px-4 rounded-pill">Tìm hiểu thêm</a>
                            </div>
                        </div>
                        <div class="col-md-7">
                            <div>
                                <img class="img-fluid" src="https://s.alicdn.com/@img/tfs/TB1zMBKHSf2gK0jSZFPXXXsopXa-1818-1440.png" alt="">
                            </div>
                        </div>
                    </div>
                    <div class="row align-items-center sr--body d-none">
                        <div class="col-md-5">
                            <h3 class="pb-2">
                                Daisan.vn đồng hành cùng doanh nghiệp Việt Nam vươn ra biển lớn
                            </h3>
                            <p class="pb-2">
                                Daisan.vn tạo mọi điều kiện để doanh nghiệp cải thiện khả năng và kỹ năng thương mại điện tử nhằm hướng đến sự tăng trưởng bền vững.
                            </p>
                            <div class="pb-2">
                                <a href="#" class="btn btn-primary sr--bg-primary px-4 rounded-pill">Tìm hiểu thêm</a>
                            </div>
                        </div>
                        <div class="col-md-7">
                            <div>
                                <img class="img-fluid" src="https://s.alicdn.com/@img/imgextra/i2/O1CN01mMsvlQ26b22ASFS6V_!!6000000007679-0-tps-3789-3001.jpg" alt="">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Customer -->
    <div id="sr--customer" class="sr--customer sr--bg pt-4 pt-md-5 pb-3 pb-md-5">
        <div class="container">
            <h2 class="sr--heading text-center pb-4 pb-md-5">
                Lắng nghe từ những người bán hàng thành công trên Daisan.vn
            </h2>
            <div class="sr--customer-slider">
                <div>
                    <div class="row no-gutters bg-white">
                        <div class="col-md-8 order-md-2">
                            <img class="img-fluid" src="https://s.alicdn.com/@img/imgextra/i2/O1CN01bqgmID1EW0R9q9qaU_!!6000000000358-0-tps-2501-1999.jpg" alt="">
                        </div>
                        <div class="col-md-4 d-flex flex-column px-3 pt-2 pb-4 px-md-4 py-md-4 order-md-1">
                            <div class="d-flex align-items-center pb-3">
                                <div class="sr--quote mr-3 mt-2">
                                    <img src="/site/upload/dang-ky-nha-ban/static/img/sr--quote.png" alt="">
                                </div>
                                <span class="sr--num">1/2</span>
                            </div>
                            <p>
                                Bằng cách hoạt động trên Daisan.vn, chúng tôi tự hào với tổng doanh thu hằng năm từ 10 đến 50 triệu USD.
                            </p>
                            <div class="pb-4">
                                <a href="#" class="sr--text-primary font-weight-bold">Đọc thêm &gt;</a>
                            </div>
                            <div class="mt-auto">
                                <div class="d-flex pb-2">
                                    <img class="rounded-circle border shadow mr-2" style="width: 40px; height: 40px;" src="https://s.alicdn.com/@sc01/kf/Hc35dc5629b274fe497498857ef9ef0aaC.png" alt="">
                                    <div>
                                        <div class="font-weight-bold">Phan Đức</div>
                                        <small>Quản lý xuất khẩu</small>
                                    </div>
                                </div>
                                <div class="d-flex align-items-center">
                                    <img style="width: 18px; height: 18px; margin-top: 3px;" class="mr-2" src="/site/upload/dang-ky-nha-ban/static/img/sr--vietnam.png" alt="">
                                    <span>Công ty TMCP Đại Sàn</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div>
                    <div class="row no-gutters bg-white">
                        <div class="col-md-8 order-md-2">
                            <img class="img-fluid" src="https://s.alicdn.com/@img/imgextra/i1/O1CN01D1QT6a1X2fluCZ4IY_!!6000000002866-0-tps-1201-960.jpg" alt="">
                        </div>
                        <div class="col-md-4 d-flex flex-column px-3 pt-2 pb-4 px-md-4 py-md-4 order-md-1">
                            <div class="d-flex align-items-center pb-3">
                                <div class="sr--quote mr-3 mt-2">
                                    <img src="/site/upload/dang-ky-nha-ban/static/img/sr--quote.png" alt="">
                                </div>
                                <span class="sr--num">2/2</span>
                            </div>
                            <p>
                                Chúng tôi quyết định đồng hành cùng Daisan.vn ngay khi thành lập vào năm 2006, hiện nay thị trường xuất khẩu của chúng tôi khá đa dạng, tập trung nhiều tại khu vực Tây Âu, Nam Mĩ, Trung Á...
                            </p>
                            <div class="pb-4">
                                <a href="#" class="sr--text-primary font-weight-bold">Đọc thêm &gt;</a>
                            </div>
                            <div class="mt-auto">
                                <div class="d-flex pb-2">
                                    <img class="rounded-circle border shadow mr-2" style="width: 40px; height: 40px;" src="https://s.alicdn.com/@sc01/kf/H5b4eea2f4f7a4cbeb1b242d92f11ebd90.png" alt="">
                                    <div>
                                        <div class="font-weight-bold">Bùi Thị Hậu</div>
                                        <small>Giám đốc</small>
                                    </div>
                                </div>
                                <div class="d-flex align-items-center">
                                    <img style="width: 18px; height: 18px; margin-top: 3px;" class="mr-2" src="/site/upload/dang-ky-nha-ban/static/img/sr--vietnam.png" alt="">
                                    <span>Công ty TMCP Nam Việt</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- News -->
    <div class="sr--news pt-4 pt-md-5 pb-4">
        <div class="container">
            <h2 class="sr--heading text-center pb-4 pb-md-5">
                Những trang báo nổi bật đang nói về Daisan.vn
            </h2>
            <div class="row">
                <div class="col-md-4 mb-4">
                    <div class="rounded-lg overflow-hidden shadow-lg">
                        <a href="#">
                            <img class="img-fluid" src="https://img.alicdn.com/imgextra/i4/O1CN013rEn591Rx6sZUQX0t_!!6000000002177-0-tps-1668-1111.jpg" alt="">
                            <p class="sr--news-link px-3 pt-3 pb-2 text-dark">
                                Daisan.vn hỗ trợ doanh nghiệp vừa và nhỏ Việt Nam liên doanh ở nước ngoài và tiếp cận một lượng lớn khách hàng trên toàn cầu.
                            </p>
                        </a>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="rounded-lg overflow-hidden shadow-lg">
                        <a href="#">
                            <img class="img-fluid" src="https://img.alicdn.com/imgextra/i4/O1CN01LwAshr1xS1hfZ4syM_!!6000000006441-0-tps-1667-1111.jpg" alt="">
                            <p class="sr--news-link px-3 pt-3 pb-2 text-dark">
                                Dự án “Sprout Up” nhằm giúp các doanh nghiệp vừa và nhỏ tạo ra các mô hình kinh doanh bền vững thông qua các giải pháp kỹ thuật số trong giai đoạn Covid-19
                            </p>
                        </a>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="rounded-lg overflow-hidden shadow-lg">
                        <a href="#">
                            <img class="img-fluid" src="https://img.alicdn.com/imgextra/i1/O1CN01MU0qfx1ENlJ61iWnV_!!6000000000340-0-tps-1667-1111.jpg" alt="">
                            <p class="sr--news-link px-3 pt-3 pb-2 text-dark">
                                “100 Nhà Xuất Khẩu Tài Ba” là dự án tìm kiếm những doanh nghiệp hàng đầu trở thành giảng viên của Daisan.vn để truyền cảm hứng cho những doanh nghiệp SME với nhiều lợi ích độc quyền.
                            </p>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Ready -->
    <div class="sr--ready">
        <div class="container">
            <h2 class="text-center pb-4">
                Sẵn sàng để phát triển doanh nghiệp của bạn?
            </h2>
            <div class="d-md-flex justify-content-center text-center">
                <a href="#" data-type="sr--move" data-target="#sr--top" class="mr-md-2 mb-3 btn btn-outline-primary rounded-pill text-white border-white px-4">
                    Bắt đầu bán
                </a>
                <a href="#" class="ml-md-2 mb-3 btn btn-primary rounded-pill bg-white sr--text-primary px-4">
                    Trò chuyện với tư vấn viên
                </a>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="pt-5 pb-3">
        <div class="container text-center text-secondary">
            <div class="footer-link">
                <a class="text-dark" target="_blank" href="https://daisan.vn">Daisan.vn</a> | 
                <a class="text-dark" target="_blank" href="https://books.daisan.vn">Daisan Books</a> | 
                <a class="text-dark" target="_blank" href="https://daisantiles.vn">Daisan Tiles</a>
            </div>
            <p>
                &copy; 2024 - Công Ty CP Xây Dựng SX TM Đại Sàn
            </p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>
    <script src="/site/upload/dang-ky-nha-ban/static/js/seller-register.js"></script>
</body>
</html>