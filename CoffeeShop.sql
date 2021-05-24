CREATE DATABASE Coffee

use Coffee;

--tao bang chuc vu
create table chucvu (
maCV char(5) PRIMARY KEY,
tenCV nvarchar (40)
)
--Tao bang nhan vien
create table nhanvien (
manv char(5) PRIMARY KEY,
holot nvarchar (40),
tennv nvarchar (20),
gioitinh nvarchar(3),
ngaysinh datetime,
sdt char(10),
diachi nvarchar(150),
maCV char(5) FOREIGN KEY REFERENCES chucvu(maCV)
)

--Tao bang danh muc
create table danhmuc(
maDM char(5) PRIMARY KEY,
tenDM nvarchar (40)
)
--Tao bang hang hoa
create table hanghoa (
maHH char(5) PRIMARY KEY,
tenHH nvarchar (40),
dongia int,
maDM char(5) FOREIGN KEY REFERENCES danhmuc(maDM)
)
--Tao bang hoa don
create table hoadon(
maHD char(5) PRIMARY KEY,
holot nvarchar (40),
ten nvarchar (20),
ngaylap datetime,
tongtien int
)
--Tao bang khuyen mai
create table khuyenmai(
maKM char(5) PRIMARY KEY,
maHH char(5) FOREIGN KEY REFERENCES hanghoa(maHH),
ngaybd datetime ,
ngaykt datetime ,
giakm int
)
--Tao bang chi tiet hoa don
create table cthoadon(
macthd char(10),
PRIMARY KEY(macthd, maHD,maHH),
maHD char(5) FOREIGN KEY REFERENCES hoadon(maHD),
maHH char(5) FOREIGN KEY REFERENCES hanghoa(maHH),
dongia int,
soluong int,
tongtien int
)

--Dang nhap
create table dangnhap(
matk char(32) PRIMARY KEY,
matkhau char (32),
holot nvarchar(50),
tentk nvarchar(20),
quyen nvarchar(20)
)
-------Them du lieu
--chucvu
insert into chucvu values('cv001', N'Quản lý')
insert into chucvu values('cv002', N'Thu ngân')
--nhanvien
insert into nhanvien values('nv002', N'Nguyễn Văn',N' An', N'Nam', '02/04/2000','0986581230', N'Mỹ Xuyên, Long Xuyên','cv001')
insert into nhanvien values('nv003', N'Lê Văn ',N'Trọng', N'Nam', '01/01/2000','0967581814', N'Mỹ Phước, Long Xuyên','cv002')

--danh muc
insert into danhmuc values('dm01', N'Nước uống')
insert into danhmuc values('dm02', N'Đồ ăn')

--hang hoa
insert into hanghoa values('hh001', N'Cafe', 15000, 'dm01')
insert into hanghoa values('hh002', N'Cafe sữa', 18000, 'dm01')
insert into hanghoa values('hh003', N'Cơm sườn', 25000, 'dm02')

--hoa don
insert into hoadon values('hd001',N'Lê Văn',N'Trọng','02/27/2021', 13000)
insert into hoadon values('hd002',N'Lê Văn',N'Trọng','02/28/2021', 31000)

--khuyen mai
insert into khuyenmai values('km001','hh001','02/20/2021','02/28/2021',13000)
insert into khuyenmai values('km002','hh002','02/03/2021','02/04/2021',13000)

-- chi tiet hoa don
insert into cthoadon values('cthd000001','hd001','hh001',13000, 1, 13000)
insert into cthoadon values('cthd000002','hd002','hh001',13000, 1, 13000)
insert into cthoadon values('cthd000002','hd002','hh002',18000,1, 18000)

--Dang nhap
insert into dangnhap values('ad01', '12345', N'Lê Thị Mỹ',N' Tiên', N'admin')
insert into dangnhap values('ql001', '12345', N'Nguyễn Văn',N'An',N'Quản lý')
insert into dangnhap values('bh001', '12345', N'Lê Văn',N'Trọng',N'Thu ngân')




--so sanh khong dau
go
CREATE FUNCTION [dbo].[fChuyenCoDauThanhKhongDau](@inputVar NVARCHAR(MAX) )
RETURNS NVARCHAR(MAX)
AS
BEGIN    
    IF (@inputVar IS NULL OR @inputVar = '')  RETURN ''
   
    DECLARE @RT NVARCHAR(MAX)
    DECLARE @SIGN_CHARS NCHAR(256)
    DECLARE @UNSIGN_CHARS NCHAR (256)
 
    SET @SIGN_CHARS = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệếìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵýĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ' + NCHAR(272) + NCHAR(208)
    SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeeeiiiiiooooooooooooooouuuuuuuuuuyyyyyAADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD'
 
    DECLARE @COUNTER int
    DECLARE @COUNTER1 int
   
    SET @COUNTER = 1
    WHILE (@COUNTER <= LEN(@inputVar))
    BEGIN  
        SET @COUNTER1 = 1
        WHILE (@COUNTER1 <= LEN(@SIGN_CHARS) + 1)
        BEGIN
            IF UNICODE(SUBSTRING(@SIGN_CHARS, @COUNTER1,1)) = UNICODE(SUBSTRING(@inputVar,@COUNTER ,1))
            BEGIN          
                IF @COUNTER = 1
                    SET @inputVar = SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@inputVar, @COUNTER+1,LEN(@inputVar)-1)      
                ELSE
                    SET @inputVar = SUBSTRING(@inputVar, 1, @COUNTER-1) +SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@inputVar, @COUNTER+1,LEN(@inputVar)- @COUNTER)
                BREAK
            END
            SET @COUNTER1 = @COUNTER1 +1
        END
        SET @COUNTER = @COUNTER +1
    END
    -- SET @inputVar = replace(@inputVar,' ','-')
    RETURN @inputVar
END

--Bao cao DS_KhuyenMai hien tai
create proc BC_KMHienTai @NgayBD datetime
as
begin
	select km.maKM, hh.tenHH, hh.dongia, km.giakm, km.ngaybd, km.ngaykt 
	from hanghoa hh, khuyenmai km
	where hh.maHH=km.maHH and  @NgayBD between km.ngaybd and km.ngaykt
end


--Bao cao DS_KhuyenMai tu ngay den ngay
create proc BC_KMDenNgay @NgayBD datetime, @NgayKT datetime
as
begin
	select km.maKM, hh.tenHH, hh.dongia, km.giakm, km.ngaybd, km.ngaykt 
	from hanghoa hh, khuyenmai km
	where hh.maHH=km.maHH and (km.ngaybd  between @NgayBD and @NgayKT) and (km.ngaykt between @NgayBD and @NgayKT)
end



