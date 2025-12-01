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



--********************************* CROSS APPLY *************************************
-- Ürün Kategorilerine Göre En yüksek Deðere Sahip ilk 2 ürünü (Her Bir Kategori Ýçin) Getiren SQL?

CREATE SYNONYM categories FOR production.categories

select * from categories
select * from production.products

select c.category_id, c.category_name, r.product_name ,r.list_price
from  categories c 
cross apply
(select top 2 * from production.products p where p.category_id = c.category_id order by p.list_price desc) r
order by c.category_id , r.list_price desc


-- alt sorguda desc denme nedeni fiyatlar  en yüksekden düþüðe sýralanýr bu sayede her kategorideki ürünlerin en yüksek 2 sini alýr
--ana sorgudaki   ORDER BY c.category_id, r.list_price DESC burda category desc denmemiþ boþ býrakýlmýþ yani artan sýralý grup olacak
--list price ise desc denmiþ yani herbir grupta önce yüksek olan yazýlacak mesela category 1 de 3 ürin varsa bu 3 ürün yüksekden aþaðý
--sýralanacak demektir. alt sorgudaan sonraki r ifadesi inner join Bolgeler b diyorduk onun gibi düþün yani crossdan sonraki alt sorgu
--nun sonucuna verilen takma addýr. alt sorguda þu yapýlýyor ana sorgudan gelen category'e ait tüm ürünler her satýrda listelenir
--örneðin 1 kategorisine ait 20 ürün o satýr için listelenecek ve en yüksek fiyatlý 2 ürün  yazdýrýlýcak bu her kategori için her satýrda
--olacak  kýsaca bunu bir döngü gibi düþünme her kategori için tüm ürünler tek seferde listelenip top 2 sayesinde ilk 2 si alýnýyor
--sql mantýðý bu þekildeydi unutma



--************** DONGULER ***********************

--DONGULER
--1 den N'e kadar olan sayýlarýn Toplmaný Bulan  Program


declare @top int =0, @i int =1 , @n int =10
while(@i <= @n)
begin

print @i
set @top= @i+@top
set @i=@i+1
end
print @top



-- verilen sayýlarý toplayan fonksiyon yapalým



-- Eðer fonksiyon zaten varsa siler
IF OBJECT_ID('dbo.fnSayilariTopla') IS NOT NULL
    DROP FUNCTION dbo.fnSayilariTopla;
GO

-- Yeni Fonksiyonu Oluþturma
CREATE FUNCTION dbo.fnSayilariTopla (
    @BaslangicDegeri INT, -- Baþlangýç (i) deðeri
    @BitisDegeri INT      -- Bitiþ (n) deðeri
)
RETURNS INT
AS
BEGIN
    -- Toplamý tutacak deðiþken
    DECLARE @toplam INT = 0;
    
    -- Baþlangýç deðerini geçici bir sayaçta tutalým (orijinal parametreyi deðiþtirmemek için)
    -- geçiçi sayaçda tutmasakda olur ama bu daha doðru bir yaklaþým
    DECLARE @i INT = @BaslangicDegeri;

    -- Döngü: Baþlangýç deðeri bitiþ deðerine eþit veya küçük olduðu sürece devam et
    WHILE (@i <= @BitisDegeri)
    BEGIN
        -- Mevcut sayýyý toplama ekle
        SET @toplam = @toplam + @i;

        -- Sayacý bir artýr
        SET @i = @i + 1;
    END

    -- Hesaplanan toplamý döndür
    RETURN @toplam;
END
GO  -- zorunlu deðil

-- 1. Örnek: 1'den 10'a kadar olan sayýlarý topla (Sonuç: 55)
SELECT dbo.fnSayilariTopla(1, 10) AS Toplam1;

-- 2. Örnek: 5'ten 8'e kadar olan sayýlarý topla (5 + 6 + 7 + 8 = 26)
SELECT dbo.fnSayilariTopla(5, 8) AS Toplam2;

-- 3. Örnek: Sadece tek bir sayýyý topla (Baþlangýç ve bitiþ ayný)
SELECT dbo.fnSayilariTopla(100, 100) AS Toplam3;

--******************************* fonksyion kurallar ******************************


--USER DEFINED FUNCTIONS (KULLANICI TARAFINDAN OLUÞTURULA FONKSÝYONLAR)

--Geriye Tek Döndüren Fonksiyonlar (SCALAR Valued Fonksiyon) (FN)
--Geriye Tek Bir Select ile Tablo Döndüren Fonksiyonlar (INLINE Fonksiyon) (view lerin yerine Tercih edilmelidir)(IF)
--Geriye Çoklu Sorgu ile Tablo Döndüren Fonksiyonlar (Multiple-TABLE VALUED Fonksiyon) (TF)

--Fonksiyonlar içerisinde:
	--PRINT, CURSOR KUllanýlamaz
	--Create,DROP, ALTER, INSERT, UPDATE, DELETE KULLANILMAZ

Drop Function if Exists fnDeneme
Go

Create Function fnDeneme()
Returns int
AS
Begin
	--Delete from personel where Id = 1 -- KULLANILAMAZ
	--Insert into iller Values('67', 'Zonguldak') -- KULLANILAMAZ
	--Update iller Set Adi = 'Yozgattt' Where Kodu = '66' -- KULLANILAMAZ

	---Create Table Deneme(Id int identity) -- KULLANILAMAZ
	-- Create view v_deneme as Select * from iller -- KULLANILAMAZ
	-- Alter Table Departmanlar Add PerSayisi int Not Null Default 0 -- KULLANILAMAZ
	-- DROP view if Exists v_Deneme -- KULLANILAMAZ

	return 0
End




--************************** inline  function *************************

--IN LINE Table Valued Function


--Bu alt kýsým kýsým, kodun tekrar çalýþtýrýlabilir olmasýný saðlar. 

if Exists(Select * from sys.objects Where name = 'fnilceler' and Type = 'IF')
Drop Function fnilceler
Go

--fonksiyonu kuralým

Create Function fnilceler(@ilkodu varchar(3))
Returns Table
AS

RETURN
Select ic.Id, 
	   ic.ilkodu, 
	   (Select i.Adi From iller i Where i.ilkodu = ic.ilkodu) as ilAdi,  -- burdada   Where i.ilkodu=ISNULL(@ilkodu, ic.ilkodu) yapýlabilir ama gereksiz zaten ana sorguda var
	   ic.Adi as IlceAdi 
from ilceler ic WHERE ic.ilkodu = ISNULL(@ilkodu, ic.ilkodu) -- eðer fonksiyona  null gelirse ic.ilkodu=ic.ilkodu olur buda tüm ilkodlarýný
                                                             -- doðru kabul edecektir tüm tablo gelir


-- FONKSÝYONU çaðýrýrken select dbo.fnilceler ... þeklinde yapamýyoruz çünkü bu tablo deðerli bir fonksiyon
-- FONKSÝYONU çaðýrýrken select dbo.fnilceler ... þeklinde yapamýyoruz çünkü bu tablo deðerli bir fonksiyon

SELECT T.* FROM dbo.fnilceler('06') AS T;
SELECT T.* FROM dbo.fnilceler(null) AS T Order by t.ilAdi, t.IlceAdi;

--veya alttaki gibi sadece istediðimiz sütunlarýn olmasýný hatta yerleri deðiþtirerek isteyebiliriz

SELECT
    T.IlceAdi,  -- T, fonksiyondan dönen sanal tablonun takma adýdýr (alias).
    T.ilAdi
FROM
    dbo.fnilceler('06') AS T; -- '06' metin (varchar) olduðu için týrnak içinde gönderilir.



--*************************Multi-Statement Tablo Deðerli Fonksiyon (Multi-Statement Table-Valued Function - mTVF) **********************************

if Exists(Select * From sys.objects Where name = 'fnMultiStatement' and type = 'TF')
DROP function fnMultiStatement
Go

Create Function fnMultiStatement()
Returns @veriler Table(Id int identity,
						Kod varchar(5),
						Tanim Varchar(20))

As
Begin
	insert into @veriler Values('99', 'Bizim Deðer')

	insert into @veriler 
	Select ilkodu, Adi From iller Order By Adi
    --Bu sonuç kümesindeki ilkodu ve Adi sütunlarý, @veriler tablosunun Kod ve Tanim sütunlarýna eklenir.
    --ilk  kod ve taným 99 bizim deðer olcak gerisi ilkodu ve adi olanlarý alacak

	return
END

Select * from dbo.fnMultiStatement() 


--***************************** WHÝLE DÖNGÜSÜ *****************************

Declare @sayac int, @bitis int, 
		@id int,
		@ad varchar(25),
		@soyad varchar(25)

SET @sayac = (Select Min(Id) From Personel)
SET @bitis = (Select Max(Id) From Personel)


While(@sayac <= @bitis)
Begin --while döngüsünün baþlangýcýný belirtir
	Select @id = Null, @ad = Null, @soyad = Null

	if Exists (Select Id From Personel Where Id = @sayac)
	Begin --IF koþulunun saðlandýðý zaman çalýþtýrýlacak kod bloðunu tanýmlar.
		Select @id = p.Id, @ad = p.Ad, @soyad = p.Soyad from Personel p Where p.Id = @sayac
		Print CONCAT('Personel Id:', @id, ' ', @ad, ' ', @soyad)
	END  -- IF bitiþi

	Set @sayac += 1

END  -- While bitiþi

/*
Deðiþkenlerin Temizlenmesi: Select @id = Null, @ad = Null, @soyad = Null ifadesi, 
olasý önceki döngü verilerinin kalmamasý için deðiþkenleri temizler.
if Exists (...): Bu, döngüdeki kritik bir kontrol noktasýdýr. Personel tablosunda @sayac deðerine sahip bir Id olup olmadýðýný kontrol eder.

Neden Gerekli?: Eðer Personel tablosunda Id'ler arasýnda boþluklar varsa (örneðin 5 Id'sinden sonra 10 Id'sine geçiliyorsa), 
bu kontrol boþ Id'ler için gereksiz iþlem yapýlmasýný önler.

CONCAT (Concatenate) SQL Server'da kullanýlan bir metin birleþtirme (String Concatenation) fonksiyonudur.

Ýþlevi: Birden fazla metin ifadesini veya farklý veri tiplerini ( Id, boþluk, Ad, boþluk, Soyad )tek bir dize halinde birleþtirir.

Avantajý: Geleneksel olarak kullanýlan + operatörünün aksine, CONCAT fonksiyonu NULL (boþ) deðerleri otomatik olarak 
boþ metin ('') olarak kabul eder ve bu sayede birleþtirme iþlemi NULL nedeniyle kesintiye uðramaz.
*/



--******************* Cursor iþlemler **********************

--bu kýsým detaylý analizi daha sonra güncelleyeceðim

Select * From Personel
--CURSOR
--Bütün personellerin üzerinde Tek Tek Gezerek Gerekli Diðer (Detay) iþlemleri göz önüne alarak
--Zamlý Maaþ Hesabýný yapan Uygulama
Declare
@id int, @cinsiyet varchar(1), @maas float, @depkodu varchar(5), @dtarihi date,
@zaamliMaas Float

Declare crsperson CURSOR 
FOR Select p.Id, p.Cinsiyet, p.Maas, p.DepKodu, p.DTarihi from Personel p Where Id = 9
Open crsperson

FETCH NEXT FROM crsperson INTO @id, @cinsiyet, @maas, @depkodu, @dtarihi
Print Concat('@@fetch_status KODU: ', @@fetch_status)

While (@@fetch_status = 0)-- 0(Baþarýlý), 2 Bir Hata veya , (-1) (Kayýt Sonu) Boþ Veri Seti
Begin
	print Concat_ws(' ','Personel Verileri Id:', @id, 'Cinsiyet:',@cinsiyet)
	set @zaamliMaas = @maas * 0.80
	--Diðer Detay iþlemler
	Update Personel set Maas = @zaamliMaas Where Id = @id

	FETCH NEXT FROM crsperson INTO @id, @cinsiyet, @maas, @depkodu, @dtarihi
	Print Concat('@@fetch_status While: ', @@fetch_status)
END

close crsperson -- Cursor Nesnesini KAPAT
Deallocate crsperson -- Cursor Nesnesini BELLEKTEN TAMAMEN SÝL



Select * From Personel

--*********************CURSOR dEvam ***************************************
--bu kýsým daha sonra çalýþýlacak güncellenecek

--DROP PROC if Exists spMaasHesapla
if Exists(Select * from sys.objects Where Name = N'spMaasHesapla' AND Type = 'P')
DROP PROC  spMaasHesapla
GO

Create PROCEDURE spMaasHesapla @p_zamorani smallint, @p_sicilno varchar(15), @p_depkodu varchar(5)
AS
BEGIN

	Declare
	@id int, @cinsiyet varchar(1), @maas float, @depkodu varchar(5), @dtarihi date,
	@zaamliMaas Float

	Declare crsperson CURSOR 
	FOR 
	Select p.Id, p.Cinsiyet, p.Maas, p.DepKodu, p.DTarihi 
	from Personel p 
	Where 
	p.sicilno = ISNULL(@p_sicilno, p.Sicilno)
	AND p.DepKodu = ISNULL(@p_depkodu, p.DepKodu)

	Open crsperson

	FETCH NEXT FROM crsperson INTO @id, @cinsiyet, @maas, @depkodu, @dtarihi
	Print Concat('@@fetch_status KODU: ', @@fetch_status)

	While (@@fetch_status = 0)-- 0(Baþarýlý), 2 Bir Hata veya , (-1) (Kayýt Sonu) Boþ Veri Seti
	Begin
		print Concat_ws(' ','Personel Verileri Id:', @id, 'Cinsiyet:',@cinsiyet)
		set @zaamliMaas = (@maas * @p_zamorani/100) + @maas
		--Diðer Detay iþlemler
		Update Personel set Maas = @zaamliMaas Where Id = @id
		if @id >= 2
		RETURN -99

		FETCH NEXT FROM crsperson INTO @id, @cinsiyet, @maas, @depkodu, @dtarihi
		Print Concat('@@fetch_status While: ', @@fetch_status)
	END

	close crsperson -- Cursor Nesnesini KAPAT
	Deallocate crsperson -- Cursor Nesnesini BELLEKTEN TAMAMEN SÝL

	Select * From Personel

	Return 0

END -- PROC

GO
--EXECUTE
Declare @sonuc int 

  EXECute @sonuc = spMaasHesapla 40,Null, 'D1'

Print @sonuc


-- *********************************** CURSOR devam ************************
-- yine burasýda daha sonra analiz edilip güncellenecek

Drop Proc if Exists sp_SiparisSatirlari
Go

Create Procedure sp_SiparisSatirlari @p_orderno int
AS
Begin --Proc

	Declare  @orderno int, @productno int, @quntity float, @listprice float,
	@sayac int = 0
	--Set @p_orderno = 1
	--Select * from orders Where order_id = @orderno
	--Select order_id, product_id, quantity, list_price from orderitems Where order_id = 1
	--DEFAULT Cursor Settings Value: LOCAL - FORWARD_ONLY - READ_ONLY

	Declare siparis_satir Cursor LOCAL SCROLL DYNAMIC READ_ONLY -- LOCAL - FORWARD_ONLY - READ_ONLY 
	FOR
	Select order_id, product_id, quantity, list_price from orderitems Where order_id = @p_orderno

	OPEN siparis_satir

	FETCH NEXT FROM siparis_satir INTO @orderno, @productno, @quntity, @listprice

	While(@@FETCH_Status = 0)
	Begin
	
		print Concat('@@FETCH_Status: ', @@FETCH_Status, ' URUN_No:', @productno, ' Fiyat: ', @listprice, ' Sayac:', @sayac)
		Declare @tutar float
		Set @tutar = @quntity * @listprice

		--Print 'TUTAR: ' + Cast(@tutar as varchar)
		UPDATE orderitems Set quantity = quantity + 1 Where order_id = @orderno AND product_id = @productno

		if(@productno = 10 and @sayac <= 2)
		Begin
			Set @sayac +=1;
			FETCH PRIOR FROM siparis_satir INTO @orderno, @productno, @quntity, @listprice
			print 'Buraya Geldi'
		END
		ELSE
		FETCH NEXT FROM siparis_satir INTO @orderno, @productno, @quntity, @listprice
	END -- While

	CLOSE siparis_satir
	DEALLOCATE siparis_satir -- BELLEKTEN SÝL / YOK ET

	Select * from orderitems Where order_id = @p_orderno
END -- PROC

Go
--Execute veya Exec
 --execute sp_siparissatirlari @p_orderno = 1

Go

--**************** while örnekler *******************************

--1 den 100 e kadar olan sayýlardan 3 ve 4 tam bölünen sayýlarý ekrana yazdýrsýn
Declare @sayac int = 0

While(@sayac <= 100)
Begin
	if(@sayac % 3 = 0 AND @sayac % 4 = 0)
	Begin
		print @sayac
	END
	else
	Begin
		set @sayac +=1
		continue  --CONTINUE komutu, kendisinden sonra gelen tüm kod satýrlarýnýn o adým için atlanmasýný emreder.  en baþa döner(while)
	END
	
	print 'MERHABA'


	set @sayac +=1

End


-- 1 den 10 a kadar çift sayýlarý bul

DECLARE @sayac INT = 0;
DECLARE @bitis INT = 10;

PRINT '--- 1''den 10''a Kadar Çift Sayýlar Listesi ---';

WHILE (@sayac < @bitis)
BEGIN
    -- 1. Sayaç artýrýlýr (Döngüye baþlamadan önce artýrmak pratik bir yaklaþýmdýr)
    SET @sayac += 1;

    -- 2. Koþul Kontrolü (Tek sayý mý?)
    IF (@sayac % 2 != 0) -- Eðer sayý tek ise (2'ye bölümünden kalan 0 deðilse)
    BEGIN
        PRINT CONCAT('ATLANDI: ', @sayac, ' (Tek Sayý)');
        CONTINUE; --  CONTINUE: Bu noktadan sonraki kodlarý atla ve döngünün baþýna dön.
    END

    -- 3. Ýþlem (Sadece Çift Sayýlar Buraya Ulaþýr)
    PRINT CONCAT('ÝÞLENDÝ: ', @sayac, ' (Çift Sayý)');
    
    -- Baþka iþlemler burada yapýlabilirdi (UPDATE, INSERT vb.)

END



--1 den 10 a kadar olan sayýlarý ekrana yazdýralým
-- Tek ve Çift sayýlarýn toplamlarýný ayrý ayrý bulup yazdýralým
-- Tek toplam 11 veya çift Toplam 12 den büyük eþit ise Döngüden ÇIKILSIMASINI SAÐLAYALIM

Declare @sayac int = 1, @tektop int = 0, @cifttop int = 0

--While(@sayac <= 10 AND @tektop < 11 AND @cifttop < 12)
While(@sayac <= 10 )
Begin -- {
	print Concat('sayac: ', @sayac)

	if(@sayac % 2 = 0)
	Begin
		set @cifttop += @sayac
		--print 'Çift'
	End--if
	Else
		Set @tektop +=@sayac


--print Concat('TT: ', @tektop)
--print Concat('ÇT: ', @cifttop)	
	set @sayac +=1

	if(@tektop >= 11 OR @cifttop >= 12)
	break  -- while döngüsü biter
	--return --SONLANDIR ve ÇIK

END -- } While


print '---------------------'
print Concat('Tek Toplam: ', @tektop)
print Concat('Çift Toplam: ', @cifttop)
