---- ************************* TRY CATCH *********************************


drop proc if exists usb_divide
go

create proc usb_divide(
@a decimal(18,2),
@b decimal(18,2),
@c decimal(18,2) output
)as
begin
begin try
set @c= @a/@b;
select @a as a , @b as b , @c as [a/b]
end try
begin catch
select
 ERROR_NUMBER() AS ErrorNumber  
            ,ERROR_SEVERITY() AS ErrorSeverity  
            ,ERROR_STATE() AS ErrorState  
            ,ERROR_PROCEDURE() AS ErrorProcedure  
            ,ERROR_LINE() AS ErrorLine  
            ,ERROR_MESSAGE() AS ErrorMessage;  
end catch
end
go

exec usb_divide 5,2, -12312

---****************** EXAM **************************

--1. Kategorilere ait ürün sayýlarýný getiren SQL

--create synonym products  for production.products

Select * from production.brands -- Markalar

Select * from production.categories -- Kategoriler

Select * from production.products -- Ürünler


select c.category_id,
(select COUNT(pr.category_id) from production.products pr where pr.category_id=c.category_id) as UrunSAyisi
from production.categories c 

--2. Herbir Kategoriye ait en pahalý ürün bilgilerini Getiren SQL


select (select c.category_name from production.categories c where c.category_id=p1.category_id) as CategoryName,  
p1.product_name,
p1.list_price
from production.products p1 
where p1.list_price=(select max(p2.list_price) from production.products p2 where p2.category_id=p1.category_id)

--not: burda þunu anla where kýsmý bile satýr satýr iþlem yapýyor yani genel bir anlam arama yani where kýsmý bir satýr için
--arama yapýyor ve  diðer kodlarda o wheredeki fiyata göre hareket ediyor ancak bir sonraki satýrda where filtresi deðiþiyor
--ayrýca ana sorgu products oldu çünkü  joinsiz subquery ile yaptýðýmýz için where dede fiyatý alacaðýmýz için fiyatta productsda mevcut
--o yüzden ana sorgu products oldu ve select kýsmý producstan category nameyi alamayacaðý için oraya ayrý bir subquery ile category
--tablosuna yönlendirdik

--  JOÝNLÝ KULLANIM:


select 
c.category_name,
pr.product_name,
pr.list_price
from  production.products pr inner join production.categories c on 
pr.category_id=c.category_id 
where pr.list_price =(select max(p2.list_price) from production.products p2 where p2.category_id=pr.category_id)
order by pr.list_price desc


--3. Ürün Bilgilerini Marka Adý ve Kategori Adlarý ile birlikte getiren SQL

Select * from production.brands -- Markalar

Select * from production.categories -- Kategoriler

Select * from production.products -- Ürünler

--JOÝN ÝLE

select pr.*,
br.brand_name,
c.category_name
from production.products pr inner join  production.brands br on br.brand_id=pr.brand_id
inner join production.categories c on c.category_id=pr.category_id


-- SUBQUERY ÝLE 

select pr.*,
(select br.brand_name from production.brands br where br.brand_id=pr.brand_id) as brandName,
(select c.category_name from production.categories c where c.category_id=pr.category_id) as CategoryName
from production.products pr













