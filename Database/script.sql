USE [master]
GO
/****** Object:  Database [WebBanHang]    Script Date: 3/14/2022 9:12:52 PM ******/
CREATE DATABASE [WebBanHang]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'WebBanHang', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\WebBanHang.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'WebBanHang_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\WebBanHang_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [WebBanHang] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [WebBanHang].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [WebBanHang] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [WebBanHang] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [WebBanHang] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [WebBanHang] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [WebBanHang] SET ARITHABORT OFF 
GO
ALTER DATABASE [WebBanHang] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [WebBanHang] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [WebBanHang] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [WebBanHang] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [WebBanHang] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [WebBanHang] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [WebBanHang] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [WebBanHang] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [WebBanHang] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [WebBanHang] SET  DISABLE_BROKER 
GO
ALTER DATABASE [WebBanHang] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [WebBanHang] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [WebBanHang] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [WebBanHang] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [WebBanHang] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [WebBanHang] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [WebBanHang] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [WebBanHang] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [WebBanHang] SET  MULTI_USER 
GO
ALTER DATABASE [WebBanHang] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [WebBanHang] SET DB_CHAINING OFF 
GO
ALTER DATABASE [WebBanHang] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [WebBanHang] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [WebBanHang] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [WebBanHang] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'WebBanHang', N'ON'
GO
ALTER DATABASE [WebBanHang] SET QUERY_STORE = OFF
GO
USE [WebBanHang]
GO
/****** Object:  User [admin]    Script Date: 3/14/2022 9:12:52 PM ******/
CREATE USER [admin] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [a]    Script Date: 3/14/2022 9:12:52 PM ******/
CREATE USER [a] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  UserDefinedFunction [dbo].[DlNgay]    Script Date: 3/14/2022 9:12:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[DlNgay]
(
    @Thang INT,
    @Nam INT,
    @Ngay INT
)
RETURNS @DlNgay TABLE
(
    Thang nvarchar(50),
    TongTien INT
)
AS
BEGIN
	DECLARE @NgayThongKeBD NVARCHAR(50);
	DECLARE @NgayThongKeKT NVARCHAR(50);
    if @Ngay<10 and @Thang<10
    BEGIN
        SET @NgayThongKeBD =CONVERT(varchar(10),@nam)+'-0'+CONVERT(varchar(10),@Thang)+'-0'+CONVERT(varchar(10),@Ngay)+' 00:00:00.000';
	    SET @NgayThongKeKT =CONVERT(varchar(10),@nam)+'-0'+CONVERT(varchar(10),@Thang)+'-0'+CONVERT(varchar(10),@Ngay)+' 23:59:38.020';
    END
    ELSE if @Ngay<10 and @Thang>10
    BEGIN
        SET @NgayThongKeBD =CONVERT(varchar(10),@nam)+'-'+CONVERT(varchar(10),@Thang)+'-0'+CONVERT(varchar(10),@Ngay)+' 00:00:00.000';
	    SET @NgayThongKeKT =CONVERT(varchar(10),@nam)+'-'+CONVERT(varchar(10),@Thang)+'-0'+CONVERT(varchar(10),@Ngay)+' 23:59:38.020';
    END
    ELSE if @Ngay>10 and @Thang<10
	BEGIN
        SET @NgayThongKeBD =CONVERT(varchar(10),@nam)+'-0'+CONVERT(varchar(10),@Thang)+'-'+CONVERT(varchar(10),@Ngay)+' 00:00:00.000';
	    SET @NgayThongKeKT =CONVERT(varchar(10),@nam)+'-0'+CONVERT(varchar(10),@Thang)+'-'+CONVERT(varchar(10),@Ngay)+' 23:59:38.020';
    END
    ELSE
    BEGIN
        SET @NgayThongKeBD =CONVERT(varchar(10),@nam)+'-'+CONVERT(varchar(10),@Thang)+'-'+CONVERT(varchar(10),@Ngay)+' 00:00:00.000';
	    SET @NgayThongKeKT =CONVERT(varchar(10),@nam)+'-'+CONVERT(varchar(10),@Thang)+'-'+CONVERT(varchar(10),@Ngay)+' 23:59:38.020';
    END
	
    DECLARE @TongTien float;
    SET @TongTien=(select SUM(tongTien) from DonHang as dh
	               where dh.ngayDat between @NgayThongKeBD and @NgayThongKeKT and trangThai='true');
    if @TongTien is NULL
    BEGIN
       SET @TongTien=0;
    END

	INSERT into @DlNgay(Thang,TongTien)
	Values
	(@Thang,@TongTien)

	RETURN
END;
GO
/****** Object:  UserDefinedFunction [dbo].[Func_ThongKeDoanhThu]    Script Date: 3/14/2022 9:12:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Func_ThongKeDoanhThu](@Nam INT, @Thang INT) 
RETURNS @bangthongke TABLE
(
	Ngay INT,
	DoanhThu FLOAT
)AS
BEGIN
	DECLARE @Ngay INT = 1
	WHILE @Ngay < 29
		BEGIN
			INSERT INTO @bangthongke
			SELECT @Ngay, CASE WHEN SUM(tongTien) > 0 THEN SUM(tongTien) ELSE 0 END 
			FROM [dbo].[DonHang] 
			WHERE trangThai = 3 AND YEAR(ngayDat) = @Nam AND MONTH(ngayDat) = @Thang AND DAY(ngayDat) = @Ngay
			SET @Ngay = @Ngay + 1
		END
	IF(@Thang = 2 AND @Nam%4 = 0)
		BEGIN
			INSERT INTO @bangthongke
			SELECT 29, CASE WHEN SUM(tongTien) > 0 THEN SUM(tongTien) ELSE 0 END 
			FROM [dbo].[DonHang] 
			WHERE trangThai = 3 AND YEAR(ngayDat) = @Nam AND MONTH(ngayDat) = 2 AND DAY(ngayDat) = 29
		END
	IF(@Thang != 2)
		WHILE @Ngay < 31
		BEGIN
			INSERT INTO @bangthongke
			SELECT @Ngay, CASE WHEN SUM(tongTien) > 0 THEN SUM(tongTien) ELSE 0 END 
			FROM [dbo].[DonHang] 
			WHERE trangThai = 3 AND YEAR(ngayDat) = @Nam AND MONTH(ngayDat) = @Thang AND DAY(ngayDat) = @Ngay
			SET @Ngay = @Ngay + 1
		END
	IF(@Thang = 1 OR @Thang = 3 OR @Thang = 5 OR @Thang = 7 OR @Thang = 8 OR @Thang = 10 OR @Thang = 12)
		BEGIN
			INSERT INTO @bangthongke
			SELECT 31, CASE WHEN SUM(tongTien) > 0 THEN SUM(tongTien) ELSE 0 END 
			FROM [dbo].[DonHang] 
			WHERE trangThai = 3 AND YEAR(ngayDat) = @Nam AND MONTH(ngayDat) = @Thang AND DAY(ngayDat) = 31
		END
	RETURN 
END
GO
/****** Object:  UserDefinedFunction [dbo].[funConvertToUnsign]    Script Date: 3/14/2022 9:12:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[funConvertToUnsign] ( @strInput NVARCHAR(4000) ) 
RETURNS NVARCHAR(4000) AS 
BEGIN 
	IF @strInput IS NULL 
		RETURN @strInput 
	IF @strInput = '' 
		RETURN @strInput 
	DECLARE @RT NVARCHAR(4000) 
	DECLARE @SIGN_CHARS NCHAR(136) 
	DECLARE @UNSIGN_CHARS NCHAR (136) 
	SET @SIGN_CHARS = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệế ìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵý ĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍ ÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ' + NCHAR(272) + NCHAR(208) 
	SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeee iiiiiooooooooooooooouuuuuuuuuuyyyyy AADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIII OOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD' 
	DECLARE @COUNTER int 
	DECLARE @COUNTER1 int 
	SET @COUNTER = 1 
	WHILE (@COUNTER <=LEN(@strInput)) 
		BEGIN 
			SET @COUNTER1 = 1 
			WHILE (@COUNTER1 <=LEN(@SIGN_CHARS)+1) 
				BEGIN 
					IF UNICODE(SUBSTRING(@SIGN_CHARS, @COUNTER1,1)) = UNICODE(SUBSTRING(@strInput,@COUNTER ,1) ) 
						BEGIN 
							IF @COUNTER=1 
								SET @strInput = SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)-1) 
							ELSE 
								SET @strInput = SUBSTRING(@strInput, 1, @COUNTER-1) +SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)- @COUNTER) 
							BREAK 
						END 
					SET @COUNTER1 = @COUNTER1 +1 
				END 
			SET @COUNTER = @COUNTER +1 
		END 
	SET @strInput = replace(@strInput,' ','-') 
	RETURN @strInput 
END
GO
/****** Object:  Table [dbo].[Anh]    Script Date: 3/14/2022 9:12:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Anh](
	[idAnh] [int] IDENTITY(1,1) NOT NULL,
	[link] [nvarchar](100) NULL,
	[idSp] [int] NULL,
 CONSTRAINT [PK_Anh] PRIMARY KEY CLUSTERED 
(
	[idAnh] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CT_DonHang]    Script Date: 3/14/2022 9:12:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CT_DonHang](
	[idDon] [int] NOT NULL,
	[idSp] [int] NOT NULL,
	[giaBan] [float] NULL,
	[soLuong] [int] NULL,
	[thanhTien] [float] NULL,
 CONSTRAINT [PK_CT_DonHang] PRIMARY KEY CLUSTERED 
(
	[idDon] ASC,
	[idSp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DanhGia]    Script Date: 3/14/2022 9:12:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DanhGia](
	[idSp] [int] NOT NULL,
	[idKhach] [int] NOT NULL,
	[ngayTao] [datetime] NULL,
	[noiDung] [nvarchar](500) NULL,
	[Id] [int] IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DonHang]    Script Date: 3/14/2022 9:12:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DonHang](
	[idDon] [int] IDENTITY(1,1) NOT NULL,
	[ngayDat] [datetime] NULL,
	[diaChiGiao] [nvarchar](200) NULL,
	[moTa] [nvarchar](200) NULL,
	[tongTien] [float] NULL,
	[idKhach] [int] NULL,
	[idUser] [int] NULL,
	[trangThai] [int] NULL,
	[donViGiao] [nvarchar](200) NULL,
 CONSTRAINT [PK_DonHang] PRIMARY KEY CLUSTERED 
(
	[idDon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[KhachHang]    Script Date: 3/14/2022 9:12:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KhachHang](
	[idKhach] [int] IDENTITY(1,1) NOT NULL,
	[hoTen] [nvarchar](50) NULL,
	[diaChi] [nvarchar](100) NULL,
	[email] [varchar](50) NULL,
	[sdt] [char](10) NULL,
	[tenDangNhap] [nvarchar](50) NULL,
	[matKhau] [nvarchar](200) NULL,
	[trangThai] [bit] NULL,
 CONSTRAINT [PK_KhachHang] PRIMARY KEY CLUSTERED 
(
	[idKhach] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LienHe]    Script Date: 3/14/2022 9:12:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LienHe](
	[IdLienHe] [int] IDENTITY(1,1) NOT NULL,
	[Ho] [nvarchar](50) NULL,
	[Ten] [nvarchar](50) NULL,
	[Email] [nvarchar](100) NULL,
	[SDT] [nvarchar](20) NULL,
	[NoiDung] [nvarchar](max) NULL,
	[idKhach] [int] NULL,
	[NgayTao] [datetime] NOT NULL,
 CONSTRAINT [PK_LienHe] PRIMARY KEY CLUSTERED 
(
	[IdLienHe] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LoaiSp]    Script Date: 3/14/2022 9:12:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoaiSp](
	[idLoai] [int] IDENTITY(1,1) NOT NULL,
	[tenLoaiSp] [nvarchar](50) NULL,
	[trangThai] [bit] NULL,
	[idUser] [int] NULL,
 CONSTRAINT [PK_LoaiSp] PRIMARY KEY CLUSTERED 
(
	[idLoai] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SanPham]    Script Date: 3/14/2022 9:12:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SanPham](
	[idSp] [int] IDENTITY(1,1) NOT NULL,
	[ten] [nvarchar](50) NULL,
	[moTa] [ntext] NULL,
	[chiTiet] [ntext] NULL,
	[gia] [float] NULL,
	[giaKm] [float] NULL,
	[trangThai] [int] NULL,
	[idLoai] [int] NULL,
	[idThuongHieu] [int] NULL,
	[idUser] [int] NULL,
	[soLuong] [int] NULL,
	[trangThaiMieuTa] [nvarchar](50) NULL,
	[anhDaiDien] [nvarchar](100) NULL,
	[MieuTaSanPhamNoiBat] [nvarchar](50) NULL,
 CONSTRAINT [PK_SanPham] PRIMARY KEY CLUSTERED 
(
	[idSp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ThuongHieu]    Script Date: 3/14/2022 9:12:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ThuongHieu](
	[idThuongHieu] [int] IDENTITY(1,1) NOT NULL,
	[tenThuongHieu] [nvarchar](50) NULL,
	[idUser] [int] NULL,
 CONSTRAINT [PK_ThuongHieu] PRIMARY KEY CLUSTERED 
(
	[idThuongHieu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TinTuc]    Script Date: 3/14/2022 9:12:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TinTuc](
	[idTin] [int] IDENTITY(1,1) NOT NULL,
	[tieuDe] [nvarchar](200) NULL,
	[anh] [nvarchar](200) NULL,
	[noiDung] [ntext] NULL,
	[ngayTao] [datetime] NULL,
	[idUser] [int] NULL,
 CONSTRAINT [PK_TinTuc] PRIMARY KEY CLUSTERED 
(
	[idTin] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 3/14/2022 9:12:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[idUser] [int] IDENTITY(1,1) NOT NULL,
	[hoTen] [nvarchar](50) NULL,
	[tenDangNhap] [nvarchar](50) NULL,
	[matKhau] [nvarchar](200) NULL,
	[quyen] [int] NULL,
	[trangThai] [bit] NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[idUser] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Anh] ON 

INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (26, N'Anh3.jpg', 5)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (27, N'Anh4.png', 11)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (28, N'Anh1.jpg', 9)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (29, N'Anh5.jpg', 7)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (30, N'Anh6.jpg', 6)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (31, N'Anh6.jpg', 1)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (32, N'Anh8.jpg', 2)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (33, N'Anh9.jpg', 4)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (34, N'Anh10.png', 3)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (39, N'Anh11.jpg', 15)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (40, N'Anh12.jpg', 14)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (41, N'Anh13.jpg', 15)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (42, N'Anh14.jpg', 16)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (43, N'Anh15.jpg', 16)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (44, N'Anh16.jpg', 17)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (45, N'Anh9.jpg', 17)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (46, N'Anh10.png', 17)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (55, N'Anh18.jpg', 19)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (56, N'Anh4.png', 19)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (57, N'Anh3.jpg', 19)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (58, N'Anh5.jpg', 19)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (59, N'Anh6.jpg', 19)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (60, N'Anh7.jpg', 19)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (61, N'Anh9.jpg', 20)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (62, N'Anh11.jpg', 20)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (63, N'Anh12.jpg', 20)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (64, N'Anh14.jpg', 20)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (65, N'Anh15.jpg', 13)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (66, N'Anh9.jpg', 13)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (67, N'Anh16.jpg', 13)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (68, N'Anh10.png', 14)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (69, N'Anh18.jpg', 14)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (70, N'Anh13.jpg', 14)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (71, N'Anh7.jpg', 14)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (72, N'Anh5.jpg', 16)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (73, N'Anh16.jpg', 16)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (77, N'Anh9.jpg', 4)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (78, N'Anh13.jpg', 4)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (79, N'Anh15.jpg', 9)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (80, N'Anh5.jpg', 9)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (82, N'Anh14.jpg', 12)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (83, N'Anh9.jpg', 12)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (84, N'Anh13.jpg', 12)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (85, N'Anh4.png', 11)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (86, N'Anh9.jpg', 11)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (87, N'Anh13.jpg', 11)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (88, N'Anh11.jpg', 11)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (89, N'Anh10.png', 10)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (90, N'Anh12.jpg', 10)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (91, N'

Anh10.png', 10)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (92, N'Anh15.jpg', 10)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (100, N'Anh9.jpg', 5)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (101, N'Anh18.jpg', 5)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (102, N'Anh12.jpg', 5)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (103, N'Anh10.png', 5)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (104, N'Anh16.jpg', 1)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (105, N'Anh10.png', 1)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (106, N'Anh4.png', 1)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (111, N'Anh18.jpg', 3)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (112, N'Anh10.png', 3)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (113, N'Anh6.jpg', 3)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (1049, N'Anh14.jpg', 7)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (1050, N'Anh8.jpg', 7)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (1051, N'Anh5.jpg', 7)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (1052, N'Anh13.jpg', 6)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (1053, N'Anh8.jpg', 6)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (1054, N'Anh1.jpg', 6)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (1055, N'Anh11.jpg', 6)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (1056, N'Anh1.jpg', 6)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (1057, N'Anh8.jpg', 2)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (1058, N'Anh10.png', 2)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (1059, N'Anh13.jpg', 2)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (1060, N'Anh9.jpg', 2)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (1061, N'5.1_15.jpg', 1019)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (1062, N'581_hp_pavilion_x360_ph_1.png', 1019)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (2061, N'5.1_15.jpg', 2019)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (2062, N'581_hp_pavilion_x360_ph_1.png', 2019)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (2063, N'2806_37870_19632_laptop_msi_pulse_gl66_11udk_255vn_1.jpg', 2019)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (2064, N'2806_techzones-msi-pulse-gl66.jpg', 2019)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (2065, N'13747_laptop_msi_katana_gf76_11uc_096vn.jpg', 2019)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (2066, N'Anh1.png', 2019)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (2067, N'dell_j01j71.jpg', 2019)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (2068, N'dsc05575-_2047x1152-800-resize.jpg', 2019)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (2069, N'e23ymml0g7d19.jpg', 2019)
INSERT [dbo].[Anh] ([idAnh], [link], [idSp]) VALUES (2070, N'ed01507eaf683e317a8ef640c5445008.jpg', 2019)
SET IDENTITY_INSERT [dbo].[Anh] OFF
GO
INSERT [dbo].[CT_DonHang] ([idDon], [idSp], [giaBan], [soLuong], [thanhTien]) VALUES (1, 3, 6200000, 1, 6200000)
INSERT [dbo].[CT_DonHang] ([idDon], [idSp], [giaBan], [soLuong], [thanhTien]) VALUES (2, 4, 8000000, 3, 24000000)
INSERT [dbo].[CT_DonHang] ([idDon], [idSp], [giaBan], [soLuong], [thanhTien]) VALUES (4, 4, 8000000, 1, 8000000)
INSERT [dbo].[CT_DonHang] ([idDon], [idSp], [giaBan], [soLuong], [thanhTien]) VALUES (4, 5, 76900000, 1, 76900000)
INSERT [dbo].[CT_DonHang] ([idDon], [idSp], [giaBan], [soLuong], [thanhTien]) VALUES (8, 9, 7800000, 1, 7800000)
INSERT [dbo].[CT_DonHang] ([idDon], [idSp], [giaBan], [soLuong], [thanhTien]) VALUES (9, 6, 9500000, 1, 9500000)
INSERT [dbo].[CT_DonHang] ([idDon], [idSp], [giaBan], [soLuong], [thanhTien]) VALUES (9, 10, 8900000, 1, 8900000)
INSERT [dbo].[CT_DonHang] ([idDon], [idSp], [giaBan], [soLuong], [thanhTien]) VALUES (9, 16, 5900000, 1, 5900000)
INSERT [dbo].[CT_DonHang] ([idDon], [idSp], [giaBan], [soLuong], [thanhTien]) VALUES (11, 6, 9500000, 1, 9500000)
INSERT [dbo].[CT_DonHang] ([idDon], [idSp], [giaBan], [soLuong], [thanhTien]) VALUES (11, 17, 3900000, 1, 3900000)
INSERT [dbo].[CT_DonHang] ([idDon], [idSp], [giaBan], [soLuong], [thanhTien]) VALUES (19, 3, 6200000, 1, 6200000)
INSERT [dbo].[CT_DonHang] ([idDon], [idSp], [giaBan], [soLuong], [thanhTien]) VALUES (19, 10, 8900000, 2, 17800000)
INSERT [dbo].[CT_DonHang] ([idDon], [idSp], [giaBan], [soLuong], [thanhTien]) VALUES (28, 3, 6200000, 1, 6200000)
INSERT [dbo].[CT_DonHang] ([idDon], [idSp], [giaBan], [soLuong], [thanhTien]) VALUES (29, 1, 2500000, 1, 2500000)
INSERT [dbo].[CT_DonHang] ([idDon], [idSp], [giaBan], [soLuong], [thanhTien]) VALUES (29, 20, 22, 1, 22)
INSERT [dbo].[CT_DonHang] ([idDon], [idSp], [giaBan], [soLuong], [thanhTien]) VALUES (1020, 3, 6200000, 1, 6200000)
INSERT [dbo].[CT_DonHang] ([idDon], [idSp], [giaBan], [soLuong], [thanhTien]) VALUES (1020, 16, 5900000, 1, 5900000)
INSERT [dbo].[CT_DonHang] ([idDon], [idSp], [giaBan], [soLuong], [thanhTien]) VALUES (1021, 3, 6900000, 1, 6900000)
INSERT [dbo].[CT_DonHang] ([idDon], [idSp], [giaBan], [soLuong], [thanhTien]) VALUES (1022, 1, 2500000, 1, 2500000)
INSERT [dbo].[CT_DonHang] ([idDon], [idSp], [giaBan], [soLuong], [thanhTien]) VALUES (2024, 5, 7690000, 1, 7690000)
INSERT [dbo].[CT_DonHang] ([idDon], [idSp], [giaBan], [soLuong], [thanhTien]) VALUES (2025, 9, 7800000, 2, 15600000)
INSERT [dbo].[CT_DonHang] ([idDon], [idSp], [giaBan], [soLuong], [thanhTien]) VALUES (2025, 10, 8900000, 1, 8900000)
INSERT [dbo].[CT_DonHang] ([idDon], [idSp], [giaBan], [soLuong], [thanhTien]) VALUES (2026, 2, 7000000, 1, 7000000)
INSERT [dbo].[CT_DonHang] ([idDon], [idSp], [giaBan], [soLuong], [thanhTien]) VALUES (2026, 13, 3900000, 1, 3900000)
INSERT [dbo].[CT_DonHang] ([idDon], [idSp], [giaBan], [soLuong], [thanhTien]) VALUES (2027, 5, 7690000, 1, 7690000)
INSERT [dbo].[CT_DonHang] ([idDon], [idSp], [giaBan], [soLuong], [thanhTien]) VALUES (2028, 3, 6900000, 2, 13800000)
INSERT [dbo].[CT_DonHang] ([idDon], [idSp], [giaBan], [soLuong], [thanhTien]) VALUES (2028, 5, 7690000, 1, 7690000)
GO
SET IDENTITY_INSERT [dbo].[DanhGia] ON 

INSERT [dbo].[DanhGia] ([idSp], [idKhach], [ngayTao], [noiDung], [Id]) VALUES (5, 1, CAST(N'2022-03-13T22:36:31.500' AS DateTime), N'<p>11111</p>
', 1)
INSERT [dbo].[DanhGia] ([idSp], [idKhach], [ngayTao], [noiDung], [Id]) VALUES (3, 1, CAST(N'2022-03-14T15:04:26.417' AS DateTime), N'<p>1111</p>
', 2)
INSERT [dbo].[DanhGia] ([idSp], [idKhach], [ngayTao], [noiDung], [Id]) VALUES (3, 1, CAST(N'2022-03-14T15:19:07.907' AS DateTime), N'<p>1111111</p>
', 3)
INSERT [dbo].[DanhGia] ([idSp], [idKhach], [ngayTao], [noiDung], [Id]) VALUES (5, 1, CAST(N'2022-03-14T15:19:53.310' AS DateTime), N'<p>1122222</p>
', 4)
SET IDENTITY_INSERT [dbo].[DanhGia] OFF
GO
SET IDENTITY_INSERT [dbo].[DonHang] ON 

INSERT [dbo].[DonHang] ([idDon], [ngayDat], [diaChiGiao], [moTa], [tongTien], [idKhach], [idUser], [trangThai], [donViGiao]) VALUES (1, CAST(N'2022-02-04T01:31:38.020' AS DateTime), N'1 -Huyện 1 -Tỉnh 1', NULL, 6200000, 1, 1, 5, NULL)
INSERT [dbo].[DonHang] ([idDon], [ngayDat], [diaChiGiao], [moTa], [tongTien], [idKhach], [idUser], [trangThai], [donViGiao]) VALUES (2, CAST(N'2022-02-05T01:31:38.020' AS DateTime), N'Thái Bình', NULL, 24000000, 1, 1, 5, NULL)
INSERT [dbo].[DonHang] ([idDon], [ngayDat], [diaChiGiao], [moTa], [tongTien], [idKhach], [idUser], [trangThai], [donViGiao]) VALUES (4, CAST(N'2022-02-19T22:46:54.027' AS DateTime), N'440 Vĩnh Hưng, Hoàng Mai', N'', 84900000, 2, NULL, 3, NULL)
INSERT [dbo].[DonHang] ([idDon], [ngayDat], [diaChiGiao], [moTa], [tongTien], [idKhach], [idUser], [trangThai], [donViGiao]) VALUES (8, CAST(N'2022-02-23T22:12:59.067' AS DateTime), N'Đông Anh, Hà Nội', N'', 7800000, 3, NULL, 3, NULL)
INSERT [dbo].[DonHang] ([idDon], [ngayDat], [diaChiGiao], [moTa], [tongTien], [idKhach], [idUser], [trangThai], [donViGiao]) VALUES (9, CAST(N'2022-02-23T22:16:14.977' AS DateTime), N'Thái Bình', N'', 24300000, 8, NULL, 3, NULL)
INSERT [dbo].[DonHang] ([idDon], [ngayDat], [diaChiGiao], [moTa], [tongTien], [idKhach], [idUser], [trangThai], [donViGiao]) VALUES (11, CAST(N'2022-02-23T22:26:36.937' AS DateTime), N'Hà Nội', N'', 13400000, 6, NULL, 3, NULL)
INSERT [dbo].[DonHang] ([idDon], [ngayDat], [diaChiGiao], [moTa], [tongTien], [idKhach], [idUser], [trangThai], [donViGiao]) VALUES (19, CAST(N'2022-02-28T17:01:05.957' AS DateTime), N'Nam Định', NULL, 24000000, 2, NULL, 1, NULL)
INSERT [dbo].[DonHang] ([idDon], [ngayDat], [diaChiGiao], [moTa], [tongTien], [idKhach], [idUser], [trangThai], [donViGiao]) VALUES (20, CAST(N'2022-02-01T08:44:45.200' AS DateTime), N'Xã Xã Hoàng Diệuhuyện(phường) Huyện Chương MỹTỉnhHà Nội', N'', 83142999, 1, NULL, 5, N'Giao hàng nhanh')
INSERT [dbo].[DonHang] ([idDon], [ngayDat], [diaChiGiao], [moTa], [tongTien], [idKhach], [idUser], [trangThai], [donViGiao]) VALUES (21, CAST(N'2022-02-01T08:55:10.193' AS DateTime), N'Xã Xã Phú Thịhuyện(phường) Huyện Gia LâmTỉnhHà Nội', N'', 83142999, 1, NULL, 3, N'Giao hàng nhanh')
INSERT [dbo].[DonHang] ([idDon], [ngayDat], [diaChiGiao], [moTa], [tongTien], [idKhach], [idUser], [trangThai], [donViGiao]) VALUES (22, CAST(N'2022-02-01T08:56:15.640' AS DateTime), N'Xã Xã Phú Thịhuyện(phường) Huyện Gia LâmTỉnhHà Nội', N'', 83142999, 1, NULL, 3, N'Giao hàng nhanh')
INSERT [dbo].[DonHang] ([idDon], [ngayDat], [diaChiGiao], [moTa], [tongTien], [idKhach], [idUser], [trangThai], [donViGiao]) VALUES (23, CAST(N'2022-02-01T08:58:28.207' AS DateTime), N'Xã Xã Phú Thịhuyện(phường) Huyện Gia LâmTỉnhHà Nội', N'', 83142999, 1, NULL, 3, N'Giao hàng nhanh')
INSERT [dbo].[DonHang] ([idDon], [ngayDat], [diaChiGiao], [moTa], [tongTien], [idKhach], [idUser], [trangThai], [donViGiao]) VALUES (24, CAST(N'2022-02-01T09:13:54.383' AS DateTime), N'Xã Phường Bùi Thị Xuânhuyện(phường) Quận Hai Bà TrưngTỉnhHà Nội', N'', 6229999, 1, NULL, 3, N'Giao hàng nhanh')
INSERT [dbo].[DonHang] ([idDon], [ngayDat], [diaChiGiao], [moTa], [tongTien], [idKhach], [idUser], [trangThai], [donViGiao]) VALUES (25, CAST(N'2022-02-01T09:18:19.460' AS DateTime), N'Xã Phường Phú Đôhuyện(phường) Quận Nam Từ LiêmTỉnhHà Nội', N'', 6242999, 1, NULL, 3, N'Giao hàng nhanh')
INSERT [dbo].[DonHang] ([idDon], [ngayDat], [diaChiGiao], [moTa], [tongTien], [idKhach], [idUser], [trangThai], [donViGiao]) VALUES (26, CAST(N'2022-02-01T09:26:01.137' AS DateTime), N'Xã Xã Ninh Hiệphuyện(phường) Huyện Gia LâmTỉnhHà Nội', N'', 6242999, 1, NULL, 3, N'Giao hàng nhanh')
INSERT [dbo].[DonHang] ([idDon], [ngayDat], [diaChiGiao], [moTa], [tongTien], [idKhach], [idUser], [trangThai], [donViGiao]) VALUES (27, CAST(N'2022-02-01T09:34:10.333' AS DateTime), N'Xã Xã Thuần Mỹhuyện(phường) Huyện Ba VìTỉnhHà Nội', N'', 6242999, 1, NULL, 3, N'Giao hàng nhanh')
INSERT [dbo].[DonHang] ([idDon], [ngayDat], [diaChiGiao], [moTa], [tongTien], [idKhach], [idUser], [trangThai], [donViGiao]) VALUES (28, CAST(N'2022-02-01T09:39:57.897' AS DateTime), N'Xã Xã Dân Hòahuyện(phường) Huyện Thanh OaiTỉnhHà Nội', N'', 6242999, 1, NULL, 3, N'Giao hàng nhanh')
INSERT [dbo].[DonHang] ([idDon], [ngayDat], [diaChiGiao], [moTa], [tongTien], [idKhach], [idUser], [trangThai], [donViGiao]) VALUES (29, CAST(N'2022-02-01T22:48:16.187' AS DateTime), N'Xã Vân Nam - Huyện Phúc Thọ - Hà Nội', N'', 2543021, 1, NULL, 2, N'Giao hàng nhanh')
INSERT [dbo].[DonHang] ([idDon], [ngayDat], [diaChiGiao], [moTa], [tongTien], [idKhach], [idUser], [trangThai], [donViGiao]) VALUES (1020, CAST(N'2022-02-02T20:25:14.037' AS DateTime), N'Xã Tân Ước - Huyện Thanh Oai - Hà Nội', N'', 12142999, 1, NULL, 2, N'Giao hàng nhanh')
INSERT [dbo].[DonHang] ([idDon], [ngayDat], [diaChiGiao], [moTa], [tongTien], [idKhach], [idUser], [trangThai], [donViGiao]) VALUES (1021, CAST(N'2022-02-16T15:19:03.730' AS DateTime), N'Xã Phụng Công - Huyện Văn Giang - Hưng Yên', N'', 6996000, 1, NULL, 1, N'Giao hàng tiết kiệm')
INSERT [dbo].[DonHang] ([idDon], [ngayDat], [diaChiGiao], [moTa], [tongTien], [idKhach], [idUser], [trangThai], [donViGiao]) VALUES (1022, CAST(N'2022-02-23T12:48:04.087' AS DateTime), N'111111', NULL, 2500000, 1, NULL, 1, NULL)
INSERT [dbo].[DonHang] ([idDon], [ngayDat], [diaChiGiao], [moTa], [tongTien], [idKhach], [idUser], [trangThai], [donViGiao]) VALUES (2022, CAST(N'2022-02-28T13:06:05.117' AS DateTime), N'Xã Nhật Quang - Huyện Văn Giang - Hưng Yên', N'11111', 23100000, 1, NULL, 2, N'Giao hàng nhanh')
INSERT [dbo].[DonHang] ([idDon], [ngayDat], [diaChiGiao], [moTa], [tongTien], [idKhach], [idUser], [trangThai], [donViGiao]) VALUES (2023, CAST(N'2022-02-28T13:09:09.853' AS DateTime), N'Xã Lạc Đạo - Huyện Văn Lâm - Hưng Yên', N'11111', 7020000, 1, NULL, 2, N'Giao hàng tiết kiệm')
INSERT [dbo].[DonHang] ([idDon], [ngayDat], [diaChiGiao], [moTa], [tongTien], [idKhach], [idUser], [trangThai], [donViGiao]) VALUES (2024, CAST(N'2022-02-28T13:39:49.213' AS DateTime), N'Xã Tống Phan - Huyện Phù Cừ - Hưng Yên', N'111', 7933000, 1, NULL, 2, N'Giao hàng tiết kiệm')
INSERT [dbo].[DonHang] ([idDon], [ngayDat], [diaChiGiao], [moTa], [tongTien], [idKhach], [idUser], [trangThai], [donViGiao]) VALUES (2025, CAST(N'2022-03-07T13:44:36.473' AS DateTime), N'Xã Xuân Quan - Huyện Văn Giang - Hưng Yên', N'Giao hang test', 24530000, 1, 2, 5, N'Giao hàng nhanh')
INSERT [dbo].[DonHang] ([idDon], [ngayDat], [diaChiGiao], [moTa], [tongTien], [idKhach], [idUser], [trangThai], [donViGiao]) VALUES (2026, CAST(N'2022-03-13T22:43:12.447' AS DateTime), N'Xã Trung Hưng - Huyện Yên Mỹ - Hưng Yên', NULL, 10930000, 1, 2, 5, N'Giao hàng nhanh')
INSERT [dbo].[DonHang] ([idDon], [ngayDat], [diaChiGiao], [moTa], [tongTien], [idKhach], [idUser], [trangThai], [donViGiao]) VALUES (2027, CAST(N'2022-03-14T13:04:18.147' AS DateTime), N'Xã Tống Phan - Huyện Phù Cừ - Hưng Yên', N'', 7720000, 1, NULL, 2, N'Giao hàng nhanh')
INSERT [dbo].[DonHang] ([idDon], [ngayDat], [diaChiGiao], [moTa], [tongTien], [idKhach], [idUser], [trangThai], [donViGiao]) VALUES (2028, CAST(N'2022-03-14T15:13:29.617' AS DateTime), N'Phường Trung Hoà - Quận Cầu Giấy - Hà Nội', NULL, 21508000, 1, 2, 5, N'Giao hàng tiết kiệm')
SET IDENTITY_INSERT [dbo].[DonHang] OFF
GO
SET IDENTITY_INSERT [dbo].[KhachHang] ON 

INSERT [dbo].[KhachHang] ([idKhach], [hoTen], [diaChi], [email], [sdt], [tenDangNhap], [matKhau], [trangThai]) VALUES (1, N'Trần Hữu Đức', N'Thái Bình', N'tranduc@gmail.com', N'0133456789', N'ducth', N'1911', 1)
INSERT [dbo].[KhachHang] ([idKhach], [hoTen], [diaChi], [email], [sdt], [tenDangNhap], [matKhau], [trangThai]) VALUES (2, N'Đào Đức Anh', N'Nam Định', N'daoducanh1911@gmial.com', N'0943397731', N'anhdd', N'1911', 1)
INSERT [dbo].[KhachHang] ([idKhach], [hoTen], [diaChi], [email], [sdt], [tenDangNhap], [matKhau], [trangThai]) VALUES (3, N'Lưu Ngọc Lan', N'Đông Anh, Hà Nội', N'lanluu0911@gmail.com', N'0123456777', N'lanln', N'1911', 1)
INSERT [dbo].[KhachHang] ([idKhach], [hoTen], [diaChi], [email], [sdt], [tenDangNhap], [matKhau], [trangThai]) VALUES (4, N'Nguyễn Hồng Hà', N'Hà Nội', N'nhha@gmail.com', N'0763361838', N'hanh', N'2012', 1)
INSERT [dbo].[KhachHang] ([idKhach], [hoTen], [diaChi], [email], [sdt], [tenDangNhap], [matKhau], [trangThai]) VALUES (5, N'Vũ Hoàng Ánh ', N'Thái Bình', N'anh@gmail.com', N'091234678 ', N'anhvh', N'1911', 1)
INSERT [dbo].[KhachHang] ([idKhach], [hoTen], [diaChi], [email], [sdt], [tenDangNhap], [matKhau], [trangThai]) VALUES (6, N'Đỗ Thị Nguyệt ', N'Nam Trực, Nam Định ', N'nguyet@gmail.com', N'0123456789', N'nguyetdt', N'1911', 1)
INSERT [dbo].[KhachHang] ([idKhach], [hoTen], [diaChi], [email], [sdt], [tenDangNhap], [matKhau], [trangThai]) VALUES (7, N'Nguyễn Thu Thủy', N'Nghệ An', N'thuynt@gmail.com', N'0912345689', N'thuynt', N'1911', 1)
INSERT [dbo].[KhachHang] ([idKhach], [hoTen], [diaChi], [email], [sdt], [tenDangNhap], [matKhau], [trangThai]) VALUES (8, N'Nguyễn Lê Khánh Nam', N'Hà Nội', N'namnlk@gmail.com', N'0981455462', N'namnlk', N'1911', 1)
INSERT [dbo].[KhachHang] ([idKhach], [hoTen], [diaChi], [email], [sdt], [tenDangNhap], [matKhau], [trangThai]) VALUES (9, N'Nguyễn Lê Khánh Chi', N'Hà Nội', N'chinlk@gmail.com', N'0123456789', N'chinlk', N'1911', 1)
INSERT [dbo].[KhachHang] ([idKhach], [hoTen], [diaChi], [email], [sdt], [tenDangNhap], [matKhau], [trangThai]) VALUES (10, N'Phạm Thị Hậu', N'Thái Bình', N'hauhp@gmail.com', N'0123456789', N'hauhp', N'1911', 1)
INSERT [dbo].[KhachHang] ([idKhach], [hoTen], [diaChi], [email], [sdt], [tenDangNhap], [matKhau], [trangThai]) VALUES (11, N'Vũ Minh Tuấn', N'Hà Đông, Hà Nội', N'tuanvm@gmail.com', N'0981455462', N'tuanvm', N'1911', 1)
INSERT [dbo].[KhachHang] ([idKhach], [hoTen], [diaChi], [email], [sdt], [tenDangNhap], [matKhau], [trangThai]) VALUES (12, N'Phương', N'', N'tranduc102113@gmail.com', N'1         ', N'1', N'1111', NULL)
SET IDENTITY_INSERT [dbo].[KhachHang] OFF
GO
SET IDENTITY_INSERT [dbo].[LienHe] ON 

INSERT [dbo].[LienHe] ([IdLienHe], [Ho], [Ten], [Email], [SDT], [NoiDung], [idKhach], [NgayTao]) VALUES (2016, N'Tran', N'Duc', N'tranduc102113@gmail.com', N'2', N'111111', NULL, CAST(N'2022-03-09T22:05:59.810' AS DateTime))
INSERT [dbo].[LienHe] ([IdLienHe], [Ho], [Ten], [Email], [SDT], [NoiDung], [idKhach], [NgayTao]) VALUES (2022, N'1', N'1', N'tranduc102113@gmail.com', N'1', N'111', NULL, CAST(N'2022-03-14T12:32:45.057' AS DateTime))
SET IDENTITY_INSERT [dbo].[LienHe] OFF
GO
SET IDENTITY_INSERT [dbo].[LoaiSp] ON 

INSERT [dbo].[LoaiSp] ([idLoai], [tenLoaiSp], [trangThai], [idUser]) VALUES (1, N'SamSung', NULL, NULL)
SET IDENTITY_INSERT [dbo].[LoaiSp] OFF
GO
SET IDENTITY_INSERT [dbo].[SanPham] ON 

INSERT [dbo].[SanPham] ([idSp], [ten], [moTa], [chiTiet], [gia], [giaKm], [trangThai], [idLoai], [idThuongHieu], [idUser], [soLuong], [trangThaiMieuTa], [anhDaiDien], [MieuTaSanPhamNoiBat]) VALUES (1, N'MSI Model 14', N'', N'', 2500000, 2000000, 1, 1, 1, 2, 5, N'NEW', N'Anh3.jpg', N'-20%')
INSERT [dbo].[SanPham] ([idSp], [ten], [moTa], [chiTiet], [gia], [giaKm], [trangThai], [idLoai], [idThuongHieu], [idUser], [soLuong], [trangThaiMieuTa], [anhDaiDien], [MieuTaSanPhamNoiBat]) VALUES (2, N'ACE Swift 3', N'', N'', 7000000, 6000000, 3, 1, 1, 2, 4, N'1', N'Anh4.png', N'HOT')
INSERT [dbo].[SanPham] ([idSp], [ten], [moTa], [chiTiet], [gia], [giaKm], [trangThai], [idLoai], [idThuongHieu], [idUser], [soLuong], [trangThaiMieuTa], [anhDaiDien], [MieuTaSanPhamNoiBat]) VALUES (3, N'Dell Persition 5510', N'', N'', 6900000, 6200000, 1, 1, 2, 2, 3, N'NEW', N'Anh1.jpg', N'-30%')
INSERT [dbo].[SanPham] ([idSp], [ten], [moTa], [chiTiet], [gia], [giaKm], [trangThai], [idLoai], [idThuongHieu], [idUser], [soLuong], [trangThaiMieuTa], [anhDaiDien], [MieuTaSanPhamNoiBat]) VALUES (4, N'Dell Persition 5520', N'', N'', 8000000, 7800000, 1, 1, 1, 2, 5, N'NEW', N'Anh5.jpg', N'HOT')
INSERT [dbo].[SanPham] ([idSp], [ten], [moTa], [chiTiet], [gia], [giaKm], [trangThai], [idLoai], [idThuongHieu], [idUser], [soLuong], [trangThaiMieuTa], [anhDaiDien], [MieuTaSanPhamNoiBat]) VALUES (5, N'Dell latitus 3', N'', N'', 8000000, 7690000, 2, 1, 1, 2, 3, N'--9%', N'Anh6.jpg', N'-50%')
INSERT [dbo].[SanPham] ([idSp], [ten], [moTa], [chiTiet], [gia], [giaKm], [trangThai], [idLoai], [idThuongHieu], [idUser], [soLuong], [trangThaiMieuTa], [anhDaiDien], [MieuTaSanPhamNoiBat]) VALUES (6, N'HP ProBook 15', N'', N'', 9500000, 9450000, 1, 1, 2, 2, 16, N'NEW', N'Anh7.jpg', N'NEW')
INSERT [dbo].[SanPham] ([idSp], [ten], [moTa], [chiTiet], [gia], [giaKm], [trangThai], [idLoai], [idThuongHieu], [idUser], [soLuong], [trangThaiMieuTa], [anhDaiDien], [MieuTaSanPhamNoiBat]) VALUES (7, N'HP Zbook 15 G1', N'', N'', 4490000, 4490000, 3, 1, 2, 2, 19, N'1', N'Anh8.jpg', N'HOT')
INSERT [dbo].[SanPham] ([idSp], [ten], [moTa], [chiTiet], [gia], [giaKm], [trangThai], [idLoai], [idThuongHieu], [idUser], [soLuong], [trangThaiMieuTa], [anhDaiDien], [MieuTaSanPhamNoiBat]) VALUES (9, N'HP Zbook 15 G2', N'', N'', 7900000, 7800000, 2, 1, 1, 2, 14, N'-0%', N'Anh9.jpg', NULL)
INSERT [dbo].[SanPham] ([idSp], [ten], [moTa], [chiTiet], [gia], [giaKm], [trangThai], [idLoai], [idThuongHieu], [idUser], [soLuong], [trangThaiMieuTa], [anhDaiDien], [MieuTaSanPhamNoiBat]) VALUES (10, N'HP Zbook 15 G3', N'', N'', 8900000, 8800000, 5, 1, 2, 2, 15, N'HOT', N'Anh10.png', N'NEW')
INSERT [dbo].[SanPham] ([idSp], [ten], [moTa], [chiTiet], [gia], [giaKm], [trangThai], [idLoai], [idThuongHieu], [idUser], [soLuong], [trangThaiMieuTa], [anhDaiDien], [MieuTaSanPhamNoiBat]) VALUES (11, N'Laptop MSI Gaming GF65', N'', N'', 3500000, 2000000, 2, 1, 1, 2, 20, N'-0%', N'Anh11.jpg', N'-30%')
INSERT [dbo].[SanPham] ([idSp], [ten], [moTa], [chiTiet], [gia], [giaKm], [trangThai], [idLoai], [idThuongHieu], [idUser], [soLuong], [trangThaiMieuTa], [anhDaiDien], [MieuTaSanPhamNoiBat]) VALUES (12, N'MSI Gaming GF63', N'', N'', 2000000, 1900000, 2, 1, 1, 2, 10, N'-0%', N'Anh12.jpg', N'HOT')
INSERT [dbo].[SanPham] ([idSp], [ten], [moTa], [chiTiet], [gia], [giaKm], [trangThai], [idLoai], [idThuongHieu], [idUser], [soLuong], [trangThaiMieuTa], [anhDaiDien], [MieuTaSanPhamNoiBat]) VALUES (13, N' MSI Gaming Katana ', N'', N'', 3900000, 3900000, 4, NULL, 3, 2, 13, NULL, N'Anh13.jpg', NULL)
INSERT [dbo].[SanPham] ([idSp], [ten], [moTa], [chiTiet], [gia], [giaKm], [trangThai], [idLoai], [idThuongHieu], [idUser], [soLuong], [trangThaiMieuTa], [anhDaiDien], [MieuTaSanPhamNoiBat]) VALUES (14, N'MSI GL65', N'', N'', 9990000, 9790000, 2, NULL, 1, 2, 12, N'-0%', N'Anh14.jpg', NULL)
INSERT [dbo].[SanPham] ([idSp], [ten], [moTa], [chiTiet], [gia], [giaKm], [trangThai], [idLoai], [idThuongHieu], [idUser], [soLuong], [trangThaiMieuTa], [anhDaiDien], [MieuTaSanPhamNoiBat]) VALUES (15, N'Lenovo Yoga 7', N'', N'', 9900000, 9490000, 2, NULL, 1, 1, 12, N'-4%', N'Anh15.jpg', NULL)
INSERT [dbo].[SanPham] ([idSp], [ten], [moTa], [chiTiet], [gia], [giaKm], [trangThai], [idLoai], [idThuongHieu], [idUser], [soLuong], [trangThaiMieuTa], [anhDaiDien], [MieuTaSanPhamNoiBat]) VALUES (16, N'Lenovo ThinkBook 14s G2', N'', N'', 5900000, 5490000, 1, NULL, 6, 2, 13, N'NEW', N'Anh16.jpg', NULL)
INSERT [dbo].[SanPham] ([idSp], [ten], [moTa], [chiTiet], [gia], [giaKm], [trangThai], [idLoai], [idThuongHieu], [idUser], [soLuong], [trangThaiMieuTa], [anhDaiDien], [MieuTaSanPhamNoiBat]) VALUES (17, N'Lenovo ThinkBook 14s Yoga', N'', N'', 3900000, 3600000, 5, NULL, 5, 2, 15, N'HOT', N'Anh9.jpg', NULL)
INSERT [dbo].[SanPham] ([idSp], [ten], [moTa], [chiTiet], [gia], [giaKm], [trangThai], [idLoai], [idThuongHieu], [idUser], [soLuong], [trangThaiMieuTa], [anhDaiDien], [MieuTaSanPhamNoiBat]) VALUES (19, N'Lenovo Ideapad 5 Pro', N'', N'', 9000000, 11, 1, NULL, 2, 2, 17, N'NEW', N'Anh10.png', NULL)
INSERT [dbo].[SanPham] ([idSp], [ten], [moTa], [chiTiet], [gia], [giaKm], [trangThai], [idLoai], [idThuongHieu], [idUser], [soLuong], [trangThaiMieuTa], [anhDaiDien], [MieuTaSanPhamNoiBat]) VALUES (20, N'Lenovo IdeaPad 5', N'', N'', 8000000, NULL, 1, NULL, 2, 2, 16, N'NEW', N'Anh18.jpg', NULL)
INSERT [dbo].[SanPham] ([idSp], [ten], [moTa], [chiTiet], [gia], [giaKm], [trangThai], [idLoai], [idThuongHieu], [idUser], [soLuong], [trangThaiMieuTa], [anhDaiDien], [MieuTaSanPhamNoiBat]) VALUES (1019, N'SanPham1', N'', N'', 5000, NULL, 3, NULL, 2, 2, 0, NULL, N'acer.png', NULL)
INSERT [dbo].[SanPham] ([idSp], [ten], [moTa], [chiTiet], [gia], [giaKm], [trangThai], [idLoai], [idThuongHieu], [idUser], [soLuong], [trangThaiMieuTa], [anhDaiDien], [MieuTaSanPhamNoiBat]) VALUES (2019, N'SanPham1', N'SanPham1		                            ', N'SanPham1		                            ', 150000, NULL, 1, NULL, 1, 2, 2, N'NEW', N'581_hp_pavilion_x360_ph_1.png', NULL)
SET IDENTITY_INSERT [dbo].[SanPham] OFF
GO
SET IDENTITY_INSERT [dbo].[ThuongHieu] ON 

INSERT [dbo].[ThuongHieu] ([idThuongHieu], [tenThuongHieu], [idUser]) VALUES (1, N'Dell', 1)
INSERT [dbo].[ThuongHieu] ([idThuongHieu], [tenThuongHieu], [idUser]) VALUES (2, N'Lenovo', 2)
INSERT [dbo].[ThuongHieu] ([idThuongHieu], [tenThuongHieu], [idUser]) VALUES (3, N'Ace', 3)
INSERT [dbo].[ThuongHieu] ([idThuongHieu], [tenThuongHieu], [idUser]) VALUES (4, N'Imac', 2)
INSERT [dbo].[ThuongHieu] ([idThuongHieu], [tenThuongHieu], [idUser]) VALUES (5, N'MSI', 1)
INSERT [dbo].[ThuongHieu] ([idThuongHieu], [tenThuongHieu], [idUser]) VALUES (6, N'Huawei', 2)
SET IDENTITY_INSERT [dbo].[ThuongHieu] OFF
GO
SET IDENTITY_INSERT [dbo].[TinTuc] ON 

INSERT [dbo].[TinTuc] ([idTin], [tieuDe], [anh], [noiDung], [ngayTao], [idUser]) VALUES (1, N'Một số thuộc tính xử lý Text trong CSS', N'22.jpg', N'is an American multinational technology company that specializes in consumer electronics, computer software and online services. Apple is the largest information technology company by revenue (totaling $274.5 billion in 2020) and, since January 2021, the world''s most valuable company. As of 2021, Apple is the fourth-largest PC vendor by unit sales[9] and fourth-largest smartphone manufacturer.[10][11] It is one of the Big Five American information technology companies, alongside Amazon, Google (Alphabet), Facebook (Meta), and Microsoft.[12][13][14]', CAST(N'2021-12-23T22:45:06.533' AS DateTime), NULL)
INSERT [dbo].[TinTuc] ([idTin], [tieuDe], [anh], [noiDung], [ngayTao], [idUser]) VALUES (2, N'Thuộc tính text-overflow dùng để xử lý một đoạn text bị tràn ra', N'35.png', N'Apple was founded in 1976 by Steve Jobs, Steve Wozniak and Ronald Wayne to develop and sell Wozniak''s Apple I personal computer. It was incorporated by Jobs and Wozniak as Apple Computer, Inc. in 1977, and sales of its computers, among them the Apple II, grew quickly. It went public in 1980, to instant financial success. Over the next few years, Apple shipped new computers featuring innovative graphical user interfaces, such as the original Macintosh, announced in a critically acclaimed advertisement, "1984", directed by Ridley Scott. The high cost of its products and limited application library caused problems, as did power struggles between executives. In 1985, Wozniak departed Apple amicably,[15] while Jobs resigned to found NeXT, taking some Apple employees with him.[1', CAST(N'2021-12-23T22:45:18.017' AS DateTime), NULL)
INSERT [dbo].[TinTuc] ([idTin], [tieuDe], [anh], [noiDung], [ngayTao], [idUser]) VALUES (3, N'Hiển thị nội dung bị tràn khi di chuột qua phần tử', N'24.jpg', N'As the market for personal computers expanded and evolved throughout the 1990s, Apple lost considerable market share to the lower-priced duopoly of Microsoft Windows on Intel PC clones. The board recruited CEO Gil Amelio, who prepared the struggling company for eventual success with extensive reforms, product focus and layoffs in his 500-day tenure. In 1997, Amelio bought NeXT to resolve Apple''s unsuccessful operating-system strategy and entice Jobs back to the company; he replaced Amelio. Apple became profitable again through a number of tactics. First, a revitalizing campaign called "Think different", and by launching the iMac and iPod. In 2001, it opened a retail chain, the Apple Stores, and has acquired numerous companies to broaden its software portfolio. In 2007, the company launched the iPhone to critical acclaim and financial success. Jobs resigned in 2011 for health reasons, and died two months later. He was succeeded as CEO by Tim Cook.

The company receives significant criticism regarding the labor practices of its contractors, its environmental practices,', CAST(N'2021-12-23T22:44:56.387' AS DateTime), NULL)
INSERT [dbo].[TinTuc] ([idTin], [tieuDe], [anh], [noiDung], [ngayTao], [idUser]) VALUES (4, N'Thuộc tính word-wrap cho phép đoạn text xuống dòng nếu quá', N'1.jpg', N'Apple became the first publicly traded U.S. company to be valued at over $1 trillion,[17][18] and, two years later, the first valued at over $2 trillion.[19][20] The company enjoys a high level of brand loyalty, and is ranked as the world''s most valuable brand; as of January 2021, there are 1.65 billion Apple products in active use.[21]', CAST(N'2021-03-02T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[TinTuc] ([idTin], [tieuDe], [anh], [noiDung], [ngayTao], [idUser]) VALUES (5, N'Word-wrap xác định có xuống dòng hay không, còn thuộc tính ', N'19.jpg', N'Apple Computer, Inc. was incorporated on January 3, 1977,[38][39] without Wayne, who had left and sold his share of the company back to Jobs and Wozniak for $800 only twelve days after having co-founded Apple.[40][41] Multimillionaire Mike Markkula provided essential business expertise and funding of US$250,000 (equivalent to $1,067,683 in 2020) to Jobs and Wozniak during the incorporation of Apple.[42][43] During the first five years of operations, revenues grew exponentially, doubling about every four months. Between September 1977 and September 1980, yearly sales grew from $775,000 to $118 million, an average annual growth rate of 533%.[44][45]', CAST(N'2021-12-23T22:44:32.873' AS DateTime), NULL)
INSERT [dbo].[TinTuc] ([idTin], [tieuDe], [anh], [noiDung], [ngayTao], [idUser]) VALUES (6, N'Nếu là văn bản bình thường, ta sẽ dùng break-word nhiều hơn,', N'12.jfif', N'Nếu là văn bản bình thường, ta sẽ dùng break-word nhiều hơn,', CAST(N'2021-12-23T22:44:39.807' AS DateTime), NULL)
INSERT [dbo].[TinTuc] ([idTin], [tieuDe], [anh], [noiDung], [ngayTao], [idUser]) VALUES (10, N'', N'', N'', CAST(N'1900-01-01T00:00:00.000' AS DateTime), NULL)
INSERT [dbo].[TinTuc] ([idTin], [tieuDe], [anh], [noiDung], [ngayTao], [idUser]) VALUES (11, N'Cách ẩn thư mục bí mật khỏi kết quả tìm kiếm trên Windows 10', N'windows11.jpg', N'<p style="margin-right: 0px; margin-bottom: 20px; margin-left: 0px; padding: 0px; border: 0px; font-size: 18px; vertical-align: baseline; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; color: rgb(51, 51, 51); line-height: 33px; font-family: Roboto, sans-serif; text-align: justify;">Theo mặc định,&nbsp;<a href="https://fptshop.com.vn/tin-tuc/tags/windows-11" style="margin: 0px; padding: 0px; outline: none; color: rgb(1, 104, 250); vertical-align: baseline; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">Windows 11</a>&nbsp;tìm kiếm các mục trong thư mục Documents, Pictures, Music và Desktop. Khi bạn ẩn một thư mục khỏi kết quả tìm kiếm, Windows 11 sẽ ngừng tìm kiếm trong thư mục đó để tìm nội dung. Dưới đây là cách để thêm thư mục đó vào danh sách thư mục bị loại trừ khỏi công cụ tìm kiếm trong ứng dụng Settings.&nbsp;</p><p style="margin-right: 0px; margin-bottom: 20px; margin-left: 0px; padding: 0px; border: 0px; font-size: 18px; vertical-align: baseline; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; color: rgb(51, 51, 51); line-height: 33px; font-family: Roboto, sans-serif; text-align: justify;"><strong style="margin: 0px; padding: 0px; border: 0px; vertical-align: baseline; background: transparent; font-weight: bold;">Bước 1.&nbsp;</strong>Để bắt đầu ẩn một thư mục trong kết quả tìm kiếm, trước tiên, hãy mở&nbsp;<a href="https://fptshop.com.vn/tin-tuc/thu-thuat/cach-sua-loi-ung-dung-settings-tren-windows-11-141195''" style="margin: 0px; padding: 0px; outline: none; color: rgb(1, 104, 250); vertical-align: baseline; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">ứng dụng Settings trên Windows 11</a>&nbsp;bằng cách. Truy cập vào menu&nbsp;<em style="margin: 0px; padding: 0px; border: 0px; font-weight: inherit; vertical-align: baseline; background: transparent;"><strong style="margin: 0px; padding: 0px; border: 0px; vertical-align: baseline; background: transparent; font-weight: bold;">Start &gt; Settings.</strong></em></p><p style="margin-right: 0px; margin-bottom: 20px; margin-left: 0px; padding: 0px; border: 0px; font-size: 18px; vertical-align: baseline; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; color: rgb(51, 51, 51); line-height: 33px; font-family: Roboto, sans-serif; text-align: center;"><img alt="Cách ẩn thư mục bí mật khỏi kết quả tìm kiếm trên Windows 11 (1)" src="https://images.fpt.shop/unsafe/filters:quality(90)/fptshop.com.vn/uploads/images/tin-tuc/141652/Originals/windows-11-start-settings.png" style="margin: 0px 0px -5px; padding: 0px; border: 0px; background: transparent; max-width: 100%; height: 662px; width: 750px;"></p><p style="margin-right: 0px; margin-bottom: 20px; margin-left: 0px; padding: 0px; border: 0px; font-size: 18px; vertical-align: baseline; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; color: rgb(51, 51, 51); line-height: 33px; font-family: Roboto, sans-serif; text-align: justify;">Nhấn tổ hợp phím&nbsp;<em style="margin: 0px; padding: 0px; border: 0px; font-weight: inherit; vertical-align: baseline; background: transparent;"><strong style="margin: 0px; padding: 0px; border: 0px; vertical-align: baseline; background: transparent; font-weight: bold;">Windows + I</strong></em>&nbsp;để thực hiện, hoặc nhấn&nbsp;<em style="margin: 0px; padding: 0px; border: 0px; font-weight: inherit; vertical-align: baseline; background: transparent;"><strong style="margin: 0px; padding: 0px; border: 0px; vertical-align: baseline; background: transparent; font-weight: bold;">Windows + X&nbsp;</strong></em>để kích hoạt menu lệnh và chọn&nbsp;<em style="margin: 0px; padding: 0px; border: 0px; font-weight: inherit; vertical-align: baseline; background: transparent;"><strong style="margin: 0px; padding: 0px; border: 0px; vertical-align: baseline; background: transparent; font-weight: bold;">Settings.&nbsp;</strong></em></p><p style="margin-right: 0px; margin-bottom: 20px; margin-left: 0px; padding: 0px; border: 0px; font-size: 18px; vertical-align: baseline; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; color: rgb(51, 51, 51); line-height: 33px; font-family: Roboto, sans-serif; text-align: justify;"><strong style="margin: 0px; padding: 0px; border: 0px; vertical-align: baseline; background: transparent; font-weight: bold;">Bước 2.&nbsp;</strong>Trong cửa sổ<em style="margin: 0px; padding: 0px; border: 0px; font-weight: inherit; vertical-align: baseline; background: transparent;">&nbsp;Settings&nbsp;</em>hiển thị chọn tùy chọn<em style="margin: 0px; padding: 0px; border: 0px; font-weight: inherit; vertical-align: baseline; background: transparent;"><strong style="margin: 0px; padding: 0px; border: 0px; vertical-align: baseline; background: transparent; font-weight: bold;">&nbsp;Privacy &amp; Security&nbsp;</strong></em>ở khung bên trái.&nbsp;</p><p style="margin-right: 0px; margin-bottom: 20px; margin-left: 0px; padding: 0px; border: 0px; font-size: 18px; vertical-align: baseline; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; color: rgb(51, 51, 51); line-height: 33px; font-family: Roboto, sans-serif; text-align: center;"><img alt="Cách ẩn thư mục bí mật khỏi kết quả tìm kiếm trên Windows 11 (2)" src="https://images.fpt.shop/unsafe/filters:quality(90)/fptshop.com.vn/uploads/images/tin-tuc/141652/Originals/windows-11-searching-windows.png" style="margin: 0px 0px -5px; padding: 0px; border: 0px; background: transparent; max-width: 100%; height: 569px; width: 750px;"></p><p style="margin-right: 0px; margin-bottom: 20px; margin-left: 0px; padding: 0px; border: 0px; font-size: 18px; vertical-align: baseline; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; color: rgb(51, 51, 51); line-height: 33px; font-family: Roboto, sans-serif; text-align: justify;"><strong style="margin: 0px; padding: 0px; border: 0px; vertical-align: baseline; background: transparent; font-weight: bold;">Bước 3.&nbsp;</strong>Ở khung bên phải chọn tùy chọn&nbsp;<em style="margin: 0px; padding: 0px; border: 0px; font-weight: inherit; vertical-align: baseline; background: transparent;"><strong style="margin: 0px; padding: 0px; border: 0px; vertical-align: baseline; background: transparent; font-weight: bold;">Searching Windows&nbsp;</strong></em>bên dưới mục&nbsp;<em style="margin: 0px; padding: 0px; border: 0px; font-weight: inherit; vertical-align: baseline; background: transparent;">Windows Permissions.</em></p>', CAST(N'2022-02-26T10:06:18.573' AS DateTime), 2)
INSERT [dbo].[TinTuc] ([idTin], [tieuDe], [anh], [noiDung], [ngayTao], [idUser]) VALUES (13, N'Iphone 12', N'iphone12xanh.jpg', N'<p>Thiết kế mới nguyên khối mỏng nhất trong các siêu phẩm của Apple</p><p>Ngay từ buổi lễ ra mắt, các nhà thiết kế của Apple đã khẳng định đây là chiếc điện thoại mỏng nhất mà họ từng làm, iPhone 12 sở hữu những thông số về kích thước thật đáng kinh ngạc, máy mỏng chỉ 7.6 mm và trọng lượng chưa tới 112g, nếu đem ra so sánh với các smartphone hiện nay thì iPhone 12 thực sự là một trong những chiếc điện thoại mỏng nhất, nhẹ nhất</p>', CAST(N'2021-12-29T16:35:04.547' AS DateTime), 1)
INSERT [dbo].[TinTuc] ([idTin], [tieuDe], [anh], [noiDung], [ngayTao], [idUser]) VALUES (14, N'11222', N'engadgetgs65_800x500.jpg', N'<p>1111111111111111</p>', CAST(N'2022-02-26T10:02:37.523' AS DateTime), 2)
SET IDENTITY_INSERT [dbo].[TinTuc] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([idUser], [hoTen], [tenDangNhap], [matKhau], [quyen], [trangThai]) VALUES (1, N'Đào Đức Anh', N'anhdd', N'1911', 0, 1)
INSERT [dbo].[Users] ([idUser], [hoTen], [tenDangNhap], [matKhau], [quyen], [trangThai]) VALUES (2, N'Trần Hữu Đức', N'ducth', N'1911', 1, 1)
INSERT [dbo].[Users] ([idUser], [hoTen], [tenDangNhap], [matKhau], [quyen], [trangThai]) VALUES (3, N'Lưu Ngọc Lan', N'lanln', N'1911', 0, 1)
INSERT [dbo].[Users] ([idUser], [hoTen], [tenDangNhap], [matKhau], [quyen], [trangThai]) VALUES (4, NULL, N'hanh', N'1911', 1, 1)
INSERT [dbo].[Users] ([idUser], [hoTen], [tenDangNhap], [matKhau], [quyen], [trangThai]) VALUES (5, NULL, N'admin', N'123456', 0, 1)
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
ALTER TABLE [dbo].[Anh]  WITH CHECK ADD  CONSTRAINT [FK_Anh_SanPham] FOREIGN KEY([idSp])
REFERENCES [dbo].[SanPham] ([idSp])
GO
ALTER TABLE [dbo].[Anh] CHECK CONSTRAINT [FK_Anh_SanPham]
GO
ALTER TABLE [dbo].[CT_DonHang]  WITH CHECK ADD  CONSTRAINT [FK_CT_DonHang_DonHang] FOREIGN KEY([idDon])
REFERENCES [dbo].[DonHang] ([idDon])
GO
ALTER TABLE [dbo].[CT_DonHang] CHECK CONSTRAINT [FK_CT_DonHang_DonHang]
GO
ALTER TABLE [dbo].[CT_DonHang]  WITH CHECK ADD  CONSTRAINT [FK_CT_DonHang_SanPham] FOREIGN KEY([idSp])
REFERENCES [dbo].[SanPham] ([idSp])
GO
ALTER TABLE [dbo].[CT_DonHang] CHECK CONSTRAINT [FK_CT_DonHang_SanPham]
GO
ALTER TABLE [dbo].[DanhGia]  WITH CHECK ADD  CONSTRAINT [FK_DanhGia_KhachHang] FOREIGN KEY([idKhach])
REFERENCES [dbo].[KhachHang] ([idKhach])
GO
ALTER TABLE [dbo].[DanhGia] CHECK CONSTRAINT [FK_DanhGia_KhachHang]
GO
ALTER TABLE [dbo].[DanhGia]  WITH CHECK ADD  CONSTRAINT [FK_DanhGia_SanPham] FOREIGN KEY([idSp])
REFERENCES [dbo].[SanPham] ([idSp])
GO
ALTER TABLE [dbo].[DanhGia] CHECK CONSTRAINT [FK_DanhGia_SanPham]
GO
ALTER TABLE [dbo].[DonHang]  WITH CHECK ADD  CONSTRAINT [FK_DonHang_KhachHang] FOREIGN KEY([idKhach])
REFERENCES [dbo].[KhachHang] ([idKhach])
GO
ALTER TABLE [dbo].[DonHang] CHECK CONSTRAINT [FK_DonHang_KhachHang]
GO
ALTER TABLE [dbo].[LienHe]  WITH CHECK ADD  CONSTRAINT [FK_LienHe_KhachHang] FOREIGN KEY([idKhach])
REFERENCES [dbo].[KhachHang] ([idKhach])
GO
ALTER TABLE [dbo].[LienHe] CHECK CONSTRAINT [FK_LienHe_KhachHang]
GO
ALTER TABLE [dbo].[SanPham]  WITH CHECK ADD  CONSTRAINT [FK_SanPham_LoaiSp] FOREIGN KEY([idLoai])
REFERENCES [dbo].[LoaiSp] ([idLoai])
GO
ALTER TABLE [dbo].[SanPham] CHECK CONSTRAINT [FK_SanPham_LoaiSp]
GO
ALTER TABLE [dbo].[SanPham]  WITH CHECK ADD  CONSTRAINT [FK_SanPham_ThuongHieu] FOREIGN KEY([idThuongHieu])
REFERENCES [dbo].[ThuongHieu] ([idThuongHieu])
GO
ALTER TABLE [dbo].[SanPham] CHECK CONSTRAINT [FK_SanPham_ThuongHieu]
GO
/****** Object:  StoredProcedure [dbo].[BaoCaoDoanhThuThang]    Script Date: 3/14/2022 9:12:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[BaoCaoDoanhThuThang]
(
	@Thang INT,
    @Nam INT
)
as
BEGIN
	DECLARE @NgayThongKeBD NVARCHAR(50);
	DECLARE @NgayThongKeKT NVARCHAR(50);
    
	if @Thang<10
    BEGIN
        SET @NgayThongKeBD =CONVERT(varchar(10),@nam)+'-0'+CONVERT(varchar(10),@Thang)+'-0'+CONVERT(varchar(10),1)+' 00:00:00.000';
	    SET @NgayThongKeKT =CONVERT(varchar(10),@nam)+'-0'+CONVERT(varchar(10),@Thang)+'-0'+CONVERT(varchar(10),1)+' 23:59:38.020';
    END
    ELSE
	BEGIN
		SET @NgayThongKeBD =CONVERT(varchar(10),@nam)+'-'+CONVERT(varchar(10),@Thang)+'-0'+CONVERT(varchar(10),1)+' 00:00:00.000';
	    SET @NgayThongKeKT =CONVERT(varchar(10),@nam)+'-'+CONVERT(varchar(10),@Thang)+'-0'+CONVERT(varchar(10),1)+' 23:59:38.020';
	END
	
	declare @BangPhu table (Thang int, TongTien float)

	DECLARE @TongTien float;
    SET @TongTien=(select SUM(tongTien) from DonHang as dh
	               where dh.ngayDat between @NgayThongKeBD and @NgayThongKeKT and trangThai='True');
    if @TongTien is NULL
    BEGIN
       SET @TongTien=0;
    END

	insert into @BangPhu
	(Thang,TongTien)
	values
	(@Thang,@TongTien)

	IF @Thang=1 or @Thang=3 or @Thang=5 or @Thang=7 or @Thang=8 or @Thang=10 or @Thang=12
	BEGIN
		SELECT n1.TongTien as N1,n2.TongTien as N2,n3.TongTien as N3,n4.TongTien as N4
		,n5.TongTien as N5,n6.TongTien as N6,n7.TongTien as N7,n8.TongTien as N8,n9.TongTien as N9,n10.TongTien as N10
		,n11.TongTien as N11,n12.TongTien as N12,n13.TongTien as N13,n14.TongTien as N14,n15.TongTien as N15,n16.TongTien as N16,n17.TongTien as N17
		,n18.TongTien as N18,n19.TongTien as N19,n20.TongTien as N20,n21.TongTien as N21,n22.TongTien as N22,n23.TongTien as N23,n24.TongTien as N24
		,n25.TongTien as N25,n26.TongTien as N26,n27.TongTien as N27,n28.TongTien as N28,n29.TongTien as N29,n30.TongTien as N30,n31.TongTien as N31
		from @BangPhu as n1
		Cross apply DlNgay(@Thang,@Nam,2) as n2
		Cross apply DlNgay(@Thang,@Nam,3) as n3
		Cross apply DlNgay(@Thang,@Nam,4) as n4
		Cross apply DlNgay(@Thang,@Nam,5) as n5
		Cross apply DlNgay(@Thang,@Nam,6) as n6
		Cross apply DlNgay(@Thang,@Nam,7) as n7
		Cross apply DlNgay(@Thang,@Nam,8) as n8
		Cross apply DlNgay(@Thang,@Nam,9) as n9
		Cross apply DlNgay(@Thang,@Nam,10) as n10
		Cross apply DlNgay(@Thang,@Nam,11) as n11
		Cross apply DlNgay(@Thang,@Nam,12) as n12
		Cross apply DlNgay(@Thang,@Nam,13) as n13
		Cross apply DlNgay(@Thang,@Nam,14) as n14
		Cross apply DlNgay(@Thang,@Nam,15) as n15
		Cross apply DlNgay(@Thang,@Nam,16) as n16
		Cross apply DlNgay(@Thang,@Nam,17) as n17
		Cross apply DlNgay(@Thang,@Nam,18) as n18
		Cross apply DlNgay(@Thang,@Nam,19) as n19
		Cross apply DlNgay(@Thang,@Nam,20) as n20
		Cross apply DlNgay(@Thang,@Nam,21) as n21
		Cross apply DlNgay(@Thang,@Nam,22) as n22
		Cross apply DlNgay(@Thang,@Nam,23) as n23
		Cross apply DlNgay(@Thang,@Nam,24) as n24
		Cross apply DlNgay(@Thang,@Nam,25) as n25
		Cross apply DlNgay(@Thang,@Nam,26) as n26
		Cross apply DlNgay(@Thang,@Nam,27) as n27
		Cross apply DlNgay(@Thang,@Nam,28) as n28
		Cross apply DlNgay(@Thang,@Nam,29) as n29
		Cross apply DlNgay(@Thang,@Nam,30) as n30
		Cross apply DlNgay(@Thang,@Nam,31) as n31
		where n1.Thang=n2.Thang and n2.Thang=n3.Thang and n4.Thang=n3.Thang
		and n4.Thang=n5.Thang and n6.Thang=n5.Thang and n6.Thang=n7.Thang
		and n8.Thang=n7.Thang and n8.Thang=n9.Thang and n10.Thang=n9.Thang
		and n10.Thang=n11.Thang and n11.Thang=n12.Thang and n13.Thang=n12.Thang
		and n13.Thang=n14.Thang and n15.Thang=n14.Thang and n15.Thang=n16.Thang
		and n17.Thang=n16.Thang and n17.Thang=n18.Thang and n19.Thang=n18.Thang
		and n19.Thang=n20.Thang and n21.Thang=n20.Thang and n21.Thang=n22.Thang
		and n23.Thang=n22.Thang and n23.Thang=n24.Thang and n25.Thang=n24.Thang
		and n25.Thang=n26.Thang and n27.Thang=n26.Thang and n27.Thang=n28.Thang
		and n29.Thang=n28.Thang and n29.Thang=n30.Thang and n31.Thang=n30.Thang
	END

	IF @Thang=4 or @Thang=6 or @Thang=9 or @Thang=11
	BEGIN
		SELECT n1.TongTien as N1,n2.TongTien as N2,n3.TongTien as N3,n4.TongTien as N4
		,n5.TongTien as N5,n6.TongTien as N6,n7.TongTien as N7,n8.TongTien as N8,n9.TongTien as N9,n10.TongTien as N10
		,n11.TongTien as N11,n12.TongTien as N12,n13.TongTien as N13,n14.TongTien as N14,n15.TongTien as N15,n16.TongTien as N16,n17.TongTien as N17
		,n18.TongTien as N18,n19.TongTien as N19,n20.TongTien as N20,n21.TongTien as N21,n22.TongTien as N22,n23.TongTien as N23,n24.TongTien as N24
		,n25.TongTien as N25,n26.TongTien as N26,n27.TongTien as N27,n28.TongTien as N28,n29.TongTien as N29,n30.TongTien as N30
		from @BangPhu as n1
		Cross apply DlNgay(@Thang,@Nam,2) as n2
		Cross apply DlNgay(@Thang,@Nam,3) as n3
		Cross apply DlNgay(@Thang,@Nam,4) as n4
		Cross apply DlNgay(@Thang,@Nam,5) as n5
		Cross apply DlNgay(@Thang,@Nam,6) as n6
		Cross apply DlNgay(@Thang,@Nam,7) as n7
		Cross apply DlNgay(@Thang,@Nam,8) as n8
		Cross apply DlNgay(@Thang,@Nam,9) as n9
		Cross apply DlNgay(@Thang,@Nam,10) as n10
		Cross apply DlNgay(@Thang,@Nam,11) as n11
		Cross apply DlNgay(@Thang,@Nam,12) as n12
		Cross apply DlNgay(@Thang,@Nam,13) as n13
		Cross apply DlNgay(@Thang,@Nam,14) as n14
		Cross apply DlNgay(@Thang,@Nam,15) as n15
		Cross apply DlNgay(@Thang,@Nam,16) as n16
		Cross apply DlNgay(@Thang,@Nam,17) as n17
		Cross apply DlNgay(@Thang,@Nam,18) as n18
		Cross apply DlNgay(@Thang,@Nam,19) as n19
		Cross apply DlNgay(@Thang,@Nam,20) as n20
		Cross apply DlNgay(@Thang,@Nam,21) as n21
		Cross apply DlNgay(@Thang,@Nam,22) as n22
		Cross apply DlNgay(@Thang,@Nam,23) as n23
		Cross apply DlNgay(@Thang,@Nam,24) as n24
		Cross apply DlNgay(@Thang,@Nam,25) as n25
		Cross apply DlNgay(@Thang,@Nam,26) as n26
		Cross apply DlNgay(@Thang,@Nam,27) as n27
		Cross apply DlNgay(@Thang,@Nam,28) as n28
		Cross apply DlNgay(@Thang,@Nam,29) as n29
		Cross apply DlNgay(@Thang,@Nam,30) as n30
		where n1.Thang=n2.Thang and n2.Thang=n3.Thang and n4.Thang=n3.Thang
		and n4.Thang=n5.Thang and n6.Thang=n5.Thang and n6.Thang=n7.Thang
		and n8.Thang=n7.Thang and n8.Thang=n9.Thang and n10.Thang=n9.Thang
		and n10.Thang=n11.Thang and n11.Thang=n12.Thang and n13.Thang=n12.Thang
		and n13.Thang=n14.Thang and n15.Thang=n14.Thang and n15.Thang=n16.Thang
		and n17.Thang=n16.Thang and n17.Thang=n18.Thang and n19.Thang=n18.Thang
		and n19.Thang=n20.Thang and n21.Thang=n20.Thang and n21.Thang=n22.Thang
		and n23.Thang=n22.Thang and n23.Thang=n24.Thang and n25.Thang=n24.Thang
		and n25.Thang=n26.Thang and n27.Thang=n26.Thang and n27.Thang=n28.Thang
		and n29.Thang=n28.Thang and n29.Thang=n30.Thang
	END

	IF @Thang=2 and @Nam%4=0
	BEGIN
		SELECT n1.TongTien as N1,n2.TongTien as N2,n3.TongTien as N3,n4.TongTien as N4
		,n5.TongTien as N5,n6.TongTien as N6,n7.TongTien as N7,n8.TongTien as N8,n9.TongTien as N9,n10.TongTien as N10
		,n11.TongTien as N11,n12.TongTien as N12,n13.TongTien as N13,n14.TongTien as N14,n15.TongTien as N15,n16.TongTien as N16,n17.TongTien as N17
		,n18.TongTien as N18,n19.TongTien as N19,n20.TongTien as N20,n21.TongTien as N21,n22.TongTien as N22,n23.TongTien as N23,n24.TongTien as N24
		,n25.TongTien as N25,n26.TongTien as N26,n27.TongTien as N27,n28.TongTien as N28,n29.TongTien as N29
		from @BangPhu as n1
		Cross apply DlNgay(@Thang,@Nam,2) as n2
		Cross apply DlNgay(@Thang,@Nam,3) as n3
		Cross apply DlNgay(@Thang,@Nam,4) as n4
		Cross apply DlNgay(@Thang,@Nam,5) as n5
		Cross apply DlNgay(@Thang,@Nam,6) as n6
		Cross apply DlNgay(@Thang,@Nam,7) as n7
		Cross apply DlNgay(@Thang,@Nam,8) as n8
		Cross apply DlNgay(@Thang,@Nam,9) as n9
		Cross apply DlNgay(@Thang,@Nam,10) as n10
		Cross apply DlNgay(@Thang,@Nam,11) as n11
		Cross apply DlNgay(@Thang,@Nam,12) as n12
		Cross apply DlNgay(@Thang,@Nam,13) as n13
		Cross apply DlNgay(@Thang,@Nam,14) as n14
		Cross apply DlNgay(@Thang,@Nam,15) as n15
		Cross apply DlNgay(@Thang,@Nam,16) as n16
		Cross apply DlNgay(@Thang,@Nam,17) as n17
		Cross apply DlNgay(@Thang,@Nam,18) as n18
		Cross apply DlNgay(@Thang,@Nam,19) as n19
		Cross apply DlNgay(@Thang,@Nam,20) as n20
		Cross apply DlNgay(@Thang,@Nam,21) as n21
		Cross apply DlNgay(@Thang,@Nam,22) as n22
		Cross apply DlNgay(@Thang,@Nam,23) as n23
		Cross apply DlNgay(@Thang,@Nam,24) as n24
		Cross apply DlNgay(@Thang,@Nam,25) as n25
		Cross apply DlNgay(@Thang,@Nam,26) as n26
		Cross apply DlNgay(@Thang,@Nam,27) as n27
		Cross apply DlNgay(@Thang,@Nam,28) as n28
		Cross apply DlNgay(@Thang,@Nam,29) as n29
		where n1.Thang=n2.Thang and n2.Thang=n3.Thang and n4.Thang=n3.Thang
		and n4.Thang=n5.Thang and n6.Thang=n5.Thang and n6.Thang=n7.Thang
		and n8.Thang=n7.Thang and n8.Thang=n9.Thang and n10.Thang=n9.Thang
		and n10.Thang=n11.Thang and n11.Thang=n12.Thang and n13.Thang=n12.Thang
		and n13.Thang=n14.Thang and n15.Thang=n14.Thang and n15.Thang=n16.Thang
		and n17.Thang=n16.Thang and n17.Thang=n18.Thang and n19.Thang=n18.Thang
		and n19.Thang=n20.Thang and n21.Thang=n20.Thang and n21.Thang=n22.Thang
		and n23.Thang=n22.Thang and n23.Thang=n24.Thang and n25.Thang=n24.Thang
		and n25.Thang=n26.Thang and n27.Thang=n26.Thang and n27.Thang=n28.Thang
		and n29.Thang=n28.Thang 
	END
	IF @Thang=2 and @Nam%4!=0
	BEGIN
		SELECT n1.TongTien as N1,n2.TongTien as N2,n3.TongTien as N3,n4.TongTien as N4
		,n5.TongTien as N5,n6.TongTien as N6,n7.TongTien as N7,n8.TongTien as N8,n9.TongTien as N9,n10.TongTien as N10
		,n11.TongTien as N11,n12.TongTien as N12,n13.TongTien as N13,n14.TongTien as N14,n15.TongTien as N15,n16.TongTien as N16,n17.TongTien as N17
		,n18.TongTien as N18,n19.TongTien as N19,n20.TongTien as N20,n21.TongTien as N21,n22.TongTien as N22,n23.TongTien as N23,n24.TongTien as N24
		,n25.TongTien as N25,n26.TongTien as N26,n27.TongTien as N27,n28.TongTien as N28
		from @BangPhu as n1
		Cross apply DlNgay(@Thang,@Nam,2) as n2
		Cross apply DlNgay(@Thang,@Nam,3) as n3
		Cross apply DlNgay(@Thang,@Nam,4) as n4
		Cross apply DlNgay(@Thang,@Nam,5) as n5
		Cross apply DlNgay(@Thang,@Nam,6) as n6
		Cross apply DlNgay(@Thang,@Nam,7) as n7
		Cross apply DlNgay(@Thang,@Nam,8) as n8
		Cross apply DlNgay(@Thang,@Nam,9) as n9
		Cross apply DlNgay(@Thang,@Nam,10) as n10
		Cross apply DlNgay(@Thang,@Nam,11) as n11
		Cross apply DlNgay(@Thang,@Nam,12) as n12
		Cross apply DlNgay(@Thang,@Nam,13) as n13
		Cross apply DlNgay(@Thang,@Nam,14) as n14
		Cross apply DlNgay(@Thang,@Nam,15) as n15
		Cross apply DlNgay(@Thang,@Nam,16) as n16
		Cross apply DlNgay(@Thang,@Nam,17) as n17
		Cross apply DlNgay(@Thang,@Nam,18) as n18
		Cross apply DlNgay(@Thang,@Nam,19) as n19
		Cross apply DlNgay(@Thang,@Nam,20) as n20
		Cross apply DlNgay(@Thang,@Nam,21) as n21
		Cross apply DlNgay(@Thang,@Nam,22) as n22
		Cross apply DlNgay(@Thang,@Nam,23) as n23
		Cross apply DlNgay(@Thang,@Nam,24) as n24
		Cross apply DlNgay(@Thang,@Nam,25) as n25
		Cross apply DlNgay(@Thang,@Nam,26) as n26
		Cross apply DlNgay(@Thang,@Nam,27) as n27
		Cross apply DlNgay(@Thang,@Nam,28) as n28
		where n1.Thang=n2.Thang and n2.Thang=n3.Thang and n4.Thang=n3.Thang
		and n4.Thang=n5.Thang and n6.Thang=n5.Thang and n6.Thang=n7.Thang
		and n8.Thang=n7.Thang and n8.Thang=n9.Thang and n10.Thang=n9.Thang
		and n10.Thang=n11.Thang and n11.Thang=n12.Thang and n13.Thang=n12.Thang
		and n13.Thang=n14.Thang and n15.Thang=n14.Thang and n15.Thang=n16.Thang
		and n17.Thang=n16.Thang and n17.Thang=n18.Thang and n19.Thang=n18.Thang
		and n19.Thang=n20.Thang and n21.Thang=n20.Thang and n21.Thang=n22.Thang
		and n23.Thang=n22.Thang and n23.Thang=n24.Thang and n25.Thang=n24.Thang
		and n25.Thang=n26.Thang and n27.Thang=n26.Thang and n27.Thang=n28.Thang
	END;
END;
GO
/****** Object:  StoredProcedure [dbo].[DanhSachSanPham]    Script Date: 3/14/2022 9:12:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[DanhSachSanPham] @TenSanPham NVARCHAR(200),@IdThuongHieu Int, @TrangThai nvarchar(50), @GiaThapNhat float , @GiaCaoNhat float
as 
begin
	select * from SanPham where (@TenSanPham ='' or ten like N'%'+@TenSanPham+'%')
	and (@IdThuongHieu ='' or idThuongHieu = @IdThuongHieu)
	and (@TrangThai ='' or trangThai = @TrangThai)
	and (@GiaThapNhat ='' or gia>@GiaThapNhat)
	and (@GiaCaoNhat ='' or gia<@GiaCaoNhat)
end;
GO
/****** Object:  StoredProcedure [dbo].[GetListDonHang]    Script Date: 3/14/2022 9:12:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetListDonHang] @ten nvarchar(50), @tt INT, @tu DATETIME, @den DATETIME
AS
BEGIN
	SELECT O.idDon, O.ngayDat, O.diaChiGiao, O.tongTien, O.idKhach, O.trangThai, O.donViGiao, O.moTa, U.hoTen, U.sdt 
	FROM [dbo].DonHang O, [dbo].KhachHang U
	WHERE O.idKhach = U.idKhach AND O.ngayDat >= @tu AND O.ngayDat <= @den
		AND (@ten = '' OR dbo.funConvertToUnsign(U.hoTen) LIKE N'%' + dbo.funConvertToUnsign(@ten) + '%')
		AND (@tt = 0 OR O.trangThai = @tt)
	ORDER BY O.trangThai, O.idDon DESC
END
GO
/****** Object:  StoredProcedure [dbo].[getListNews]    Script Date: 3/14/2022 9:12:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[getListNews] @Title NVARCHAR(200), @StartTime DATETIME, @EndTime DATETIME
AS
BEGIN
	SELECT T.idTin, T.anh, T.ngayTao, T.tieuDe, U.hoTen
	FROM TinTuc T LEFT JOIN Users U ON T.idUser = U.idUser
	WHERE (@Title = '' OR dbo.funConvertToUnsign(tieuDe) LIKE N'%' + dbo.funConvertToUnsign(@Title) + '%')
		AND ngayTao >= @StartTime 
		AND ngayTao <= @EndTime
	ORDER BY idTin DESC
END
GO
/****** Object:  StoredProcedure [dbo].[GetListOrder]    Script Date: 3/14/2022 9:12:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetListOrder] @ten nvarchar(50), @tt CHAR(1), @tu DATETIME, @den DATETIME
AS
BEGIN
	SELECT O.idDon 
	FROM [dbo].DonHang O, [dbo].KhachHang U
	WHERE O.idKhach = U.idKhach AND O.ngayDat >= @tu AND O.ngayDat <= @den
		AND (@ten = '' OR dbo.funConvertToUnsign(U.hoTen) LIKE N'%' + dbo.funConvertToUnsign(@ten) + '%')
		AND (@tt = '' OR O.trangThai = @tt)
	ORDER BY O.trangThai, O.idDon DESC
END
GO
/****** Object:  StoredProcedure [dbo].[GetListOrderByPage]    Script Date: 3/14/2022 9:12:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetListOrderByPage] @ten nvarchar(50), @tt CHAR(1), @tu DATETIME, @den DATETIME, @page INT, @pageRows INT
AS
BEGIN
	DECLARE @selectRows INT = @page * @pageRows
	DECLARE @exceptRows INT = (@page - 1) * @pageRows
	
	;WITH Tmp AS
		( SELECT O.idDon, O.ngayDat, O.diaChiGiao, O.tongTien, O.idKhach, O.trangThai, O.moTa, U.hoTen, U.sdt 
			FROM [dbo].DonHang O, [dbo].KhachHang U
			WHERE O.idKhach = U.idKhach AND O.ngayDat >= @tu AND O.ngayDat <= @den
				AND (@ten = '' OR dbo.funConvertToUnsign(U.hoTen) LIKE N'%' + dbo.funConvertToUnsign(@ten) + '%')
				AND (@tt = '' OR O.trangThai = @tt)
			ORDER BY O.trangThai, O.idDon DESC OFFSET 0 ROWS
		)

	SELECT TOP (@selectRows) * FROM Tmp
	EXCEPT
	SELECT TOP (@exceptRows) * FROM Tmp
END
GO
/****** Object:  StoredProcedure [dbo].[listCustomer]    Script Date: 3/14/2022 9:12:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[listCustomer] @ten nvarchar(50), @dc nvarchar(100)
AS
BEGIN
	SELECT U.idKhach, U.hoTen, U.tenDangNhap, U.Email, U.matKhau, U.sdt, U.diaChi, COUNT(O.idDon) AS [Count]
	FROM [dbo].KhachHang U LEFT JOIN [dbo].DonHang O ON U.idKhach = O.idKhach
	WHERE (@ten = '' OR dbo.funConvertToUnsign(U.hoTen) LIKE N'%' + dbo.funConvertToUnsign(@ten) + '%')
			AND (@dc = '' OR dbo.funConvertToUnsign(U.diaChi) LIKE N'%' + dbo.funConvertToUnsign(@dc) + '%')
	GROUP BY U.idKhach, U.hoTen, U.tenDangNhap, U.Email, U.matKhau, U.sdt, U.diaChi
	ORDER BY U.idKhach DESC
END
GO
/****** Object:  StoredProcedure [dbo].[listCustomerByPage]    Script Date: 3/14/2022 9:12:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[listCustomerByPage] @ten nvarchar(50), @dc nvarchar(100), @page INT, @pageRows INT
AS
BEGIN
	DECLARE @selectRows INT = @page * @pageRows
	DECLARE @exceptRows INT = (@page - 1) * @pageRows
	
	;WITH Tmp AS
		( SELECT U.idKhach, U.hoTen, U.tenDangNhap, U.Email, U.matKhau, U.sdt, U.diaChi, COUNT(O.idDon) AS [Count]
			FROM [dbo].KhachHang U LEFT JOIN [dbo].DonHang O ON U.idKhach = O.idKhach
			WHERE (@ten = '' OR dbo.funConvertToUnsign(U.hoTen) LIKE N'%' + dbo.funConvertToUnsign(@ten) + '%')
					AND (@dc = '' OR dbo.funConvertToUnsign(U.diaChi) LIKE N'%' + dbo.funConvertToUnsign(@dc) + '%')
			GROUP BY U.idKhach, U.hoTen, U.tenDangNhap, U.Email, U.matKhau, U.sdt, U.diaChi
			ORDER BY U.idKhach DESC OFFSET 0 ROWS
		)

	SELECT TOP (@selectRows) * FROM Tmp
	EXCEPT
	SELECT TOP (@exceptRows) * FROM Tmp
END
GO
/****** Object:  StoredProcedure [dbo].[listLienHe]    Script Date: 3/14/2022 9:12:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[listLienHe] @NoiDung NVARCHAR(200), @StartTime DATETIME, @EndTime DATETIME
AS
BEGIN
	SELECT * FROM LienHe 
	WHERE (@NoiDung = '' OR dbo.funConvertToUnsign(NoiDung) LIKE N'%' + dbo.funConvertToUnsign(@NoiDung) + '%')
		AND NgayTao >= @StartTime 
		AND NgayTao <= @EndTime
	ORDER BY IdLienHe DESC
END
GO
/****** Object:  StoredProcedure [dbo].[listNews]    Script Date: 3/14/2022 9:12:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[listNews] @Title NVARCHAR(200), @StartTime DATETIME, @EndTime DATETIME
AS
BEGIN
	SELECT * FROM TinTuc 
	WHERE (@Title = '' OR dbo.funConvertToUnsign(tieuDe) LIKE N'%' + dbo.funConvertToUnsign(@Title) + '%')
		AND ngayTao >= @StartTime 
		AND ngayTao <= @EndTime
	ORDER BY idTin DESC
END
GO
/****** Object:  StoredProcedure [dbo].[listNewsByPage]    Script Date: 3/14/2022 9:12:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[listNewsByPage] @Title NVARCHAR(200), @StartTime DATETIME, @EndTime DATETIME, @page INT, @pageRows INT
AS
BEGIN
	DECLARE @selectRows INT = @page * @pageRows
	DECLARE @exceptRows INT = (@page - 1) * @pageRows
	
	;WITH Tmp AS
		( SELECT idTin, tieuDe, anh, ngayTao, idUser FROM dbo.TinTuc
			WHERE (@Title = '' OR dbo.funConvertToUnsign(tieuDe) LIKE N'%' + dbo.funConvertToUnsign(@Title) + '%')
					AND ngayTao >= @StartTime 
					AND ngayTao <= @EndTime
			ORDER BY idTin DESC OFFSET 0 ROWS
		)

	SELECT TOP (@selectRows) * FROM Tmp
	EXCEPT
	SELECT TOP (@exceptRows) * FROM Tmp
END
GO
/****** Object:  StoredProcedure [dbo].[listPro]    Script Date: 3/14/2022 9:12:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[listPro] @ten nvarchar(50), @idTh int, @tt int, @min float, @max float
AS 
BEGIN
	SELECT P.idSp, P.ten, P.anhDaiDien, P.gia, P.giaKm, P.trangThai, C.tenThuongHieu
	FROM SanPham P, ThuongHieu C
	WHERE (@idTh = 0 OR P.idThuongHieu = @idTh) AND P.idThuongHieu = C.idThuongHieu
		AND (@tt = 0 OR P.trangThai = @tt)
		AND (@ten = '' OR dbo.funConvertToUnsign(p.ten) LIKE N'%' + dbo.funConvertToUnsign(@ten) + '%')
		AND (@min = 0 OR P.gia >= @min) 
		AND (@max = 0 OR P.gia <= @max)
	ORDER BY P.idSp DESC
END
GO
/****** Object:  StoredProcedure [dbo].[listProByPage]    Script Date: 3/14/2022 9:12:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[listProByPage] @ten nvarchar(50), @idTh int, @tt int, @min float, @max float, @page INT, @pageRows INT
AS
BEGIN
	DECLARE @selectRows INT = @page * @pageRows
	DECLARE @exceptRows INT = (@page - 1) * @pageRows
	
	;WITH Tmp AS
		( SELECT P.idSp, P.ten, P.anhDaiDien, P.gia, P.giaKm, P.trangThai, C.tenThuongHieu
			FROM SanPham P, ThuongHieu C
			WHERE (@idTh = 0 OR P.idThuongHieu = @idTh) AND P.idThuongHieu = C.idThuongHieu
				AND (@tt = 0 OR P.trangThai = @tt)
				AND (@ten = '' OR dbo.funConvertToUnsign(p.ten) LIKE N'%' + dbo.funConvertToUnsign(@ten) + '%')
				AND (@min = 0 OR P.gia >= @min) 
				AND (@max = 0 OR P.gia <= @max)
			ORDER BY P.idSp DESC OFFSET 0 ROWS
		)

	SELECT TOP (@selectRows) * FROM Tmp
	EXCEPT
	SELECT TOP (@exceptRows) * FROM Tmp
END
GO
/****** Object:  StoredProcedure [dbo].[listProduct]    Script Date: 3/14/2022 9:12:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[listProduct] @ten nvarchar(50), @idTh int, @tt int, @min float, @max float
AS 
BEGIN
	SELECT P.idSp, P.ten, P.anhDaiDien, P.gia, P.giaKm, P.trangThai, C.tenThuongHieu
	FROM SanPham P, ThuongHieu C
	WHERE (@idTh = 0 OR P.idThuongHieu = @idTh) AND P.idThuongHieu = C.idThuongHieu
		AND (@tt = 0 OR P.trangThai = @tt)
		AND (@ten = '' OR dbo.funConvertToUnsign(p.ten) LIKE N'%' + dbo.funConvertToUnsign(@ten) + '%')
		AND (@min = 0 OR P.gia >= @min) 
		AND (@max = 0 OR P.gia <= @max)
	ORDER BY P.idSp DESC
END
GO
/****** Object:  StoredProcedure [dbo].[lstOrderByIdKhachAndPage]    Script Date: 3/14/2022 9:12:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[lstOrderByIdKhachAndPage] @idKhach INT, @tu DATETIME, @den DATETIME, @page INT, @pageRows INT
AS
BEGIN
	DECLARE @selectRows INT = @page * @pageRows
	DECLARE @exceptRows INT = (@page - 1) * @pageRows
	
	;WITH Tmp AS
		( SELECT * FROM DonHang 
			WHERE idKhach = @idKhach
				AND (ngayDat >= @tu AND ngayDat <= @den)
			ORDER BY idDon DESC OFFSET 0 ROWS
		)

	SELECT TOP (@selectRows) * FROM Tmp
	EXCEPT
	SELECT TOP (@exceptRows) * FROM Tmp
END
GO
/****** Object:  StoredProcedure [dbo].[lstSearchCusByNameInOrder]    Script Date: 3/14/2022 9:12:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[lstSearchCusByNameInOrder] @ten nvarchar(50)
AS 
BEGIN
	SELECT *
	FROM KhachHang
	WHERE dbo.funConvertToUnsign(hoTen) LIKE N'%' + dbo.funConvertToUnsign(@ten) + '%'
END
GO
/****** Object:  StoredProcedure [dbo].[lstSearchHotProduct]    Script Date: 3/14/2022 9:12:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[lstSearchHotProduct] (@Nam INT, @Thang INT) 
AS 
BEGIN
	SELECT TOP 11 I.idSp, P.ten, P.gia, P.giaKm, P.trangThai, P.anhDaiDien, C.tenThuongHieu, COUNT(I.idSp) [Count] 
	FROM CT_DonHang I, SanPham P, DonHang O, ThuongHieu C
	WHERE I.idSp = P.idSp AND I.idDon = O.idDon AND P.idThuongHieu = C.idThuongHieu
		AND YEAR(O.ngayDat) = @Nam AND MONTH(O.ngayDat) = @Thang
	GROUP BY I.idSp, P.ten, P.gia, P.giaKm, P.trangThai, P.anhDaiDien, C.tenThuongHieu
	ORDER BY COUNT(I.idSp) DESC
END
GO
/****** Object:  StoredProcedure [dbo].[lstSearchPro]    Script Date: 3/14/2022 9:12:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[lstSearchPro] @ten nvarchar(50), @idLoai int, @min float, @max float
AS 
BEGIN
	SELECT S.idSp, S.ten, S.gia, S.giaKm, S.trangThaiMieuTa, S.anhDaiDien, L.tenLoaiSp
	FROM SanPham S, LoaiSp L
	WHERE S.idLoai = L.idLoai
		AND (@ten = '' OR dbo.funConvertToUnsign(S.ten) LIKE N'%' + dbo.funConvertToUnsign(@ten) + '%')
		AND (@idLoai = 0 OR S.idLoai = @idLoai)
		AND S.gia >= @min AND S.gia <= @max
END
GO
/****** Object:  StoredProcedure [dbo].[lstSearchProByNameInOrder]    Script Date: 3/14/2022 9:12:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[lstSearchProByNameInOrder] @ProName nvarchar(50)
AS 
BEGIN
	SELECT idSp, ten, gia, giaKm, trangThai, anhDaiDien
	FROM SanPham
	WHERE dbo.funConvertToUnsign(ten) LIKE N'%' + dbo.funConvertToUnsign(@ProName) + '%'
		AND trangThai != 3 AND trangThai != 4 
END
GO
USE [master]
GO
ALTER DATABASE [WebBanHang] SET  READ_WRITE 
GO
