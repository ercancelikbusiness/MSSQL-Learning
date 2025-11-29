--*************************** FONKSÝYONLAR *************************

--USER DEFINED FUNCTION
--Drop Function if Exists islemYap
if Exists (Select * from sys.objects Where Name = 'islemYap' And Type = 'FN')
Drop Function islemYap
Go

Create Function islemYap (@s1 real,  @s2 real, @i varchar(1))
RETURNS real
AS
Begin
	declare @sonuc real

	Set @sonuc = @s1 + @s2
	return @sonuc
END

SELECT dbo.islemYap(10.5, 5.2, '+');



--NOT:  Type= FN : nesnenin tipi fonksiyon demektir.
--Go: Bu, SQL betiðinin bu noktada kesilip gönderilmesini (batch termination) saðlayan bir komuttur. 
--DROP FUNCTION ve CREATE FUNCTION gibi bazý komutlarýn ayrý partilerde olmasý gerekir.
/*
Real: ondalýklý sayýlarý temsil eden real veri tipi
RETURNS real: Fonksiyonun iþini bitirdiðinde geriye hangi tipte bir deðer döndüreceðini (çýktýsýný) belirtir. 
Bu örnekte, sonuç bir ondalýklý sayý (real) olacaktýr.
*/


--*********************synonym*************************
/*
CREATE SYNONYM products FOR production.products
--production.products -> products |	production þemasýna ait products tablosuna artýk sadece products adýyla eriþilebilir.
CREATE SYNONYM brands FOR production.brands
CREATE SYNONYM categories FOR production.categories
CREATE SYNONYM stoks FOR production.stoks

CREATE SYNONYM custumers FOR sales.custumers
CREATE SYNONYM orders FOR sales.orders
CREATE SYNONYM orderitems FOR sales.order_items
CREATE SYNONYM staffs FOR sales.staffs
CREATE SYNONYM stores FOR sales.stores
*/

--************************ nullif *********************
-- NULIFF
DECLARE @a int = 10, @b int = 20, @c int = 20;

SELECT  @a as a, @b as b, @c as c,
		NULLIF(@a,@b) AS result_a_b,
		NULLIF(@b,@c) AS result_b_c

/*
nullif iki ifade birbirine eþitse null döndürür deðilse ilk ifadeyi döndürür Özetle, NULLIF, sadece iki deðer eþit olduðunda
NULL döndürerek o deðeri "gizlemek" veya "geçersiz kýlmak" için kullanýlýr.
*/


--**************************** isnull *********************
/*
ISNULL fonksiyonu, bir ifadenin NULL olup olmadýðýný kontrol eder. Eðer ifade NULL ise, belirtilen ikinci deðeri (yedek deðeri) döndürür;
eðer ifade NULL deðilse, ifadenin kendisini döndürür.
*/

Select s.*, 

	 ISNULL(s.manager_id, -1) as Mid, 
	 ISNULL(
		(Select CONCAT(m.first_name, ' ', m.last_name) from sales.staffs m WHERE m.staff_id = s.manager_id), '?'	
	)as Manager
From sales.staffs s

Select ISNULL(Null, 'EVET') as Sonuc,   --EVET
	   ISNULL(99, 0) as Sonuc2          --99

/*
Kod,                        Açýklama,                       Sonuç

"CONCAT('Ankara', ' ', 06)",    Metin ve sayý birleþtiriliyor.,    'Ankara 06'

"CONCAT('A', NULL, 'B')",     NULL deðerini atlayarak birleþtirir.,     'AB'
*/




--***********************  COALESCE   ******************************************

--coalesce:  ne kadar veri olursa olsun ilk null olmayan veriyi kabul edecektir
--öncelikle bir tablo oluþturalým ve  hourly weekly monthly deðerlerinden en az birine veri girilme zorunluluðu (check) koyalým
/*
CREATE TABLE sales.salaries (
    staff_id INT PRIMARY KEY,
    hourly_rate decimal,
    weekly_rate decimal,
    monthly_rate decimal,
    CHECK(
        hourly_rate IS NOT NULL OR 
        weekly_rate IS NOT NULL OR 
        monthly_rate IS NOT NULL)
);

-- aþaðýda sales.salaries caðýrmak için salaries yazmak yeterli olmasý gerektiðini belirttik

Create synonym salaries FOR sales.salaries
*/

-- INSERT SALARIES DATA
--aþaðýda tablomuza veri ekleyelim check kýsýtýný dikkate alarak yapýyoruz
/*
INSERT INTO 
    salaries(staff_id, 
        hourly_rate, 
        weekly_rate, 
        monthly_rate
    )
VALUES
    (1,20, NULL,NULL),
    (2,30, NULL,NULL),
    (3,NULL, 1000,NULL),
    (4,NULL, NULL,6000),
    (5,NULL, NULL,6500)

	*/
	

Select 5 as numara, 
	   COALESCE(NULL, 'Merhaba') as Sonuc,   -- burda Merhaba kabul edilir
	   COALESCE(25, Null, Null, 'Hoþ Geldin') as Sonuc2, -- burda 25 kabul edilir
	   COALESCE(Null, Null, 'Hoþ Geldin') as Sonuc3,  -- burda hoþ geldin
	   COALESCE(Null, Null, NULL) as Sonuc_Null  -- burda null kabul edilir

--- aþaðýda check kýsýtýný ihlal eden bir ekleme yapalým bu hatalý olacaktýr

/*
INSERT INTO 
    salaries(staff_id, 
        hourly_rate, 
        weekly_rate, 
        monthly_rate
    )
VALUES
    (6,NULL, NULL, NULL)

	*/

    --aþaðýdaki örnek kabul edilir çünkü check kýsýtýný hertürlü geçecektir coalesce' ile kullanýlsa mesela ilk null olmayan geçerlidir
/*
INSERT INTO 
    salaries(staff_id, 
        hourly_rate, 
        weekly_rate, 
        monthly_rate
    )
VALUES
    (6,20, 1200, 7600)
*/

--aþaðýdaki örnekte hourly rate null ise  8 ve 22 nin olmasý birþey ifade etmez çünkü aritmatik iþlem ( burda çarpma) null gelecektir
--eðer weekly_Rate var ise onu kabul edip  monthly bakmadan aylik ucret sütununa bir deðer yazacaktýr.

Select staff_id, 
	   Coalesce(hourly_rate * 8 * 22, 
				weekly_rate * 4, 
				monthly_rate  ) as Aylik_Ucret

from salaries

