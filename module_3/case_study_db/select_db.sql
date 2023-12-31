-- 2.Hiển thị thông tin của tất cả nhân viên có trong hệ thống 
-- có tên bắt đầu là một trong các ký tự “H”, “T” hoặc “K” và có tối đa 15 kí tự.

use case_study_db;

ALTER DATABASE case_study_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

select *
from nhan_vien
where (binary ho_ten like 'H%' 
or binary ho_ten like 'T%' 
or binary ho_ten like 'K%' )
and char_length(ho_ten) <= 15;

-- 3.Hiển thị thông tin của tất cả khách hàng 
-- có độ tuổi từ 18 đến 50 tuổi và có địa chỉ ở “Đà Nẵng” hoặc “Quảng Trị”.

select * 
from khach_hang
where (
select (datediff(curdate(), ngay_sinh) / 365.25
between 18 and 50))
and (dia_chi like '%Đà Nẵng' collate utf8mb4_unicode_ci 
or dia_chi like '% Quảng Trị' collate utf8mb4_unicode_ci);

-- 4.Đếm xem tương ứng với mỗi khách hàng đã từng đặt phòng bao nhiêu lần.
-- Kết quả hiển thị được sắp xếp tăng dần theo số lần đặt phòng của khách hàng. 
-- Chỉ đếm những khách hàng nào có Tên loại khách hàng là “Diamond”.

select kh.ho_ten , count(hd.ma_hop_dong) as "so_lan_dat_phong"
from loai_khach lk
join khach_hang kh on kh.ma_loai_khach = lk.ma_loai_khach
join hop_dong hd on hd.ma_khach_hang = kh.ma_khach_hang
where lk.ten_loai_khach = "Diamond"
group by kh.ma_khach_hang
order by so_lan_dat_phong;

-- 5.Hiển thị ma_khach_hang, ho_ten, ten_loai_khach, ma_hop_dong, ten_dich_vu, ngay_lam_hop_dong, ngay_ket_thuc, tong_tien
-- (Với tổng tiền được tính theo công thức như sau: Chi Phí Thuê + Số Lượng * Giá, với Số Lượng và Giá là từ bảng dich_vu_di_kem, hop_dong_chi_tiet) 
-- cho tất cả các khách hàng đã từng đặt phòng. 
-- (những khách hàng nào chưa từng đặt phòng cũng phải hiển thị ra).
/* set sql_mode = 0 (Lỗi group by)*/

select kh.ma_khach_hang,kh.ho_ten,lk.ten_loai_khach,hd.ma_hop_dong,
dv.ten_dich_vu,hd.ngay_lam_hop_dong,hd.ngay_ket_thuc,
sum(ifnull(ifnull(dv.chi_phi_thue,0) + ifnull(hdct.so_luong,0) * ifnull(dvdk.gia,0),0)) as "tong_tien"
from khach_hang kh
left join loai_khach lk on lk.ma_loai_khach = kh.ma_loai_khach
left join hop_dong hd on hd.ma_khach_hang = kh.ma_khach_hang
left join dich_vu dv on dv.ma_dich_vu = hd.ma_dich_vu
left join hop_dong_chi_tiet hdct on hdct.ma_hop_dong = hd.ma_hop_dong
left join dich_vu_di_kem dvdk on dvdk.ma_dich_vu_di_kem = hdct.ma_dich_vu_di_kem
group by hd.ma_hop_dong;

-- 6.Hiển thị ma_dich_vu, ten_dich_vu, dien_tich, chi_phi_thue, ten_loai_dich_vu của tất cả các loại dịch vụ chưa từng
--  được khách hàng thực hiện đặt từ quý 1 của năm 2021 (Quý 1 là tháng 1, 2, 3).

select dv.ma_dich_vu,dv.ten_dich_vu,dv.dien_tich,dv.chi_phi_thue,ldv.ten_loai_dich_vu
from loai_dich_vu ldv
join dich_vu dv on dv.ma_loai_dich_vu = ldv.ma_dich_vu
join hop_dong hd on hd.ma_dich_vu = dv.ma_dich_vu
where dv.ten_dich_vu not in (select dv.ten_dich_vu from dich_vu dv join hop_dong hd on hd.ma_dich_vu = dv.ma_dich_vu
where hd.ngay_lam_hop_dong between "2021-01-01" and "2021-03-31")
group by dv.ma_dich_vu
order by dv.chi_phi_thue desc;

-- 7.Hiển thị thông tin ma_dich_vu, ten_dich_vu, dien_tich, so_nguoi_toi_da, chi_phi_thue,
-- ten_loai_dich_vu của tất cả các loại dịch vụ đã từng được 
-- khách hàng đặt phòng trong năm 2020 nhưng chưa từng được khách hàng đặt phòng trong năm 2021.

select dv.ma_dich_vu,dv.ten_dich_vu,dv.dien_tich,dv.so_nguoi_toi_da,dv.chi_phi_thue,ldv.ten_loai_dich_vu
from dich_vu dv
join loai_dich_vu ldv on ldv.ma_dich_vu = dv.ma_dich_vu
join hop_dong hd on hd.ma_dich_vu = dv.ma_dich_vu
where dv.ma_dich_vu not in(
select dich_vu.ma_dich_vu from dich_vu join hop_dong on hop_dong.ma_dich_vu = dich_vu.ma_dich_vu 
where hop_dong.ngay_lam_hop_dong between "2021-01-01" and "2021-12-31")
group by dv.ma_dich_vu;

-- 8.Hiển thị thông tin ho_ten khách hàng có trong hệ thống, với yêu cầu ho_ten không trùng nhau.

-- Cách 1
select khach_hang.ho_ten
from khach_hang
union
select khach_hang.ho_ten
from khach_hang;

-- Cách 2
select khach_hang.ho_ten
from khach_hang
group by khach_hang.ho_ten;

-- Cách 3
select distinct khach_hang.ho_ten 
from khach_hang;

-- 9.Thực hiện thống kê doanh thu theo tháng, nghĩa là tương ứng với 
-- mỗi tháng trong năm 2021 thì sẽ có bao nhiêu khách hàng thực hiện đặt phòng.

select month(hd.ngay_lam_hop_dong) as "thang",count(*) as "so_luong_khach_hang"
from khach_hang kh
join hop_dong hd on hd.ma_khach_hang = kh.ma_khach_hang
where hd.ngay_lam_hop_dong and year(hd.ngay_lam_hop_dong) = "2021"
group by month(hd.ngay_lam_hop_dong)
order by thang;

-- 10.Hiển thị thông tin tương ứng với từng hợp đồng thì đã sử dụng bao nhiêu dịch vụ đi kèm. 
-- Kết quả hiển thị bao gồm ma_hop_dong, ngay_lam_hop_dong, ngay_ket_thuc, tien_dat_coc, so_luong_dich_vu_di_kem
-- (được tính dựa trên việc sum so_luong ở dich_vu_di_kem).

select hd.ma_hop_dong,hd.ngay_lam_hop_dong,hd.ngay_ket_thuc,hd.tien_dat_coc,
sum(ifnull(so_luong,0)) as "so_luong_dich_vu_di_kem"
-- if(hdct.so_luong is null ,0,sum(so_luong)) as "so_luong_dich_vu_di_kem"
from hop_dong hd
left join hop_dong_chi_tiet hdct on hdct.ma_hop_dong = hd.ma_hop_dong
left join dich_vu_di_kem dvdk on dvdk.ma_dich_vu_di_kem = hdct.ma_dich_vu_di_kem
group by hd.ma_hop_dong
order by ma_hop_dong;

-- 11.Hiển thị thông tin các dịch vụ đi kèm đã được sử dụng bởi những khách hàng 
-- có ten_loai_khach là “Diamond” và có dia_chi ở “Vinh” hoặc “Quảng Ngãi”.

select kh.ho_ten,lk.ten_loai_khach,kh.dia_chi,dvdk.ma_dich_vu_di_kem,dvdk.ten_dich_vu_di_kem
from loai_khach lk
join khach_hang kh on kh.ma_loai_khach = lk.ma_loai_khach
join hop_dong hd on hd.ma_khach_hang = kh.ma_khach_hang
join hop_dong_chi_tiet hdct on hdct.ma_hop_dong = hd.ma_hop_dong
join dich_vu_di_kem dvdk on dvdk.ma_dich_vu_di_kem = hdct.ma_dich_vu_di_kem
where ten_loai_khach = "Dinamond" and (dia_chi like "%Vinh%" or dia_chi like "%Quảng Ngãi%")
order by dvdk.ma_dich_vu_di_kem;


-- 12.Hiển thị thông tin ma_hop_dong, ho_ten (nhân viên), ho_ten (khách hàng), so_dien_thoai (khách hàng),
-- ten_dich_vu, so_luong_dich_vu_di_kem (được tính dựa trên việc sum so_luong ở 	),
-- tien_dat_coc của tất cả các dịch vụ đã từng được khách hàng đặt vào 3 tháng cuối năm 2020 nhưng chưa từng được
-- khách hàng đặt vào 6 tháng đầu năm 2021.

select hd.ma_hop_dong, nv.ho_ten,kh.ho_ten,kh.so_dien_thoai,hd.ma_dich_vu,dv.ten_dich_vu,
sum(ifnull(so_luong,0)) as "so_luong_dich_vu_di_kem",hd.tien_dat_coc
from nhan_vien nv
left join hop_dong hd on hd.ma_nhan_vien = nv.ma_nhan_vien
left join khach_hang kh on kh.ma_khach_hang = hd.ma_khach_hang
left join dich_vu dv on dv.ma_dich_vu = hd.ma_dich_vu
left join hop_dong_chi_tiet hdct on hdct.ma_hop_dong = hd.ma_hop_dong
left join dich_vu_di_kem dvdk on dvdk.ma_dich_vu_di_kem = hdct.ma_dich_vu_di_kem
where dv.ma_dich_vu in (select hop_dong.ma_dich_vu
from hop_dong 
where hop_dong.ngay_lam_hop_dong between "2020-10-01" and "2020-12-31")
and dv.ma_dich_vu not in  (
select dich_vu.ma_dich_vu
from dich_vu 
join hop_dong 
on hop_dong.ma_dich_vu = dich_vu.ma_dich_vu
where hop_dong.ngay_lam_hop_dong between "2021-01-01" and "2021-06-30")
group by hd.ma_hop_dong;

-- 13.Hiển thị thông tin các Dịch vụ đi kèm được sử dụng nhiều nhất bởi các Khách hàng đã đặt phòng. 
-- (Lưu ý là có thể có nhiều dịch vụ có số lần sử dụng nhiều như nhau).

select dvdk.ma_dich_vu_di_kem,dvdk.ten_dich_vu_di_kem,sum(so_luong) as "so_luong_dich_vu_di_kem"
from dich_vu_di_kem dvdk
join hop_dong_chi_tiet hdct on hdct.ma_dich_vu_di_kem = dvdk.ma_dich_vu_di_kem
group by dvdk.ma_dich_vu_di_kem
having sum(so_luong) = (
select sum(so_luong) as "so_luong_dich_vu"
from hop_dong_chi_tiet
join dich_vu_di_kem 
on dich_vu_di_kem.ma_dich_vu_di_kem = hop_dong_chi_tiet.ma_dich_vu_di_kem
group by dich_vu_di_kem.ma_dich_vu_di_kem
order by so_luong_dich_vu desc
limit 1
)
order by ma_dich_vu_di_kem;

-- 14.Hiển thị thông tin tất cả các Dịch vụ đi kèm chỉ mới được sử dụng một lần duy nhất.
-- Thông tin hiển thị bao gồm ma_hop_dong, ten_loai_dich_vu, 
-- ten_dich_vu_di_kem, so_lan_su_dung (được tính dựa trên việc count các ma_dich_vu_di_kem).

select hd.ma_hop_dong,ldv.ten_loai_dich_vu,dvdk.ten_dich_vu_di_kem,count(dvdk.ma_dich_vu_di_kem) as "so_lan_su_dung"
from loai_dich_vu ldv
join dich_vu dv on dv.ma_loai_dich_vu = ldv.ma_dich_vu
join hop_dong hd on hd.ma_dich_vu = dv.ma_dich_vu
join hop_dong_chi_tiet hdct on hdct.ma_hop_dong = hd.ma_hop_dong
join dich_vu_di_kem dvdk on dvdk.ma_dich_vu_di_kem = hdct.ma_dich_vu_di_kem
group by dvdk.ma_dich_vu_di_kem
having so_lan_su_dung = 1
order by hd.ma_hop_dong;

-- 15.Hiển thi thông tin của tất cả nhân viên bao gồm ma_nhan_vien, ho_ten, ten_trinh_do, ten_bo_phan, so_dien_thoai,
--  dia_chi mới chỉ lập được tối đa 3 hợp đồng từ năm 2020 đến 2021.

-- Cách 1

select nv.ma_nhan_vien,nv.ho_ten,td.ten_trinh_do,bp.ten_bo_phan,nv.so_dien_thoai,nv.dia_chi
from nhan_vien nv
join hop_dong hd on hd.ma_nhan_vien = nv.ma_nhan_vien
join trinh_do td on td.ma_trinh_do = nv.ma_trinh_do
join bo_phan bp on bp.ma_bo_phan = nv.ma_bo_phan
where hd.ngay_lam_hop_dong between "2020-01-01" and "2021-12-31"
group by hd.ma_nhan_vien
having count(hd.ma_nhan_vien) < 4
order by hd.ma_nhan_vien;
 
-- 16.Xóa những Nhân viên chưa từng lập được hợp đồng nào từ năm 2019 đến năm 2021.

-- Lấy dữ liệu
create view view_nhan_vien as
select nhan_vien.ma_nhan_vien,nhan_vien.ho_ten,nhan_vien.ngay_sinh,nhan_vien.so_cmnd,nhan_vien.so_dien_thoai,nhan_vien.email,nhan_vien.dia_chi
from nhan_vien ;

create view view_hop_dong as
select hop_dong.ma_hop_dong,hop_dong.ma_nhan_vien,hop_dong.ngay_lam_hop_dong
from hop_dong;

-- Thao tác xóa với dữ liệu

delete from view_nhan_vien  
where view_nhan_vien.ma_nhan_vien not in (
select view_hop_dong.ma_nhan_vien
from view_hop_dong 
where year(ngay_lam_hop_dong) in (2019,2021)
group by view_hop_dong.ma_nhan_vien);

drop view if exists view_nhan_vien;

drop view if exists view_hop_dong;

-- updates

alter table nhan_vien add xoa_nhan_vien bit(1) default 0;

update nhan_vien
set xoa_nhan_vien = 1
where nhan_vien.ma_nhan_vien not in (
select hop_dong.ma_nhan_vien
from hop_dong 
where hop_dong.ngay_lam_hop_dong between "2019-01-01" and "2021-12-31"
group by hop_dong.ma_nhan_vien);

select nhan_vien.ma_nhan_vien,nhan_vien.ho_ten
from nhan_vien
where xoa_nhan_vien = 1;
-- 17.Cập nhật thông tin những khách hàng có ten_loai_khach từ Platinum lên Diamond,
--  chỉ cập nhật những khách hàng đã từng đặt phòng với Tổng Tiền thanh toán trong năm 2021 là lớn hơn 10.000.000 VNĐ.

create view tinh_tong as
select kh.ma_khach_hang
from khach_hang kh
left join loai_khach lk on lk.ma_loai_khach = kh.ma_loai_khach
left join hop_dong hd on hd.ma_khach_hang = kh.ma_khach_hang
left join dich_vu dv on dv.ma_dich_vu = hd.ma_dich_vu
left join hop_dong_chi_tiet hdct on hdct.ma_hop_dong = hd.ma_hop_dong
left join dich_vu_di_kem dvdk on dvdk.ma_dich_vu_di_kem = hdct.ma_dich_vu_di_kem
where year(hd.ngay_lam_hop_dong) = 2021
group by hd.ma_khach_hang
having sum(ifnull(ifnull(dv.chi_phi_thue,0) + ifnull(hdct.so_luong,0) * ifnull(dvdk.gia,0),0) > 10000000) ;

update khach_hang
set ma_loai_khach = 1
where ma_khach_hang in (
select ma_khach_hang from tinh_tong);

select khach_hang.ma_khach_hang,khach_hang.ho_ten,loai_khach.ten_loai_khach
from khach_hang
join loai_khach on loai_khach.ma_loai_khach = khach_hang.ma_loai_khach;

drop view tinh_tong;

-- 18.Xóa những khách hàng có hợp đồng trước năm 2021 (chú ý ràng buộc giữa các bảng).
set foreign_key_checks = 1;

delete from khach_hang 
where ma_khach_hang in (
select hop_dong.ma_khach_hang
from hop_dong 
where year(ngay_lam_hop_dong) < 2021
group by ma_khach_hang);

alter table khach_hang add xoa_khach_hang bit(1) default 0;
update khach_hang
set xoa_khach_hang = 1
where khach_hang.ma_khach_hang in (
select hop_dong.ma_khach_hang
from hop_dong 
where year(ngay_lam_hop_dong) < 2021
group by ma_khach_hang);

select khach_hang.ma_khach_hang,khach_hang.ho_ten
from khach_hang
where xoa_khach_hang = 0;

-- 19.Cập nhật giá cho các dịch vụ đi kèm được sử dụng trên 10 lần trong năm 2020 lên gấp đôi.

update dich_vu_di_kem
set gia = gia * 2
where ma_dich_vu_di_kem in(
select ma_dich_vu_di_kem
from hop_dong_chi_tiet
join hop_dong on hop_dong.ma_hop_dong = hop_dong_chi_tiet.ma_hop_dong
where so_luong > 10 and year(ngay_lam_hop_dong) = 2020
group by ma_dich_vu_di_kem);

-- 20.Hiển thị thông tin của tất cả các nhân viên và khách hàng có trong hệ thống, thông tin hiển thị bao gồm
--  id (ma_nhan_vien, ma_khach_hang), ho_ten, email, so_dien_thoai, ngay_sinh, dia_chi.

select khach_hang.ma_khach_hang as id, khach_hang.ho_ten,khach_hang.email,khach_hang.so_dien_thoai,khach_hang.ngay_sinh,khach_hang.dia_chi
from khach_hang
union
select nhan_vien.ma_nhan_vien as id, nhan_vien.ho_ten,nhan_vien.email,nhan_vien.so_dien_thoai,nhan_vien.ngay_sinh,nhan_vien.dia_chi
from nhan_vien;