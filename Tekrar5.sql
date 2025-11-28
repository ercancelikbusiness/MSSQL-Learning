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