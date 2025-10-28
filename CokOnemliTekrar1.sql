create table Personel(
Id int primary key identity,
sicilNo varchar(10) unique,
TCNo char(5) unique check(LEN(TCNo)=5),
Ad varchar(20) not null,
SoyAd varchar(20) not null,
Cinsiyet char(1) not null default('E') check(Cinsiyet='E' or Cinsiyet ='K'),
Maas decimal(12,4) not null default(0)
)

drop table if exists Personel
Create Table Personel(
	Id int Constraint  PK_Personel_Id PRIMARY KEY IDENTITY,
	Sicilno Varchar(10) Constraint UQ_Personel_Sicilno UNIQUE,
	TCNo Char(5) Constraint UQ_Personel_TCNo UNIQUE Constraint CK_Personel_TCNo CHECK(LEN(TCNo)= 5), -- ikinci constrainte asl�nda gerek yok k�s�tada isim vermi�
	Ad Varchar(20) NOT NULL,
	Soyad Varchar(20) NOT NULL,
	Cinsiyet char(1) NOT NULL Constraint DF_Personel_Cinsiyet Default('E') CHECK (Cinsiyet ='E' OR Cinsiyet = 'K'),
	Maas Decimal(12,4) NOT NULL Default(0)
)

insert into Personel(Sicilno,TCNo,Ad,Soyad,Cinsiyet,Maas)
Values('S3','12344','Burak','Toprak','E',77000),
	  ('S4','12343','�zkan','�im�ek','E',77000),
	  ('S5','12342','Ercan','�EL�K','E',47000),
	  ('S6','12341','G�lizar','DEM�RC�','K',52500),
	  ('S7','12340','Sevde','Y�ksel','K',52500),
	  ('S8','12334','Yi�it','�NCEL','E',92500),
	  ('S9','12335','Ya��z','EL�BOL','E',47000),
	  ('S10','12336','Hilal','D�NMEZ','K',52500),
	  ('S11','12356','Ebru','U�AKT�RK','K',52500)

select * from Personel

select ad,soyad,cinsiyet,maas  from Personel

select * from Personel order by Cinsiyet desc , Maas

select * from Personel where Cinsiyet='E' or Maas>50000 order by Cinsiyet,Maas

select  top 2 p.* from Personel p order by ad desc,Soyad desc

select  top 2 p.Ad , p.Soyad from Personel p order by Ad desc , Soyad desc

select p.* from Personel p where Maas > 40000 and Maas < 75000

select p.* from Personel p where Maas between 40000 and 75000 

select p.* from Personel p where Ad = ('Ertu�rul') or Ad=('Ercan')

select p.* from Personel p where ad In ( 'Ertu�rul' , 'Ercan')

select p.* from Personel p where  Soyad  like  'e%' and  Soyad like '%l'

--DTarihi sutun sil
--alter table Personel drop column DTarihi

alter table Personel add  Dtarihi date

select p.* from Personel p where Dtarihi is Null

select p.* from Personel p where ad is not null

update  Personel set Dtarihi ='1999-01-21' where ad = 'Ercan' and Soyad='�elik'

update Personel set Dtarihi ='1994-02-12' ,  Maas= 12000  where Cinsiyet='K' 

update Personel set Maas= (Maas*2.5) where ad = 'yi�it' and Soyad='�ncel' -- where SicilNo='S8' da diyebilirdik direk

--update Departmanlar set tel=asdadwd where Kodu='D1'  -- yani at�yorum kodu D1 olan sutunda bilgi i�lem var ve onun tel de�i�keni varsa o de�i�ir ama  ili�kili tablo olmal�

--S1:  departmanlar tablosuna D2-Muhasebe ve D6- Sat�nalma Departmanlar�n� ekleyen Sql

insert into Departmanlar ( kodu , ad� ) values 
('D2' , 'Muhasebe') , ('D6' , 'Sat�nAlma')

--S3: kad�n personellerin departmanlar�n� insan kaynaklar� olarak g�ncelleyen SQL

update Departmanlar set DepAd�= 'insan kaynaklar�' where cinsiyet='K' -- yada dep ad� yerine depkodu = 'd3' diyebilirdik d3 de insan kaynaklar�na ba�l�d�r


--S6: Departman� belli olan Erkek personelleri listeleyen SQL

select p.* from Personel p where DepKodu is not null and Cinsiyet ='E'

--S7: D11 Kodlu bilgi i�lem departman�n� kodunu D1 Olarak g�ncelleyen SQL

update Departmanlar set DepKodu= 'D1' where DepKodu = 'D11'

CREATE TABLE Bolgeler (
    BolgeNo  tinyint NOT NULL PRIMARY KEY,
    BolgeAdi varchar(25) NULL
);

insert into Bolgeler (BolgeNo, BolgeAdi) values 
(3, 'Akdeniz B�lgesi'),
(6, 'Do�u Anadolu B�lgesi'),
(2, 'Ege B�lgesi'),
(7, 'G�neydo�u Anadolu B�lgesi'),
(4, '�� Anadolu B�lgesi'),
(5, 'Karadeniz B�lgesi'),
(1, 'Marmara B�lgesi');

drop  table if exists iller

CREATE TABLE iller (
    
    ilkodu VARCHAR(3) constraint PK_iller_kodu primary key, 
    
   
    adi VARCHAR(25)   not null unique,
    BolgeNo tinyint Constraint FK_iller_Bolgeler_BolgeNo references Bolgeler(BolgeNo) -- fk(foreign key) pk ( primary key)  uq(unique key  ck(check) df ( default)
    on delete set null on update cascade  -- e�er b�lgelerdeki b�lge silinirse illerdeki bolgeno null olcak e�er bolge no de�i�irse illerdeki bolge no da de�i�ecek
    
   
);

drop table if exists ilceler

CREATE TABLE ilceler (
    
    Id INT constraint PK_ilceler_id  PRIMARY KEY  IDENTITY(1,1),  -- identity yerine auto_increment yazarsan her sql de cal�s�r 
    
    
    ilkodu VARCHAR(3) constraint FK_iller_ilceler_ilkodu  REFERENCES iller (ilkodu) ,
    
    
    adi VARCHAR(30) NOT NULL,
    
   
    constraint UQ_ilceler_ilkodu_Adi Unique(ilkodu,adi)  -- ikisini ba��ms�z unique yapmak i�in ayr� sat�rda yapt�k yani 2 sat�dada 06 cankaya olmas�n diye
                                                         -- normalde ayr� ayr� unique yapamay�z cunku birden fazla kullan�lacaklar ayr� ayr� ama ikisi birlikte ayn� anda
                                                         -- tekrar kullan�lamazlar
);


insert into iller (ilkodu,adi)
values  ('01' , 'Adana'),
('02', 'Ad�yaman'),
('03', 'Afyonkarahisar'),
('04', 'A�r�'),
('05', 'Amasya'),
('06', 'Ankara'),
('07', 'Antalya'),
('16', 'Bursa'),
('25', 'Erzurum'),
('34', '�stanbul'),
('45', '�zmir'),
('69', 'Bayburt')


select * from iller
        

--il�eler tablosuna veri ekleme

insert into ilceler (ilkodu , adi)
values ('06' , '�ankaya'),
       ('06' , 'Yenimahalle'),
       ('06' , 'G�lba��'),
       ('06' , 'Etimesgut'),
       ('06' , 'Mamak'),
       ('06' , 'Ke�i�ren'),
       ('06' , 'Sincan'),
       ('06' , 'Kahramankazan'),
       ('06' , 'Pursaklar'),
       ('06' , 'K�z�lc�hamam'),
       ('02' , 'G�lba��'),
       ('02' , 'Kahta'),
       ('01' , 'Ceyhan'),
       ('01' , 'Seyhan'),
       ('01' , '�ukurova'),
       ('01' , 'Pozant�')

       select * from ilceler

       --S2: iller verilerini il adlar�na g�re s�ral� olarak getiren SQL


       select p.* from iller p    order by p.adi asc

       --S3: ismi A ile Ba�layan ve A ile Biten illeri getiren SQL 

       select p.* from iller p  where p.adi like 'A%' and p.adi like '%A'

       --S4: isminde u veya b ge�en illeri getiren SQL

       select p.* from iller p  where p.adi like '%u%' or p.adi like '%b%'

       --S5: ankaran�n b�t�n il�elerini il�e ad�na g�re s�ral� olarak getiren SQL

       select p.* from ilceler p where p.ilkodu ='06' order by p.adi asc --******************************  bura �nemli a��klamay� oku  *****************
     
     /* Ad�m ad�m a��klama:

FROM ilceler p
 -ilceler tablosundaki t�m kay�tlar� (sat�rlar�) al�r.

WHERE p.ilkodu = '06'
 -Bu a�amada yaln�zca ilkodu de�eri '06' olan sat�rlar filtrelenir.
Yani tabloda 01, 02, 35 gibi di�er illere ait kay�tlar art�k sonu� k�mesinden tamamen ��kar�lm��t�r.

ORDER BY p.adi ASC
 -Art�k elimizde sadece ilkodu='06' olan sat�rlar var.
Bu kalan sat�rlar, adi s�tununa g�re A-Z (artan) bi�imde s�ralan�r.

-- yani program soldan sa�a okuyor o y�zden b�yle diyemeyiz !  sql i�lem mant��� �nceli�ine g�re i�ler mesela ilk kodumuz select p.*  ancak �nce  from ilceler p yi i�leme al�r
ayr�ca p de�i�keni i�ince 06 olanlar kald� o y�zden p.adi diyince 06 lar�n ad� yazd� diyemeyiz  p sadece bi �nad d�r i�inde veri tutmaz java gibi d���nme*/
-----------------------------------------------------------------------------------------------------------------------------------------------

--S1: toplam il say�s�n� getiren SQL

select COUNT(p.ilkodu) as ilsayisi from iller p  

--S2: toplam ilce say�s�n� getiren SQL 

select  count(p.ilkodu) as ilcesayisi  from ilceler p
select  count(*) as ilcesayisi  from ilceler p -- burda p.* olmuyor  p. dedikten sonra ilcelerdeki sutun isimleri ��k�yor onlardan birini se� diyor

--S3: ilcelerin id alanlar�n�n toplam�n� veren SQL
select  sum(p.Id) as ilceIdToplam from ilceler p

--S4: toplam personel maa��n� veren SQL
select sum(p.Maas) ToplamPersonelMaas from Personel p -- as kullan�m� zorunlu de�il

--S5: en b�y�k maas de�erini  getiren SQL
select MAX(p.Maas) as enYuksekMaas from Personel p
select  top 1 p.Maas EnYuksekMaas from Personel p order by p.Maas desc -- asc yani standart olan en k���k ten b�y��e s�ral�yor

--S6: en k���k Maa� de�erini Getiren SQL
select min(p.Maas) from Personel p
select top 1 p.Maas as enDusukMaas  from Personel p order by p.Maas asc

--S7: ortalama Maa� De�erini getiren SQL

select  sum(p.Maas)/ COUNT(p.Maas) as ortMaas from Personel p -- where yaz�p b�lme i�lemini yapamazd�k �ncesinde hallederiz cunku where getir demektir  elde bir�eyler olmal� ki yaps�n
select AVG(p.Maas) as ortMaas from Personel p



select  p.Cinsiyet, AVG(p.Maas) as ortMaas  from Personel p group by p.Cinsiyet having AVG(p.Maas)>0 -- having de ko�ul gerekli ayr�ca >0 demek yerine alttaki daha mant�kl�

select p.Cinsiyet, AVG(p.Maas) as ortMaas from Personel p group by p.Cinsiyet --  yukardakiyle ayn� ��kt�y� verir
-- yukarda cinsiyet ve ortMaas s�tunlar� mevcut oldu

select p.Cinsiyet  from Personel p group by p.Cinsiyet having AVG(p.Maas)>0 -- bunda hata vermedi ama ��kt�da sadece cinsiyet ��kar ve E K yazar okdr

select  p.* from Personel p group by p.Cinsiyet having AVG(p.Maas)>0  -- hata  verir c�nk� cinsiyete g�re gruplad� ancak ekrana ne olarak yazd�r�cak p.* sa�ma olur
-- yukardaki having k�sm� olmasa yine hata verirdi



select p.Cinsiyet, AVG(p.Maas) as ortMaas  from Personel p group by p.Cinsiyet having AVG(p.Maas)>20000 -- �imdi sadece E olan ��k�cak �nk� k�zlar�n ort  12000 mi�
-- select'den sonra avg yaz�lmazsa cal�sm�yor yapay zekayada sordum temel mant�k bu ba�ka olmuyoor k�saca cinsiyetleri gruplay�p her cinsiyetin toplam maas�n� al�yor ve 20000 �zeri olan
--cinsiyetlerinki ekrana yaz�lcak

select p.Cinsiyet, p.Maas from Personel p group by p.Cinsiyet having AVG(p.Maas)>0 -- hata verir yani sen 2. s�tuna p.Maas dedin ama bu kod maa�lar�n� yazar sonrada avg ald�n olmaz


--soru: personel isimlerinin uzunluklar�n� ( karakter) say�s�n� getiren

select p.Ad ,LEN(p.Ad) as uuzunluk from Personel p  -- �unu ��rendik ilk ba�ta len olan� yazd�m ama sadece uuzunluk s�tunu ve uzunluklar ��kt� birde id'ler ��kt� ama ne neyi ifade
--ediyor belli de�ildi ard�ndan en ba�a p.Ad � koydum b�ylelikle isimleri yaz�yor ve sonra uzunluk sutununda uzunluklar� yaz�yor �imdi anlad�kki select'ten sonra s�tunlar var

select p.Ad, LEN(p.Ad) as �simUzunluk,p.Soyad,LEN(p.Soyad)as SoyadUzunluk from Personel p

--soru: en uzun isme sahip olan personel/personelleri listeleyen sql

select p.* from Personel p where LEN(p.Ad)=8 -- bu �rnek sa�ma oldu ��nk� �uanki bilgimizle bu soruyu yapamay�z ama bu kullan�m�da g�r diye yazd�m

--S8: cinsiyetlerine g�re personel say�lar�n� getiren sql

select p.Cinsiyet, COUNT(p.Cinsiyet) as PersonelSay�s� from Personel p group by p.Cinsiyet

-- �imdi sql in dilini anlamaya �al��al�m ilk ba�ta from personel ile personel tablosunu ald� ard�ndan  gruplamay� yapt� yani cinsiyete g�re grupland�rd�
--yani burda count  asl�nda group by cinsiyet ile kolere cal�s�yor cinsiyete g�re gruplamasayd�k say�c� hata verirdi cunku neyi sayaca�� belli de�il
-- cinsiyete g�re grup olursa 2 cinsiyet olaca�� i�in 2 sat�r olacak yani cinsiyet s�tununda evet cinsiyetler yazacak ama gruplama olaca�� i�in ve 2 cinsiyet oldugu i�in
--2 sat�r olucak ard�ndan  say�c� s�tunda olu�acak say�c� s�tunda ise cinsiyet say�lar� yazacak

select p.Cinsiyet as PersonelSay�s� from Personel p group by p.Cinsiyet -- sadece E ve K olarak 2 sat�r olu�ur ama ba�ka bir�ey yazmaz 
select  COUNT(p.Cinsiyet) from Personel p group by p.Cinsiyet-- bunda s�k�nt� olmaz ama tablo k�t� g�z�k�r

--S9: departmanlar�na g�re personel say�lar�n� getiren sql -- *********************************** �NEML� ***************

-- �ncelikle bu tekrar veritaban�nda departmanlar tablosu yokmu� olu�tural�m
--ard�ndan personel ve departmanlar tablosunu birbirine DepKodu �zerinden ba�l�caz ancak bunun i�in bende �uan DepKodu s�t�nu yok o s�tunu'da eklememiz gerekiyor tabloya,
-- personel tablomuza sonradan DepKodu ekledik ve departmanlar ile ba�lad�k ancak e�itim veritaban�nda biz baz� personellere atamalar yapm��t�k �rne�in ercan d1 yani
--bilgi i�lemde gibi sonrada onu ayarlayaca��z
-- oldukca ��retici bir soru oldu

CREATE Table Departmanlar(
  Kodu Varchar(10) Constraint PK_Departman_kodu Primary Key,
  Adi Varchar(25) Not Null,
  Tel varchar(15)
  )

INSERT INTO Departmanlar (Kodu, Adi, Tel) VALUES
('D1', 'Bilgi ��lem', '03124441566'),
('D2', 'Muhasebe', NULL),
('D3', '�nsan kaynaklar�', NULL),
('D4', '�retim Planlama', NULL),
('D5', 'Sat�� ve Pazarlama', NULL),
('D6', 'Sat�nalma', NULL);

select p.* from Departmanlar p

select d.* from Personel d

alter table Personel
Add DepKodu varchar(10)

alter table Personel
add constraint FK_personel_Departmanlar
foreign key (DepKodu) references departmanlar(Kodu)
--not: yukardaki 2 adet alter  ��ylede olabilirdi personeli yeni olu�turuyor olsayd�k create i�inde DepKodu s�tununa s�ra gelince add depkodu diyip aly�na di�er alterdekileri yazard�k
--yani altersiz yapabilirdik ilk olu�um a�amas�nda ayr�ca constraint   fk yap�l�rken kullan�l�rsa amac� �teki tabloda mesela d99 yoksa onu eklemeni engeller veya d1 de birisi varsa
--onu silmeni engeller yani ba�lama yap�l�r ( atamalar yap�ld�kdan sonra) not id ler normal e�itim ile kar��t� o y�zden tablo farkl� g�r�lebilir sorun de�il

update  Personel set DepKodu='D1' where Id in (1,10,11)
update Personel set DepKodu='D3' where Id in(4,5,8,9)



--Soruyu tekrar hat�rlayal�m: departmanlar�na g�re personel say�lar�n� getiren sql

select p.Adi, COUNT(a.DepKodu)  from Departmanlar p, Personel a group by a.DepKodu -- b�yle d���nd�m ama olmad� altta hocan�n cevab� var onun alt�ndada yapay zekan�n ileriki
                                                                                   -- konular� kullanarak ��z�m� var

select p.DepKodu,count(*) as PerSayisi from Personel p group by p.Depkodu -- farkettiysen count sayac gruplanan �eyi say�yor ama ilk s�tunda uyumlu olmal� yani 3 l� uyum �art





-- yapay zeka cevab�--
SELECT 
    d.Adi AS DepartmanAdi,
    COUNT(p.Id) AS PersonelSayisi
FROM 
    Departmanlar AS d  -- d: Departmanlar tablosu i�in k�sa ad
LEFT JOIN 
    Personel AS p ON d.Kodu = p.DepKodu -- p: Personel tablosu i�in k�sa ad
GROUP BY 
    d.Adi  -- Departman ad�na g�re grupla
ORDER BY
    PersonelSayisi DESC; -- (�ste�e ba�l�) Say�ya g�re �oktan aza s�rala


    /*Sol Tablo: FROM Departmanlar AS d yazd���n i�in Departmanlar tablosudur.

Sa� Tablo: LEFT JOIN Personel AS p yazd���n i�in Personel tablosudur.

****INNER join ve LEFT join fark�******: INNER join'de e�le�meyenleri tabloya hi� almaz. left joinde ise  e�le�mese bile �ye olmasa bile yinede "null" olarak al�r ama sayac onu 0 kabul eder*/

    ---a�a��daki kendi mant���m

    select d.Adi, COUNT(p.Ad) as Ki�iSay�s� from Departmanlar d
    left join
    Personel as p on p.DepKodu=d.Kodu
    group by d.Adi

-----------------



--Soru (�NEML�): personelleri ve departmanlar�n� yazd�ran  SQL kodunu yaz


--not: biz fK yapsak bile yani 2 tabloyu ba�lasak bile sorgu esnas�nda inner join kullanmak zorunday�z ba�lama i�lemi  senin birbiri ile aralar�nda uyum olmal� kural� getirmendir
--yani sorgu ��kt� isterken d1 in bilgi i�leme tekabul etti�ini program hemen gidip bulmaz  FK(ba�lama)  sadece kurallar�na uymazsan hata verir mesala sa�ma veriler
--ekleyemezsin silemezsin vb. ona yarar   ilerde birini de�i�ince di�erleride otomatik de�i�sin vb onu sa�lam�� oluruz  gibi gibi. ama ��kt�da sorguda inner join gibi �eylerle
--ifade ederek sorgular�z altta farkl� t�rlerde kodlar yazd�m mesela s�rekli k�saltma p falan yap�yoruz ona gerek yok alttaki kodlar ve a��klamalar�n� oku


/*E�er "Sadece i�inde en az 1 personel olan departmanlar� g�rmek istiyorum" deseydin, o zaman INNER JOIN kullan�rd�n*/
SELECT  --
    personel.Ad, 
    personel.Soyad, 
    departmanlar.Adi AS DepartmanAdi
FROM 
    personel
INNER JOIN 
    departmanlar ON personel.DepKodu = departmanlar.Kodu;

    /*1. "Neden departmanlar ON diyoruz da personel ON demiyoruz?"
Burada k���k bir kavram yan�lg�s� var. ON komutu departmanlar tablosuna ait de�il.

JOIN c�mlesini bir b�t�n olarak okumal�y�z: INNER JOIN departmanlar ve ON personel.DepKodu = ...

Bu iki par�a, birlikte JOIN (Birle�tirme) i�lemini olu�turur.

�imdi bu c�mleyi SQL'e verdi�imiz emirler olarak T�rk�eye �evirelim:

FROM personel

Anlam�: "SQL, eline �nce personel listesini al." (Bu bizim ana listemiz)

INNER JOIN departmanlar

Anlam�: "�imdi, bu ana listeyle departmanlar listesini B�RLE�T�R."

ON personel.DepKodu = departmanlar.Kodu  || (�nce departmanlar.Kodu yazsakda olurdu burda farketmez)

Anlam�: "Bu birle�tirme i�lemini �U KURALA G�RE YAP (�ngilizce: 'ON this condition'): personel listesindeki DepKodu s�tunu, departmanlar listesindeki Kodu s�tununa e�it olanlar� e�le�tir."*/

    --noktal� kullan�m

    select p.Ad,p.Soyad,d.Adi as DepAdi from Personel p
    inner join 
    Departmanlar as d on p.DepKodu=d.Kodu

    


    ------
    SELECT 
    p.*
FROM 
    personel p
INNER JOIN 
    departmanlar ON p.DepKodu = departmanlar.Kodu;  -- burda sadece DepKodu olarak yazd� cunku selectten sonra adlar�n� yazcak bir komut girmedin sa�ma olur

    ---
    SELECT 
    p.*, -- Personel'in t�m s�tunlar�n� getir (DepKodu dahil)
    d.Adi AS DepartmanAdi -- En sona bir de departman ad�n� ekle
FROM 
    personel AS p
LEFT JOIN 
    departmanlar AS d ON p.DepKodu = d.Kodu;
   

   --S10: cinsiyetlerine g�re maa� toplamlar�n� getiren sql ******* mant��� anlamak i�in can al�c� soru bu ***********
   
   select p.Cinsiyet,Sum(p.Maas)as MaasToplam from Personel as p group by p.Cinsiyet -- �nceden  3 � korelasyon i�inde demi�tik anca sum'l� olan asl�nda sutunlar aras�ndaki korelasyona
                                                                                     -- ba�l� yani sum'l� olan count'da olabilirdi ilk s�tunda cinsiyetler grubu olacag� i�in o s�tuna
                                                                                     --ait sat�rdaki hepsini topluyor k�saca ilk sutun group by ile olu�uyor sum ise ilk sutuna g�re
                                                                                     --i�lem yap�yor bunu anlarsan bura tamam demekdir.

    --S11: departmanlar�na g�re maa� toplamlar�n� getiren sql

    select p.* from personel p

    select d.Adi as DepartmanAd�, SUM(p.Maas) as MaasToplam  from   Departmanlar as d
    left join Personel as p on d.Kodu=p.DepKodu
    group by d.Adi  -- yani departman ad�na g�re grupland�rd�k ki ilk s�tuna g�re toplamay� alabilsin bunu yukardaki mant��� anlatan can al�c� sorudan anlam��t�k zaten




    -----****** tabloda null yerine 0 yazmas� i�in ****---

    SELECT 
    d.Adi AS DepartmanAdi, 
    ISNULL(SUM(p.Maas),0) as MaasToplam -- E�er toplam NULL gelirse, onu 0'a �evir
FROM   
    Departmanlar AS d
LEFT JOIN 
    Personel AS p ON d.Kodu = p.DepKodu
GROUP BY 
    d.Adi;
    -------
    -- ba�lamadanda yap�labilir ��nk� personel tablosunda kodlar mevcuttu sadece departman isimleri ��kmaz
    select Depkodu, SUM(Maas) as TopMaas from Personel group by DepKodu

    --- a�a��da 11. soruyu inner join ile yapt�k

    select  d.Adi as DepAdi,SUM(p.Maas) as ToplamMaaslar�  from Departmanlar d  inner join Personel as p on p.DepKodu=d.Kodu group by d.Adi-- b�ylece  nulllar c�kmaz  isnull gibi olur

	

	
    --S12: departman ve cinsiyetlerine g�re personel say�lar�n� getiren sql
    

    insert into Personel values ('S12', '12348', 'Fatma', 'Durmaz', 'K', 55000.00, '1990-05-15', 'D1')
    insert into Personel values ('S13', '12392', 'Orhan', 'Kaymaz', 'E', 51000.00, '1990-05-12', 'D3')


     select  d.Adi ,p.Cinsiyet, COUNT(p.Id) as [Ki�i Say�s�]  from Departmanlar d left join Personel as p on p.DepKodu=d.Kodu group by d.Adi, p.Cinsiyet order by d.Adi asc 
    
    -- yukardaki order by adi asc �una yar�yor onu yazmazsak bilgi i�lem'deki erkek say�s�n� veriyor sonra di�er departman�n Erkeg�n� veriyor sonra �teki departman�n kad�n�n� veriyor
     --sonra  tekrar bilgi i�lemin kad�n�n� veriyor ama oder by adi asc yaparsak her departman�n kad�n�n� erkeg�n� yaz�p sonra �teki departmana ge�iyor ��nk� isme g�re s�ralam�� olduk
     -- asl�nda bu mant�ken gruplamaya giriyor gibi geliyor ama bunu order by ile yapt�k bu �nemli bunun i�in order by i silip  ��kt�ya bakabilirsin mevzuyu anlars�n
     -- count(*) yapsak sadece bu bile yeterliydi ayr�ca order by d.Adi,p.cinsiyet deseydik oda olurdu

     select p.* from personel p
     select d.* from Departmanlar d

     --- *********************yapay zeka cevab� ***************---
     SELECT
    -- E�er Departmanlar.Adi NULL ise (yani DepKodu NULL olan personel i�in),
    -- oraya 'Departman Atanmam��' yaz, de�ilse departman ad�n� yaz.
    ISNULL(d.Adi, 'Departman Atanmam��') AS DepartmanAdi,
    p.Cinsiyet,
    COUNT(*) AS PersonelSayisi
FROM
    dbo.Personel AS p
LEFT JOIN
    dbo.Departmanlar AS d ON p.DepKodu = d.Kodu
GROUP BY
    -- Gruplamay� da ayn� ISNULL mant���yla yap�yoruz.
    ISNULL(d.Adi, 'Departman Atanmam��'),
    p.Cinsiyet
ORDER BY
    -- Sonu�lar� daha okunakl� olmas� i�in s�ralayal�m.
    DepartmanAdi,
    Cinsiyet;

    --S13: departman ve cinsiyetlerine g�re maa� toplamlar�n� getiren sql *** �nemli mant�k hatam varm�� left join ve from ayr�m� �ok �nemli ----
    --not: farkettiysen order by k�sm�nda  [Departman Ad�] yapt�k bu ince n�ans� g�rmen laz�m ��nk� s�tunumuzun takma ismi Departman Ad�
    --order by �n amac� dedi�im gibi  e�er yapmazsak bilgi i�lem E diyor sonra �nsan kaynaklar� E diyor sonra k�zlara ge�iyor onu engellemek

    select  isNull(d.Adi ,'Departman Atanmam��') as [Departman Ad�] ,
    p.Cinsiyet,
    SUM(p.Maas) as [Maas Toplamlar�]
    from Departmanlar d left join Personel as p on p.DepKodu=d.Kodu group by isnull(d.Adi,'Departman Atanmam��'),p.Cinsiyet  order by [Departman Ad�],p.Cinsiyet

    ---yukardaki kod t�m departmanlar� getir sonra personele g�re ayarla mant���nda bir�ey bu y�zden  ��kt� oluyor ama nulllar kaybolmuyor 
    -- mant�ksal bir sa�mal�k var personel listesi �zerinden bir gruplama yapmal�y�z daha do�ru olur



    SELECT
    -- Departman ad� yoksa 'Departman Atanmam��' yaz
    ISNULL(d.Adi, 'Departman Atanmam��') AS [Departman Ad�],
    p.Cinsiyet,
    SUM(p.Maas) AS [Maas Toplamlar�]
FROM
    -- Ana tablo 'Personel' olmal�, 'Departmanlar' de�il.
    Personel AS p
LEFT JOIN
    Departmanlar AS d ON p.DepKodu = d.Kodu
GROUP BY
    -- Gruplama ifadesi ne ise...
    ISNULL(d.Adi, 'Departman Atanmam��'),
    p.Cinsiyet
ORDER BY
    -- S�ralama ifadesi de o olmal� (veya SELECT'teki takma ad�)
    [Departman Ad�],
    p.Cinsiyet;

    --s14: departman ve cinsiyetlerine g�re personel say�lar�n� ve maas toplamlar�n� getiren sql *** �nemli bir mant�k anlayaca��n soru***

    
    select  isnull(d.Adi,'Departman Ad� Girilmemi�'),
    p.Cinsiyet,
    COUNT(*),
    SUM(p.Maas) as MaasToplam
    from Personel p left join  Departmanlar as d on d.Kodu=p.DepKodu
    group by 
    ISNULL(d.Adi,'Departman Ad� Girilmemi�'),
    p.Cinsiyet
    order by
    ISNULL(d.Adi,'Departman Ad� Girilmemi�'),
    p.Cinsiyet

    --yukardan iki �ey ��rendik selectte  ne yazd�ysan gruplama ve order  by k�sm� onla  ayn� olmal� mesela '' i�inde yazan bile ayn� olmal�
    --ama order by da takma ad� varsa sadece onu yazsan yeter burda sa�mal�k var gibi ama bunun sebebi sql in kodlar� cal�st�rma s�ras�ndan kaynaklan�yor
    -- yani sql order by k�sm�n� en sona b�rak�rken group by k�sm�n� select leri olu�turmadan okuyor o y�zden a�a��daki sa�mal�k oluyor
    --ayr�ca  select'ten sonra isnull diyerek s�tun i�inde ayr� bir sat�rda yaratm�� oluyoruz  bu n�ans�da yakalaman laz�m sonraki [] genel s�tun ismi
    

    select p.* from personel p

    select  isnull(d.Adi,'Departman Ad� Girilmemi�') as [Departman Adlar�], -- bu arada [] aras�na Departman Ad� girilmemi� yazarsan t�m sutun bunu yazar sacma olur
    p.Cinsiyet,
    COUNT(*) as personelSay�s�,
    SUM(p.Maas) as MaasToplam
    from Personel p left join  Departmanlar as d on d.Kodu=p.DepKodu
    group by 
    ISNULL(d.Adi,'Departman Ad� Girilmemi�'),  --- asl�nda burdada isnul olma sebebi sonu�ta departman ad� girilmeyenlerinde bi grubu olmal�ki sayac onada cal�ss�nn
    p.Cinsiyet
    order by
    [Departman Adlar�],
    p.Cinsiyet
    
















