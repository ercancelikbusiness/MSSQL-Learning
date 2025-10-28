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
	TCNo Char(5) Constraint UQ_Personel_TCNo UNIQUE Constraint CK_Personel_TCNo CHECK(LEN(TCNo)= 5), -- ikinci constrainte aslýnda gerek yok kýsýtada isim vermiþ
	Ad Varchar(20) NOT NULL,
	Soyad Varchar(20) NOT NULL,
	Cinsiyet char(1) NOT NULL Constraint DF_Personel_Cinsiyet Default('E') CHECK (Cinsiyet ='E' OR Cinsiyet = 'K'),
	Maas Decimal(12,4) NOT NULL Default(0)
)

insert into Personel(Sicilno,TCNo,Ad,Soyad,Cinsiyet,Maas)
Values('S3','12344','Burak','Toprak','E',77000),
	  ('S4','12343','Özkan','Þimþek','E',77000),
	  ('S5','12342','Ercan','ÇELÝK','E',47000),
	  ('S6','12341','Gülizar','DEMÝRCÝ','K',52500),
	  ('S7','12340','Sevde','Yüksel','K',52500),
	  ('S8','12334','Yiðit','ÖNCEL','E',92500),
	  ('S9','12335','Yaðýz','ELÝBOL','E',47000),
	  ('S10','12336','Hilal','DÖNMEZ','K',52500),
	  ('S11','12356','Ebru','UÇAKTÜRK','K',52500)

select * from Personel

select ad,soyad,cinsiyet,maas  from Personel

select * from Personel order by Cinsiyet desc , Maas

select * from Personel where Cinsiyet='E' or Maas>50000 order by Cinsiyet,Maas

select  top 2 p.* from Personel p order by ad desc,Soyad desc

select  top 2 p.Ad , p.Soyad from Personel p order by Ad desc , Soyad desc

select p.* from Personel p where Maas > 40000 and Maas < 75000

select p.* from Personel p where Maas between 40000 and 75000 

select p.* from Personel p where Ad = ('Ertuðrul') or Ad=('Ercan')

select p.* from Personel p where ad In ( 'Ertuðrul' , 'Ercan')

select p.* from Personel p where  Soyad  like  'e%' and  Soyad like '%l'

--DTarihi sutun sil
--alter table Personel drop column DTarihi

alter table Personel add  Dtarihi date

select p.* from Personel p where Dtarihi is Null

select p.* from Personel p where ad is not null

update  Personel set Dtarihi ='1999-01-21' where ad = 'Ercan' and Soyad='Çelik'

update Personel set Dtarihi ='1994-02-12' ,  Maas= 12000  where Cinsiyet='K' 

update Personel set Maas= (Maas*2.5) where ad = 'yiðit' and Soyad='Öncel' -- where SicilNo='S8' da diyebilirdik direk

--update Departmanlar set tel=asdadwd where Kodu='D1'  -- yani atýyorum kodu D1 olan sutunda bilgi iþlem var ve onun tel deðiþkeni varsa o deðiþir ama  iliþkili tablo olmalý

--S1:  departmanlar tablosuna D2-Muhasebe ve D6- Satýnalma Departmanlarýný ekleyen Sql

insert into Departmanlar ( kodu , adý ) values 
('D2' , 'Muhasebe') , ('D6' , 'SatýnAlma')

--S3: kadýn personellerin departmanlarýný insan kaynaklarý olarak güncelleyen SQL

update Departmanlar set DepAdý= 'insan kaynaklarý' where cinsiyet='K' -- yada dep adý yerine depkodu = 'd3' diyebilirdik d3 de insan kaynaklarýna baðlýdýr


--S6: Departmaný belli olan Erkek personelleri listeleyen SQL

select p.* from Personel p where DepKodu is not null and Cinsiyet ='E'

--S7: D11 Kodlu bilgi iþlem departmanýný kodunu D1 Olarak güncelleyen SQL

update Departmanlar set DepKodu= 'D1' where DepKodu = 'D11'

CREATE TABLE Bolgeler (
    BolgeNo  tinyint NOT NULL PRIMARY KEY,
    BolgeAdi varchar(25) NULL
);

insert into Bolgeler (BolgeNo, BolgeAdi) values 
(3, 'Akdeniz Bölgesi'),
(6, 'Doðu Anadolu Bölgesi'),
(2, 'Ege Bölgesi'),
(7, 'Güneydoðu Anadolu Bölgesi'),
(4, 'Ýç Anadolu Bölgesi'),
(5, 'Karadeniz Bölgesi'),
(1, 'Marmara Bölgesi');

drop  table if exists iller

CREATE TABLE iller (
    
    ilkodu VARCHAR(3) constraint PK_iller_kodu primary key, 
    
   
    adi VARCHAR(25)   not null unique,
    BolgeNo tinyint Constraint FK_iller_Bolgeler_BolgeNo references Bolgeler(BolgeNo) -- fk(foreign key) pk ( primary key)  uq(unique key  ck(check) df ( default)
    on delete set null on update cascade  -- eðer bölgelerdeki bölge silinirse illerdeki bolgeno null olcak eðer bolge no deðiþirse illerdeki bolge no da deðiþecek
    
   
);

drop table if exists ilceler

CREATE TABLE ilceler (
    
    Id INT constraint PK_ilceler_id  PRIMARY KEY  IDENTITY(1,1),  -- identity yerine auto_increment yazarsan her sql de calýsýr 
    
    
    ilkodu VARCHAR(3) constraint FK_iller_ilceler_ilkodu  REFERENCES iller (ilkodu) ,
    
    
    adi VARCHAR(30) NOT NULL,
    
   
    constraint UQ_ilceler_ilkodu_Adi Unique(ilkodu,adi)  -- ikisini baðýmsýz unique yapmak için ayrý satýrda yaptýk yani 2 satýdada 06 cankaya olmasýn diye
                                                         -- normalde ayrý ayrý unique yapamayýz cunku birden fazla kullanýlacaklar ayrý ayrý ama ikisi birlikte ayný anda
                                                         -- tekrar kullanýlamazlar
);


insert into iller (ilkodu,adi)
values  ('01' , 'Adana'),
('02', 'Adýyaman'),
('03', 'Afyonkarahisar'),
('04', 'Aðrý'),
('05', 'Amasya'),
('06', 'Ankara'),
('07', 'Antalya'),
('16', 'Bursa'),
('25', 'Erzurum'),
('34', 'Ýstanbul'),
('45', 'Ýzmir'),
('69', 'Bayburt')


select * from iller
        

--ilçeler tablosuna veri ekleme

insert into ilceler (ilkodu , adi)
values ('06' , 'Çankaya'),
       ('06' , 'Yenimahalle'),
       ('06' , 'Gölbaþý'),
       ('06' , 'Etimesgut'),
       ('06' , 'Mamak'),
       ('06' , 'Keçiören'),
       ('06' , 'Sincan'),
       ('06' , 'Kahramankazan'),
       ('06' , 'Pursaklar'),
       ('06' , 'Kýzýlcýhamam'),
       ('02' , 'Gölbaþý'),
       ('02' , 'Kahta'),
       ('01' , 'Ceyhan'),
       ('01' , 'Seyhan'),
       ('01' , 'Çukurova'),
       ('01' , 'Pozantý')

       select * from ilceler

       --S2: iller verilerini il adlarýna göre sýralý olarak getiren SQL


       select p.* from iller p    order by p.adi asc

       --S3: ismi A ile Baþlayan ve A ile Biten illeri getiren SQL 

       select p.* from iller p  where p.adi like 'A%' and p.adi like '%A'

       --S4: isminde u veya b geçen illeri getiren SQL

       select p.* from iller p  where p.adi like '%u%' or p.adi like '%b%'

       --S5: ankaranýn bütün ilçelerini ilçe adýna göre sýralý olarak getiren SQL

       select p.* from ilceler p where p.ilkodu ='06' order by p.adi asc --******************************  bura önemli açýklamayý oku  *****************
     
     /* Adým adým açýklama:

FROM ilceler p
 -ilceler tablosundaki tüm kayýtlarý (satýrlarý) alýr.

WHERE p.ilkodu = '06'
 -Bu aþamada yalnýzca ilkodu deðeri '06' olan satýrlar filtrelenir.
Yani tabloda 01, 02, 35 gibi diðer illere ait kayýtlar artýk sonuç kümesinden tamamen çýkarýlmýþtýr.

ORDER BY p.adi ASC
 -Artýk elimizde sadece ilkodu='06' olan satýrlar var.
Bu kalan satýrlar, adi sütununa göre A-Z (artan) biçimde sýralanýr.

-- yani program soldan saða okuyor o yüzden böyle diyemeyiz !  sql iþlem mantýðý önceliðine göre iþler mesela ilk kodumuz select p.*  ancak önce  from ilceler p yi iþleme alýr
ayrýca p deðiþkeni içince 06 olanlar kaldý o yüzden p.adi diyince 06 larýn adý yazdý diyemeyiz  p sadece bi önad dýr içinde veri tutmaz java gibi düþünme*/
-----------------------------------------------------------------------------------------------------------------------------------------------

--S1: toplam il sayýsýný getiren SQL

select COUNT(p.ilkodu) as ilsayisi from iller p  

--S2: toplam ilce sayýsýný getiren SQL 

select  count(p.ilkodu) as ilcesayisi  from ilceler p
select  count(*) as ilcesayisi  from ilceler p -- burda p.* olmuyor  p. dedikten sonra ilcelerdeki sutun isimleri çýkýyor onlardan birini seç diyor

--S3: ilcelerin id alanlarýnýn toplamýný veren SQL
select  sum(p.Id) as ilceIdToplam from ilceler p

--S4: toplam personel maaþýný veren SQL
select sum(p.Maas) ToplamPersonelMaas from Personel p -- as kullanýmý zorunlu deðil

--S5: en büyük maas deðerini  getiren SQL
select MAX(p.Maas) as enYuksekMaas from Personel p
select  top 1 p.Maas EnYuksekMaas from Personel p order by p.Maas desc -- asc yani standart olan en küçük ten büyüðe sýralýyor

--S6: en küçük Maaþ deðerini Getiren SQL
select min(p.Maas) from Personel p
select top 1 p.Maas as enDusukMaas  from Personel p order by p.Maas asc

--S7: ortalama Maaþ Deðerini getiren SQL

select  sum(p.Maas)/ COUNT(p.Maas) as ortMaas from Personel p -- where yazýp bölme iþlemini yapamazdýk öncesinde hallederiz cunku where getir demektir  elde birþeyler olmalý ki yapsýn
select AVG(p.Maas) as ortMaas from Personel p



select  p.Cinsiyet, AVG(p.Maas) as ortMaas  from Personel p group by p.Cinsiyet having AVG(p.Maas)>0 -- having de koþul gerekli ayrýca >0 demek yerine alttaki daha mantýklý

select p.Cinsiyet, AVG(p.Maas) as ortMaas from Personel p group by p.Cinsiyet --  yukardakiyle ayný çýktýyý verir
-- yukarda cinsiyet ve ortMaas sütunlarý mevcut oldu

select p.Cinsiyet  from Personel p group by p.Cinsiyet having AVG(p.Maas)>0 -- bunda hata vermedi ama çýktýda sadece cinsiyet çýkar ve E K yazar okdr

select  p.* from Personel p group by p.Cinsiyet having AVG(p.Maas)>0  -- hata  verir cünkü cinsiyete göre grupladý ancak ekrana ne olarak yazdýrýcak p.* saçma olur
-- yukardaki having kýsmý olmasa yine hata verirdi



select p.Cinsiyet, AVG(p.Maas) as ortMaas  from Personel p group by p.Cinsiyet having AVG(p.Maas)>20000 -- þimdi sadece E olan çýkýcak ünkü kýzlarýn ort  12000 miþ
-- select'den sonra avg yazýlmazsa calýsmýyor yapay zekayada sordum temel mantýk bu baþka olmuyoor kýsaca cinsiyetleri gruplayýp her cinsiyetin toplam maasýný alýyor ve 20000 üzeri olan
--cinsiyetlerinki ekrana yazýlcak

select p.Cinsiyet, p.Maas from Personel p group by p.Cinsiyet having AVG(p.Maas)>0 -- hata verir yani sen 2. sütuna p.Maas dedin ama bu kod maaþlarýný yazar sonrada avg aldýn olmaz


--soru: personel isimlerinin uzunluklarýný ( karakter) sayýsýný getiren

select p.Ad ,LEN(p.Ad) as uuzunluk from Personel p  -- þunu öðrendik ilk baþta len olaný yazdým ama sadece uuzunluk sütunu ve uzunluklar çýktý birde id'ler çýktý ama ne neyi ifade
--ediyor belli deðildi ardýndan en baþa p.Ad ý koydum böylelikle isimleri yazýyor ve sonra uzunluk sutununda uzunluklarý yazýyor þimdi anladýkki select'ten sonra sütunlar var

select p.Ad, LEN(p.Ad) as ÝsimUzunluk,p.Soyad,LEN(p.Soyad)as SoyadUzunluk from Personel p

--soru: en uzun isme sahip olan personel/personelleri listeleyen sql

select p.* from Personel p where LEN(p.Ad)=8 -- bu örnek saçma oldu çünkü þuanki bilgimizle bu soruyu yapamayýz ama bu kullanýmýda gör diye yazdým

--S8: cinsiyetlerine göre personel sayýlarýný getiren sql

select p.Cinsiyet, COUNT(p.Cinsiyet) as PersonelSayýsý from Personel p group by p.Cinsiyet

-- þimdi sql in dilini anlamaya çalýþalým ilk baþta from personel ile personel tablosunu aldý ardýndan  gruplamayý yaptý yani cinsiyete göre gruplandýrdý
--yani burda count  aslýnda group by cinsiyet ile kolere calýsýyor cinsiyete göre gruplamasaydýk sayýcý hata verirdi cunku neyi sayacaðý belli deðil
-- cinsiyete göre grup olursa 2 cinsiyet olacaðý için 2 satýr olacak yani cinsiyet sütununda evet cinsiyetler yazacak ama gruplama olacaðý için ve 2 cinsiyet oldugu için
--2 satýr olucak ardýndan  sayýcý sütunda oluþacak sayýcý sütunda ise cinsiyet sayýlarý yazacak

select p.Cinsiyet as PersonelSayýsý from Personel p group by p.Cinsiyet -- sadece E ve K olarak 2 satýr oluþur ama baþka birþey yazmaz 
select  COUNT(p.Cinsiyet) from Personel p group by p.Cinsiyet-- bunda sýkýntý olmaz ama tablo kötü güzükür

--S9: departmanlarýna göre personel sayýlarýný getiren sql -- *********************************** ÖNEMLÝ ***************

-- öncelikle bu tekrar veritabanýnda departmanlar tablosu yokmuþ oluþturalým
--ardýndan personel ve departmanlar tablosunu birbirine DepKodu üzerinden baðlýcaz ancak bunun için bende þuan DepKodu sütünu yok o sütunu'da eklememiz gerekiyor tabloya,
-- personel tablomuza sonradan DepKodu ekledik ve departmanlar ile baðladýk ancak eðitim veritabanýnda biz bazý personellere atamalar yapmýþtýk örneðin ercan d1 yani
--bilgi iþlemde gibi sonrada onu ayarlayacaðýz
-- oldukca öðretici bir soru oldu

CREATE Table Departmanlar(
  Kodu Varchar(10) Constraint PK_Departman_kodu Primary Key,
  Adi Varchar(25) Not Null,
  Tel varchar(15)
  )

INSERT INTO Departmanlar (Kodu, Adi, Tel) VALUES
('D1', 'Bilgi Ýþlem', '03124441566'),
('D2', 'Muhasebe', NULL),
('D3', 'Ýnsan kaynaklarý', NULL),
('D4', 'Üretim Planlama', NULL),
('D5', 'Satýþ ve Pazarlama', NULL),
('D6', 'Satýnalma', NULL);

select p.* from Departmanlar p

select d.* from Personel d

alter table Personel
Add DepKodu varchar(10)

alter table Personel
add constraint FK_personel_Departmanlar
foreign key (DepKodu) references departmanlar(Kodu)
--not: yukardaki 2 adet alter  þöylede olabilirdi personeli yeni oluþturuyor olsaydýk create içinde DepKodu sütununa sýra gelince add depkodu diyip alyýna diðer alterdekileri yazardýk
--yani altersiz yapabilirdik ilk oluþum aþamasýnda ayrýca constraint   fk yapýlýrken kullanýlýrsa amacý öteki tabloda mesela d99 yoksa onu eklemeni engeller veya d1 de birisi varsa
--onu silmeni engeller yani baðlama yapýlýr ( atamalar yapýldýkdan sonra) not id ler normal eðitim ile karýþtý o yüzden tablo farklý görülebilir sorun deðil

update  Personel set DepKodu='D1' where Id in (1,10,11)
update Personel set DepKodu='D3' where Id in(4,5,8,9)



--Soruyu tekrar hatýrlayalým: departmanlarýna göre personel sayýlarýný getiren sql

select p.Adi, COUNT(a.DepKodu)  from Departmanlar p, Personel a group by a.DepKodu -- böyle düþündüm ama olmadý altta hocanýn cevabý var onun altýndada yapay zekanýn ileriki
                                                                                   -- konularý kullanarak çözümü var

select p.DepKodu,count(*) as PerSayisi from Personel p group by p.Depkodu -- farkettiysen count sayac gruplanan þeyi sayýyor ama ilk sütunda uyumlu olmalý yani 3 lü uyum þart





-- yapay zeka cevabý--
SELECT 
    d.Adi AS DepartmanAdi,
    COUNT(p.Id) AS PersonelSayisi
FROM 
    Departmanlar AS d  -- d: Departmanlar tablosu için kýsa ad
LEFT JOIN 
    Personel AS p ON d.Kodu = p.DepKodu -- p: Personel tablosu için kýsa ad
GROUP BY 
    d.Adi  -- Departman adýna göre grupla
ORDER BY
    PersonelSayisi DESC; -- (Ýsteðe baðlý) Sayýya göre çoktan aza sýrala


    /*Sol Tablo: FROM Departmanlar AS d yazdýðýn için Departmanlar tablosudur.

Sað Tablo: LEFT JOIN Personel AS p yazdýðýn için Personel tablosudur.

****INNER join ve LEFT join farký******: INNER join'de eþleþmeyenleri tabloya hiç almaz. left joinde ise  eþleþmese bile üye olmasa bile yinede "null" olarak alýr ama sayac onu 0 kabul eder*/

    ---aþaðýdaki kendi mantýðým

    select d.Adi, COUNT(p.Ad) as KiþiSayýsý from Departmanlar d
    left join
    Personel as p on p.DepKodu=d.Kodu
    group by d.Adi

-----------------



--Soru (ÖNEMLÝ): personelleri ve departmanlarýný yazdýran  SQL kodunu yaz


--not: biz fK yapsak bile yani 2 tabloyu baðlasak bile sorgu esnasýnda inner join kullanmak zorundayýz baðlama iþlemi  senin birbiri ile aralarýnda uyum olmalý kuralý getirmendir
--yani sorgu çýktý isterken d1 in bilgi iþleme tekabul ettiðini program hemen gidip bulmaz  FK(baðlama)  sadece kurallarýna uymazsan hata verir mesala saçma veriler
--ekleyemezsin silemezsin vb. ona yarar   ilerde birini deðiþince diðerleride otomatik deðiþsin vb onu saðlamýþ oluruz  gibi gibi. ama çýktýda sorguda inner join gibi þeylerle
--ifade ederek sorgularýz altta farklý türlerde kodlar yazdým mesela sürekli kýsaltma p falan yapýyoruz ona gerek yok alttaki kodlar ve açýklamalarýný oku


/*Eðer "Sadece içinde en az 1 personel olan departmanlarý görmek istiyorum" deseydin, o zaman INNER JOIN kullanýrdýn*/
SELECT  --
    personel.Ad, 
    personel.Soyad, 
    departmanlar.Adi AS DepartmanAdi
FROM 
    personel
INNER JOIN 
    departmanlar ON personel.DepKodu = departmanlar.Kodu;

    /*1. "Neden departmanlar ON diyoruz da personel ON demiyoruz?"
Burada küçük bir kavram yanýlgýsý var. ON komutu departmanlar tablosuna ait deðil.

JOIN cümlesini bir bütün olarak okumalýyýz: INNER JOIN departmanlar ve ON personel.DepKodu = ...

Bu iki parça, birlikte JOIN (Birleþtirme) iþlemini oluþturur.

Þimdi bu cümleyi SQL'e verdiðimiz emirler olarak Türkçeye çevirelim:

FROM personel

Anlamý: "SQL, eline önce personel listesini al." (Bu bizim ana listemiz)

INNER JOIN departmanlar

Anlamý: "Þimdi, bu ana listeyle departmanlar listesini BÝRLEÞTÝR."

ON personel.DepKodu = departmanlar.Kodu  || (önce departmanlar.Kodu yazsakda olurdu burda farketmez)

Anlamý: "Bu birleþtirme iþlemini ÞU KURALA GÖRE YAP (Ýngilizce: 'ON this condition'): personel listesindeki DepKodu sütunu, departmanlar listesindeki Kodu sütununa eþit olanlarý eþleþtir."*/

    --noktalý kullaným

    select p.Ad,p.Soyad,d.Adi as DepAdi from Personel p
    inner join 
    Departmanlar as d on p.DepKodu=d.Kodu

    


    ------
    SELECT 
    p.*
FROM 
    personel p
INNER JOIN 
    departmanlar ON p.DepKodu = departmanlar.Kodu;  -- burda sadece DepKodu olarak yazdý cunku selectten sonra adlarýný yazcak bir komut girmedin saçma olur

    ---
    SELECT 
    p.*, -- Personel'in tüm sütunlarýný getir (DepKodu dahil)
    d.Adi AS DepartmanAdi -- En sona bir de departman adýný ekle
FROM 
    personel AS p
LEFT JOIN 
    departmanlar AS d ON p.DepKodu = d.Kodu;
   

   --S10: cinsiyetlerine göre maaþ toplamlarýný getiren sql ******* mantýðý anlamak için can alýcý soru bu ***********
   
   select p.Cinsiyet,Sum(p.Maas)as MaasToplam from Personel as p group by p.Cinsiyet -- önceden  3 ü korelasyon içinde demiþtik anca sum'lý olan aslýnda sutunlar arasýndaki korelasyona
                                                                                     -- baðlý yani sum'lý olan count'da olabilirdi ilk sütunda cinsiyetler grubu olacagý için o sütuna
                                                                                     --ait satýrdaki hepsini topluyor kýsaca ilk sutun group by ile oluþuyor sum ise ilk sutuna göre
                                                                                     --iþlem yapýyor bunu anlarsan bura tamam demekdir.

    --S11: departmanlarýna göre maaþ toplamlarýný getiren sql

    select p.* from personel p

    select d.Adi as DepartmanAdý, SUM(p.Maas) as MaasToplam  from   Departmanlar as d
    left join Personel as p on d.Kodu=p.DepKodu
    group by d.Adi  -- yani departman adýna göre gruplandýrdýk ki ilk sütuna göre toplamayý alabilsin bunu yukardaki mantýðý anlatan can alýcý sorudan anlamýþtýk zaten




    -----****** tabloda null yerine 0 yazmasý için ****---

    SELECT 
    d.Adi AS DepartmanAdi, 
    ISNULL(SUM(p.Maas),0) as MaasToplam -- Eðer toplam NULL gelirse, onu 0'a çevir
FROM   
    Departmanlar AS d
LEFT JOIN 
    Personel AS p ON d.Kodu = p.DepKodu
GROUP BY 
    d.Adi;
    -------
    -- baðlamadanda yapýlabilir çünkü personel tablosunda kodlar mevcuttu sadece departman isimleri çýkmaz
    select Depkodu, SUM(Maas) as TopMaas from Personel group by DepKodu

    --- aþaðýda 11. soruyu inner join ile yaptýk

    select  d.Adi as DepAdi,SUM(p.Maas) as ToplamMaaslarý  from Departmanlar d  inner join Personel as p on p.DepKodu=d.Kodu group by d.Adi-- böylece  nulllar cýkmaz  isnull gibi olur

	

	
    --S12: departman ve cinsiyetlerine göre personel sayýlarýný getiren sql
    

    insert into Personel values ('S12', '12348', 'Fatma', 'Durmaz', 'K', 55000.00, '1990-05-15', 'D1')
    insert into Personel values ('S13', '12392', 'Orhan', 'Kaymaz', 'E', 51000.00, '1990-05-12', 'D3')


     select  d.Adi ,p.Cinsiyet, COUNT(p.Id) as [Kiþi Sayýsý]  from Departmanlar d left join Personel as p on p.DepKodu=d.Kodu group by d.Adi, p.Cinsiyet order by d.Adi asc 
    
    -- yukardaki order by adi asc þuna yarýyor onu yazmazsak bilgi iþlem'deki erkek sayýsýný veriyor sonra diðer departmanýn Erkegýný veriyor sonra öteki departmanýn kadýnýný veriyor
     --sonra  tekrar bilgi iþlemin kadýnýný veriyor ama oder by adi asc yaparsak her departmanýn kadýnýný erkegýný yazýp sonra öteki departmana geçiyor çünkü isme göre sýralamýþ olduk
     -- aslýnda bu mantýken gruplamaya giriyor gibi geliyor ama bunu order by ile yaptýk bu önemli bunun için order by i silip  çýktýya bakabilirsin mevzuyu anlarsýn
     -- count(*) yapsak sadece bu bile yeterliydi ayrýca order by d.Adi,p.cinsiyet deseydik oda olurdu

     select p.* from personel p
     select d.* from Departmanlar d

     --- *********************yapay zeka cevabý ***************---
     SELECT
    -- Eðer Departmanlar.Adi NULL ise (yani DepKodu NULL olan personel için),
    -- oraya 'Departman Atanmamýþ' yaz, deðilse departman adýný yaz.
    ISNULL(d.Adi, 'Departman Atanmamýþ') AS DepartmanAdi,
    p.Cinsiyet,
    COUNT(*) AS PersonelSayisi
FROM
    dbo.Personel AS p
LEFT JOIN
    dbo.Departmanlar AS d ON p.DepKodu = d.Kodu
GROUP BY
    -- Gruplamayý da ayný ISNULL mantýðýyla yapýyoruz.
    ISNULL(d.Adi, 'Departman Atanmamýþ'),
    p.Cinsiyet
ORDER BY
    -- Sonuçlarý daha okunaklý olmasý için sýralayalým.
    DepartmanAdi,
    Cinsiyet;

    --S13: departman ve cinsiyetlerine göre maaþ toplamlarýný getiren sql *** önemli mantýk hatam varmýþ left join ve from ayrýmý çok önemli ----
    --not: farkettiysen order by kýsmýnda  [Departman Adý] yaptýk bu ince nüansý görmen lazým çünkü sütunumuzun takma ismi Departman Adý
    --order by ýn amacý dediðim gibi  eðer yapmazsak bilgi iþlem E diyor sonra Ýnsan kaynaklarý E diyor sonra kýzlara geçiyor onu engellemek

    select  isNull(d.Adi ,'Departman Atanmamýþ') as [Departman Adý] ,
    p.Cinsiyet,
    SUM(p.Maas) as [Maas Toplamlarý]
    from Departmanlar d left join Personel as p on p.DepKodu=d.Kodu group by isnull(d.Adi,'Departman Atanmamýþ'),p.Cinsiyet  order by [Departman Adý],p.Cinsiyet

    ---yukardaki kod tüm departmanlarý getir sonra personele göre ayarla mantýðýnda birþey bu yüzden  çýktý oluyor ama nulllar kaybolmuyor 
    -- mantýksal bir saçmalýk var personel listesi üzerinden bir gruplama yapmalýyýz daha doðru olur



    SELECT
    -- Departman adý yoksa 'Departman Atanmamýþ' yaz
    ISNULL(d.Adi, 'Departman Atanmamýþ') AS [Departman Adý],
    p.Cinsiyet,
    SUM(p.Maas) AS [Maas Toplamlarý]
FROM
    -- Ana tablo 'Personel' olmalý, 'Departmanlar' deðil.
    Personel AS p
LEFT JOIN
    Departmanlar AS d ON p.DepKodu = d.Kodu
GROUP BY
    -- Gruplama ifadesi ne ise...
    ISNULL(d.Adi, 'Departman Atanmamýþ'),
    p.Cinsiyet
ORDER BY
    -- Sýralama ifadesi de o olmalý (veya SELECT'teki takma adý)
    [Departman Adý],
    p.Cinsiyet;

    --s14: departman ve cinsiyetlerine göre personel sayýlarýný ve maas toplamlarýný getiren sql *** önemli bir mantýk anlayacaðýn soru***

    
    select  isnull(d.Adi,'Departman Adý Girilmemiþ'),
    p.Cinsiyet,
    COUNT(*),
    SUM(p.Maas) as MaasToplam
    from Personel p left join  Departmanlar as d on d.Kodu=p.DepKodu
    group by 
    ISNULL(d.Adi,'Departman Adý Girilmemiþ'),
    p.Cinsiyet
    order by
    ISNULL(d.Adi,'Departman Adý Girilmemiþ'),
    p.Cinsiyet

    --yukardan iki þey öðrendik selectte  ne yazdýysan gruplama ve order  by kýsmý onla  ayný olmalý mesela '' içinde yazan bile ayný olmalý
    --ama order by da takma adý varsa sadece onu yazsan yeter burda saçmalýk var gibi ama bunun sebebi sql in kodlarý calýstýrma sýrasýndan kaynaklanýyor
    -- yani sql order by kýsmýný en sona býrakýrken group by kýsmýný select leri oluþturmadan okuyor o yüzden aþaðýdaki saçmalýk oluyor
    --ayrýca  select'ten sonra isnull diyerek sütun içinde ayrý bir satýrda yaratmýþ oluyoruz  bu nüansýda yakalaman lazým sonraki [] genel sütun ismi
    

    select p.* from personel p

    select  isnull(d.Adi,'Departman Adý Girilmemiþ') as [Departman Adlarý], -- bu arada [] arasýna Departman Adý girilmemiþ yazarsan tüm sutun bunu yazar sacma olur
    p.Cinsiyet,
    COUNT(*) as personelSayýsý,
    SUM(p.Maas) as MaasToplam
    from Personel p left join  Departmanlar as d on d.Kodu=p.DepKodu
    group by 
    ISNULL(d.Adi,'Departman Adý Girilmemiþ'),  --- aslýnda burdada isnul olma sebebi sonuçta departman adý girilmeyenlerinde bi grubu olmalýki sayac onada calýssýnn
    p.Cinsiyet
    order by
    [Departman Adlarý],
    p.Cinsiyet
    
















