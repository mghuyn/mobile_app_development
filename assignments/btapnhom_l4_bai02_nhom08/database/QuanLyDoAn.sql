
-- =============================================
-- BAI TAP 02 - BAI 10: XAY DUNG VA SU DUNG API
-- DATABASE: QuanLyDoAnDB
-- SQL SERVER
-- =============================================

USE master;
GO

IF DB_ID(N'QuanLyDoAnDB') IS NULL
BEGIN
    CREATE DATABASE QuanLyDoAnDB;
END
GO

USE QuanLyDoAnDB;
GO

-- 1. BANG LOAI DO AN
IF OBJECT_ID(N'dbo.LoaiDoAn', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.LoaiDoAn
    (
        MaLoaiDoAn VARCHAR(10) PRIMARY KEY,
        TenLoaiDoAn NVARCHAR(100) NOT NULL,
        MoTa NVARCHAR(500) NULL
    );
END
GO

-- 2. BANG CHUYEN NGANH
IF OBJECT_ID(N'dbo.ChuyenNganh', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.ChuyenNganh
    (
        MaChuyenNganh VARCHAR(10) PRIMARY KEY,
        TenChuyenNganh NVARCHAR(150) NOT NULL,
        MoTa NVARCHAR(500) NULL
    );
END
GO

-- 3. BANG GIANG VIEN
IF OBJECT_ID(N'dbo.GiangVien', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.GiangVien
    (
        MaGiangVien VARCHAR(10) PRIMARY KEY,
        HoTen NVARCHAR(100) NOT NULL,
        HocVi NVARCHAR(30) NULL,
        Email VARCHAR(150) NULL
    );
END
GO

-- 4. BANG DE TAI
IF OBJECT_ID(N'dbo.DeTai', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.DeTai
    (
        MaDeTai VARCHAR(10) PRIMARY KEY,
        TenDeTai NVARCHAR(250) NOT NULL,
        SoSinhVienToiDa INT NOT NULL DEFAULT 2,
        MaLoaiDoAn VARCHAR(10) NOT NULL,
        MaChuyenNganh VARCHAR(10) NOT NULL,
        MaGiangVien VARCHAR(10) NOT NULL,
        YeuCau NVARCHAR(MAX) NULL,
        MoTa NVARCHAR(MAX) NULL,

        CONSTRAINT CK_DeTai_SoSinhVien
            CHECK (SoSinhVienToiDa BETWEEN 1 AND 10),

        CONSTRAINT FK_DeTai_LoaiDoAn
            FOREIGN KEY (MaLoaiDoAn)
            REFERENCES dbo.LoaiDoAn(MaLoaiDoAn),

        CONSTRAINT FK_DeTai_ChuyenNganh
            FOREIGN KEY (MaChuyenNganh)
            REFERENCES dbo.ChuyenNganh(MaChuyenNganh),

        CONSTRAINT FK_DeTai_GiangVien
            FOREIGN KEY (MaGiangVien)
            REFERENCES dbo.GiangVien(MaGiangVien)
    );
END
GO

-- =============================================
-- 5. DU LIEU MAU: LOAI DO AN
-- =============================================

INSERT INTO dbo.LoaiDoAn
    (MaLoaiDoAn, TenLoaiDoAn, MoTa)
SELECT v.Ma, v.Ten, v.MoTa
FROM (VALUES
    ('DA', N'Đồ án',
     N'Đồ án học phần hoặc chuyên ngành'),
    ('KLKS', N'Khóa luận kỹ sư',
     N'Đề tài tốt nghiệp định hướng kỹ sư'),
    ('LV', N'Luận văn',
     N'Đề tài nghiên cứu và ứng dụng'),
    ('KHAC', N'Khác',
     N'Các loại đề tài khác')
) AS v(Ma, Ten, MoTa)
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.LoaiDoAn l
    WHERE l.MaLoaiDoAn = v.Ma
);
GO

-- =============================================
-- 6. DU LIEU MAU: CHUYEN NGANH
-- =============================================

INSERT INTO dbo.ChuyenNganh
    (MaChuyenNganh, TenChuyenNganh, MoTa)
SELECT v.Ma, v.Ten, v.MoTa
FROM (VALUES
    ('CNPM', N'Công nghệ phần mềm',
     N'Phát triển các hệ thống phần mềm'),
    ('HTTT', N'Hệ thống thông tin',
     N'Quản lý và khai thác hệ thống dữ liệu'),
    ('MMT', N'Mạng máy tính',
     N'Hạ tầng mạng và các dịch vụ mạng'),
    ('ATTT', N'An toàn thông tin',
     N'Bảo mật hệ thống và dữ liệu'),
    ('AI', N'Trí tuệ nhân tạo',
     N'Ứng dụng AI và học máy')
) AS v(Ma, Ten, MoTa)
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.ChuyenNganh c
    WHERE c.MaChuyenNganh = v.Ma
);
GO

-- =============================================
-- 7. DU LIEU MAU: GIANG VIEN
-- Ten giang vien chi la du lieu minh hoa
-- =============================================

INSERT INTO dbo.GiangVien
    (MaGiangVien, HoTen, HocVi, Email)
SELECT v.Ma, v.Ten, v.HocVi, v.Email
FROM (VALUES
    ('GV01', N'Nguyễn Văn An', N'ThS.',
     'an@example.edu.vn'),
    ('GV02', N'Trần Thị Bình', N'ThS.',
     'binh@example.edu.vn'),
    ('GV03', N'Lê Minh Khoa', N'TS.',
     'khoa@example.edu.vn'),
    ('GV04', N'Phạm Hoàng Nam', N'ThS.',
     'nam@example.edu.vn'),
    ('GV05', N'Võ Thị Lan', N'TS.',
     'lan@example.edu.vn')
) AS v(Ma, Ten, HocVi, Email)
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.GiangVien g
    WHERE g.MaGiangVien = v.Ma
);
GO

-- =============================================
-- 8. DU LIEU MAU: DE TAI DO AN
-- =============================================

INSERT INTO dbo.DeTai
(
    MaDeTai, TenDeTai, SoSinhVienToiDa,
    MaLoaiDoAn, MaChuyenNganh, MaGiangVien,
    YeuCau, MoTa
)
SELECT
    v.Ma, v.Ten, v.SoSV,
    v.Loai, v.Nganh, v.GV,
    v.YeuCau, v.MoTa
FROM (VALUES
    (
        'DT001',
        N'Xây dựng website quản lý cửa hàng xe máy',
        3, 'DA', 'CNPM', 'GV01',
        N'Sử dụng ASP.NET Core MVC, SQL Server. Có CRUD, tìm kiếm và thống kê.',
        N'Xây dựng hệ thống quản lý xe máy, khách hàng, đơn hàng và doanh thu.'
    ),
    (
        'DT002',
        N'Xây dựng ứng dụng quản lý nhà hàng',
        3, 'DA', 'CNPM', 'GV02',
        N'Sử dụng Flutter, REST API và SQL Server.',
        N'Quản lý bàn ăn, thực đơn, gọi món, hóa đơn và nhân viên.'
    ),
    (
        'DT003',
        N'Xây dựng website đặt vé xem phim',
        3, 'DA', 'CNPM', 'GV03',
        N'Sử dụng Laravel, MySQL. Hỗ trợ đặt vé và chọn ghế.',
        N'Quản lý phim, rạp, suất chiếu, đặt vé và thanh toán.'
    ),
    (
        'DT004',
        N'Xây dựng hệ thống quản lý thư viện',
        2, 'DA', 'HTTT', 'GV04',
        N'Sử dụng C#, SQL Server. Có quản lý mượn trả.',
        N'Quản lý sách, độc giả, phiếu mượn và thống kê.'
    ),
    (
        'DT005',
        N'Xây dựng hệ thống quản lý sinh viên',
        3, 'DA', 'HTTT', 'GV05',
        N'Sử dụng Web API và cơ sở dữ liệu quan hệ.',
        N'Quản lý sinh viên, lớp, môn học và kết quả học tập.'
    ),
    (
        'DT006',
        N'Giám sát hệ thống mạng nội bộ',
        2, 'KLKS', 'MMT', 'GV03',
        N'Có kiến thức TCP/IP, giám sát và phân tích mạng.',
        N'Theo dõi trạng thái thiết bị và cảnh báo sự cố mạng.'
    ),
    (
        'DT007',
        N'Phát hiện tấn công mạng bằng học máy',
        3, 'KLKS', 'ATTT', 'GV05',
        N'Sử dụng Python, Machine Learning và dữ liệu mạng.',
        N'Phân tích lưu lượng và nhận diện hành vi bất thường.'
    ),
    (
        'DT008',
        N'Hệ thống nhận diện khuôn mặt',
        2, 'KLKS', 'AI', 'GV01',
        N'Sử dụng Python, OpenCV và mô hình học sâu.',
        N'Nhận diện khuôn mặt phục vụ điểm danh tự động.'
    ),
    (
        'DT009',
        N'Phân loại cảm xúc từ văn bản tiếng Việt',
        2, 'LV', 'AI', 'GV02',
        N'Sử dụng xử lý ngôn ngữ tự nhiên và học máy.',
        N'Phân tích cảm xúc tích cực, tiêu cực và trung lập.'
    ),
    (
        'DT010',
        N'Nghiên cứu giải pháp bảo mật API',
        2, 'LV', 'ATTT', 'GV04',
        N'Có kiến thức REST API, JWT và bảo mật ứng dụng.',
        N'Đánh giá và đề xuất giải pháp bảo vệ Web API.'
    ),
    (
        'DT011',
        N'Xây dựng ứng dụng quản lý chi tiêu cá nhân',
        2, 'KHAC', 'CNPM', 'GV02',
        N'Sử dụng Flutter và cơ sở dữ liệu.',
        N'Theo dõi thu nhập, chi tiêu và báo cáo tài chính.'
    ),
    (
        'DT012',
        N'Phát triển hệ thống nhà thông minh IoT',
        3, 'KHAC', 'MMT', 'GV03',
        N'Sử dụng ESP32, cảm biến và giao thức MQTT.',
        N'Giám sát và điều khiển thiết bị thông minh.'
    )
) AS v(Ma, Ten, SoSV, Loai, Nganh, GV, YeuCau, MoTa)
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.DeTai d
    WHERE d.MaDeTai = v.Ma
);
GO

-- =============================================
-- 9. TAO INDEX HO TRO TRUY VAN
-- =============================================

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = 'IX_DeTai_MaLoaiDoAn'
    AND object_id = OBJECT_ID('dbo.DeTai')
)
    CREATE INDEX IX_DeTai_MaLoaiDoAn
    ON dbo.DeTai(MaLoaiDoAn);
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = 'IX_DeTai_MaChuyenNganh'
    AND object_id = OBJECT_ID('dbo.DeTai')
)
    CREATE INDEX IX_DeTai_MaChuyenNganh
    ON dbo.DeTai(MaChuyenNganh);
GO

-- =============================================
-- 10. KIEM TRA DU LIEU
-- =============================================

SELECT * FROM dbo.LoaiDoAn;
SELECT * FROM dbo.ChuyenNganh;
SELECT * FROM dbo.GiangVien;
SELECT * FROM dbo.DeTai;
GO


USE QuanLyDoAnDB;
GO

UPDATE GiangVien
SET HoTen = N'Nguyễn Văn An',
    HocVi = N'ThS.'
WHERE MaGiangVien = 'GV01';

UPDATE GiangVien
SET HoTen = N'Trần Thị Bình',
    HocVi = N'ThS.'
WHERE MaGiangVien = 'GV02';

UPDATE GiangVien
SET HoTen = N'Lê Minh Khoa',
    HocVi = N'TS.'
WHERE MaGiangVien = 'GV03';

UPDATE GiangVien
SET HoTen = N'Phạm Hoàng Nam',
    HocVi = N'ThS.'
WHERE MaGiangVien = 'GV04';

UPDATE GiangVien
SET HoTen = N'Võ Thị Lan',
    HocVi = N'TS.'
WHERE MaGiangVien = 'GV05';

SELECT MaGiangVien, HocVi, HoTen
FROM GiangVien
ORDER BY MaGiangVien;



USE QuanLyDoAnDB;
GO

UPDATE DeTai
SET YeuCau =
    N'Thành thạo ASP.NET Core MVC và C#.' + CHAR(13) + CHAR(10) +
    N'Có kiến thức SQL Server và Entity Framework.' + CHAR(13) + CHAR(10) +
    N'Xây dựng chức năng CRUD, tìm kiếm, thống kê.'
WHERE MaDeTai = 'DT001';

UPDATE DeTai
SET YeuCau =
    N'Thành thạo ngôn ngữ Dart và Flutter Framework.' + CHAR(13) + CHAR(10) +
    N'Có kiến thức REST API và SQL Server.' + CHAR(13) + CHAR(10) +
    N'Báo cáo tiến độ đúng hạn tuần/tháng.'
WHERE MaDeTai = 'DT002';

UPDATE DeTai
SET YeuCau =
    N'Có kiến thức PHP, Laravel Framework.' + CHAR(13) + CHAR(10) +
    N'Sử dụng MySQL để quản lý dữ liệu.' + CHAR(13) + CHAR(10) +
    N'Xây dựng chức năng đặt vé, chọn ghế và thanh toán.'
WHERE MaDeTai = 'DT003';

UPDATE DeTai
SET YeuCau =
    N'Thành thạo ngôn ngữ C#.' + CHAR(13) + CHAR(10) +
    N'Có kiến thức SQL Server.' + CHAR(13) + CHAR(10) +
    N'Xây dựng chức năng quản lý mượn trả sách.'
WHERE MaDeTai = 'DT004';

UPDATE DeTai
SET YeuCau =
    N'Hiểu về hệ quản trị cơ sở dữ liệu.' + CHAR(13) + CHAR(10) +
    N'Xây dựng ASP.NET Core Web API.' + CHAR(13) + CHAR(10) +
    N'Thực hiện thống kê và tìm kiếm sinh viên.'
WHERE MaDeTai = 'DT005';

UPDATE DeTai
SET YeuCau =
    N'Có kiến thức cơ bản về mạng máy tính.' + CHAR(13) + CHAR(10) +
    N'Hiểu giao thức TCP/IP.' + CHAR(13) + CHAR(10) +
    N'Có khả năng giám sát và phân tích lưu lượng mạng.'
WHERE MaDeTai = 'DT006';

UPDATE DeTai
SET YeuCau =
    N'Thành thạo Python.' + CHAR(13) + CHAR(10) +
    N'Có kiến thức Machine Learning.' + CHAR(13) + CHAR(10) +
    N'Biết phân tích dữ liệu và phát hiện bất thường.'
WHERE MaDeTai = 'DT007';

UPDATE DeTai
SET YeuCau =
    N'Có kiến thức Python và OpenCV.' + CHAR(13) + CHAR(10) +
    N'Hiểu các mô hình học sâu.' + CHAR(13) + CHAR(10) +
    N'Xây dựng ứng dụng nhận diện khuôn mặt.'
WHERE MaDeTai = 'DT008';

UPDATE DeTai
SET YeuCau =
    N'Có kiến thức xử lý ngôn ngữ tự nhiên.' + CHAR(13) + CHAR(10) +
    N'Sử dụng Python và thư viện học máy.' + CHAR(13) + CHAR(10) +
    N'Đánh giá chất lượng mô hình phân loại.'
WHERE MaDeTai = 'DT009';

UPDATE DeTai
SET YeuCau =
    N'Hiểu kiến trúc REST API.' + CHAR(13) + CHAR(10) +
    N'Có kiến thức JWT và bảo mật ứng dụng.' + CHAR(13) + CHAR(10) +
    N'Thực hiện đánh giá các lỗ hổng API.'
WHERE MaDeTai = 'DT010';

UPDATE DeTai
SET YeuCau =
    N'Thành thạo Flutter và Dart.' + CHAR(13) + CHAR(10) +
    N'Có kiến thức về cơ sở dữ liệu.' + CHAR(13) + CHAR(10) +
    N'Xây dựng biểu đồ thống kê thu chi.'
WHERE MaDeTai = 'DT011';

UPDATE DeTai
SET YeuCau =
    N'Có kiến thức về IoT và ESP32.' + CHAR(13) + CHAR(10) +
    N'Hiểu giao thức MQTT.' + CHAR(13) + CHAR(10) +
    N'Xây dựng ứng dụng điều khiển thiết bị thông minh.'
WHERE MaDeTai = 'DT012';

SELECT MaDeTai, TenDeTai, YeuCau
FROM DeTai
ORDER BY MaDeTai;
GO
