----Joins(inner Join, left join, Right Join, cross join, self join)

--S1: personel bilgilerini departman adlarý ile birlikte getiren SQL

select p.*, d.Adi  from Personel p inner join  Departmanlar d  on d.Kodu=p.DepKodu 




--burada group by d.Adi yapamayýz sebebi þudur biz ilk select ile p.* dedik yaný sýrayla tüm personel tablosunu yazacak
--dolayýsýyla kova  yani grup oluþturmak mantýk hatasý oluþturur çünkü personel tablosundan birden fazla ayný d.Adi illaki olacak
--eðer grup oluþturursan her departman adý  gruplara ayrýlýr ve her departman adý bir kez yazýlmalý olurdu ama burda onu yapmamalýyýz

select d.Adi  from Personel p inner join  Departmanlar d  on d.Kodu=p.DepKodu  group by d.Adi

--mesela burda vermedi kýsaca  sordugu soru komple listeleme ise niye gruplayalým ki ama spesifik soru olsaydý belki gerekirdi



--S2: bütün personel bilgilerini ve bunlarýn departman isimlerini getiren SQL

select p.*, d.Adi  from Personel p left join Departmanlar d on p.DepKodu=d.Kodu
--null olanlarda geliyor çünkü tüm personel demiþ

select p.*,d.Adi from  Departmanlar d left join Personel p on p.DepKodu=d.Kodu

-- **   join de sýralamada önemli fark****
/*
þimdi left join den sonra personeli yazarsak þöyle olur soldakine katýlan personel olur yani soldaki ana tablo departmandýr
fakat selectten sonra önce personel sonra departman yazdýgýmýz için gösterim olarak personeli önce gösterir sonra d.adi yazar
fakat yinede sola katýlan personel olacaðý için öncelik departmandýr yani departmanýn sýralamasýna göre süreci iþeyecek
biz selectte personelden sonra d.Adi yazdýðýmýz için en saðdaki d.Adý sütunu  departmana endeksli önce bilgi iþlem olanlarý
sonra  muhasebe insan üretim vb diye yani ana departman tablosundaki sýra neyse personel tablosunu ona göre endeksleyecek
çýktý mantýksýz olacak çünkü bizim departmanlar tablomuz personele edeksli olmaný cunku istenen personel tablosu üzerinde departmanlardýr
*/




--S3: Departman verilerini ve Bu departmanlara ait Eþleþen Personel verilerini getiren SQL (right join kullan)

--left ve right join  farký þudur a left join b ile b right join a ayný  þeydir yani biri sola   katýl diðeri saða katýl
--demektir sadece left join kullanýlmasý önerilmektedir. 


select p.*, d.Adi from Departmanlar d right join Personel p on d.Kodu=p.DepKodu

--yukardaki  aslýnda  2. sorunun ilk cevabý ile ayný tabloyu oluþturur


--S1: bütün illeri ve bu illere ait ilçe bilgilerinin tamamýný getiren SQL

select ic.* from ilceler ic
select i.* from iller i

select  i.*,ic.*  from iller i left join ilceler ic on ic.ilkodu=i.ilkodu -- gruplama yaparsak ayný ili birden fazla yazamazdý
--not: i.* diyince aslýnda satýr satýr ilerlediðini ve asýl anlamýnýn iller'a ait tüm sütunlarý getirdiðini unutma(ilkodu adi bolgeno)
-- bu * yazýnca sanki tüm tabloyu yazdýracak ama ozaman adananýn birden fazla ilcesini hangi araya sýgdýrýcak diye kaygýlanýyoruz
--bu kaygý saçma çünkü satýrýn tüm sütunlarýný ifade ediyor diðer satýra geçince diðer kodlarýmýza göre iþlem yapýcak
--yani adana yazcak  ve  iller tablosunda adanaya ait tüm sütunlarý yazdýrýcak olayý bu.. öteki satýrda left join
--e göre  adananýn daha fazla ilcesi varsa bir kez daha adana yazcak yine  tüm sütunlarý getiricek

--aþaðýda iller ve  kaç adet ilceye sahip olduklarýný gösteren sql
select i.adi,(select COUNT(ic.ilkodu) from ilceler ic where i.ilkodu=ic.ilkodu  group by ic.ilkodu) as ilceSayisi from iller i 

--S2: INNER JOÝN  yaparsak ilcesi olmayan illeri yazdýrmaz

select  i.*,ic.*  from iller i inner join ilceler ic on ic.ilkodu=i.ilkodu  -- ilcesi olmayan illeri yazmadý anlamsýz olur

select i.*,ic.*  from iller i, ilceler ic where i.ilkodu=ic.ilkodu -- yukardaki örnekle ayný anlama gelir ama demode bir yöntemdir

select  i.*,ic.*  from iller i cross join ilceler ic  -- tüm illeri tüm ilcelerle yazdýrýr örn adana - yenimahalle gibi anlamsýz ve
--çok büyük bir tablo çýkar

--drop table if exists Bolgeler  -- Bolgeler tablosu varsa sil demek idi

---*********** sürekli sql yaptýðýmýz için temel tablo yaratma ekleme güncelleme komutlarýný tekrar edelim *****---------
---*********** sürekli sql yaptýðýmýz için temel tablo yaratma ekleme güncelleme komutlarýný tekrar edelim *****---------
---*********** sürekli sql yaptýðýmýz için temel tablo yaratma ekleme güncelleme komutlarýný tekrar edelim *****---------
---*********** sürekli sql yaptýðýmýz için temel tablo yaratma ekleme güncelleme komutlarýný tekrar edelim *****---------

-- ÖNCE, baðlanacaðýmýz "Ana" tablonun var olduðunu varsayalým:
-- Departmanlar (Kodu VARCHAR(5) PRIMARY KEY, Adi VARCHAR(50))

-- ÞÝMDÝ, "Çocuk" tabloyu (Personel) yaratalým:

CREATE TABLE Personel (
    -- Sütun Adý   Veri Tipi     Kurallar
    PersonelID    INT           PRIMARY KEY IDENTITY(1,1),
    Ad            VARCHAR(50)   NOT NULL,
    Soyad         VARCHAR(50)   NOT NULL,
    Email         VARCHAR(100)  UNIQUE,
    Maas          DECIMAL(10, 2),
    IseGirisTarihi DATE         DEFAULT GETDATE(),
    /*DEFAULT GETDATE(): Eðer bu alaný INSERT sýrasýnda boþ býrakýrsan, varsayýlan olarak o anýn tarihini (GETDATE()) otomatik yaz.*/
    BagliDepKodu  VARCHAR(5)    NULL,     ---- Baðlantý için "Yabancý Anahtar" sütunu

    -- Ýki tabloyu birbirine baðlayan kural (FOREIGN KEY)
    FOREIGN KEY (BagliDepKodu) REFERENCES Departmanlar(Kodu) -- Departmanlar tablosu'nda BagliDepKodu sütunu oldugðunu düþün
);

-- 'Bilgi Ýþlem' (D1) departmanýna bir personel ekleyelim
INSERT INTO Personel (Ad, Soyad, Email, Maas, BagliDepKodu)
VALUES ('Ali', 'Yýlmaz', 'ali.yilmaz@sirket.com', 75000.00, 'D1');

-- 'Muhasebe' (D2) departmanýna bir personel daha ekleyelim
INSERT INTO Personel (Ad, Soyad, Email, Maas, BagliDepKodu)
VALUES ('Veli', 'Kaya', 'veli.kaya@sirket.com', 68000.00, 'D2');

-- Departmaný olmayan (NULL) bir stajyer ekleyelim
INSERT INTO Personel (Ad, Soyad, Email, BagliDepKodu)
VALUES ('Zeynep', 'Demir', 'zeynep.demir@sirket.com', NULL);

--Dikkat: PersonelID ve IseGirisTarihi yazmadýk, çünkü onlar IDENTITY ve DEFAULT olarak otomatik ayarlanmýþtý.

-- veri güncelleme--

/*DÝKKAT! DÝKKAT! DÝKKAT! Eðer UPDATE komutunda WHERE satýrýný yazmayý unutursanýz, SQL o sütundaki TÜM SATIRLARI deðiþtirir. 
Bu, bir þirketin veritabanýnda yapabileceðiniz en büyük hatalardan biridir.*/


-- Senaryo 1: Ali Yýlmaz'ýn (ID'si 1) maaþýna zam yapalým.
UPDATE Personel
SET Maas = 80000.00
WHERE PersonelID = 1; -- Sadece ID'si 1 olaný deðiþtirir.

-- Senaryo 2: Zeynep Demir'i (ID'si 3) 'Ýnsan Kaynaklarý' (D3) departmanýna atayalým.
UPDATE Personel
SET BagliDepKodu = 'D3'
WHERE PersonelID = 3;

-- KORKUNÇ HATA ÖRNEÐÝ (ASLA YAPMA):
UPDATE Personel
SET Maas = 10000; -- WHERE yok. Þirketteki HERKESÝN maaþý 10000 oldu.

-- aþaðýdaki gibi sonradan ekleme hatta ekledðimiz  nesneyi diðer tabloyla iliþkilendirm yapabiliriz

alter table Personel
Add DepKodu varchar(10)

alter table Personel
add constraint FK_personel_Departmanlar
foreign key (DepKodu) references departmanlar(Kodu)

-- aþaðýda illerdeki BolgeNo varsa silmeyi ve bunu Bolgelerdeki BolgeNo ile baðlama iþlemini görcez (ilk yapýlan BolgeNo baðlý deðilse)
alter table iller drop column BolgeNo

 alter table iller  
 add BolgeNo tinyint references Bolgeler(BolgeNo) -- iller'dekinin adý Bolge olabilirdi
 --yani illaki reference alýnan ile ayný isimde olmasýna gerek yok þöylede olabilirdi:
 --alter table iller  add Bolge tinyint references Bolgeler(BolgeNo)
 --not: ayrýca bolgelerdeki bolgeno ile illerdeki bolge arasý þöyle bir uyumsuzluk olamaz illerdekine 10 yazdýk ama bolgeler
 --tablosundaki bolgeno 10 a karþýlýk yok ise hata verir
 ON update  Cascade 
 on delete Set NULL

 --on update cascade: eðer bolgelerdeki BolgeNo'su 1 olan Marmaranýn BolgeNo sunu  101 yaparsak iller tablosunda 1 olanlarýn hepsi 101 olur
 --on delete set null: eðer Bolgelerdeki BolgeNo 7 yi silersen illerde 7 olanlarý silme!. hepsini null yap demektir
 --on delete set delete deseydik illerdeki iller komple silinirdi




--*************case when konusu***************-------

select b.*  from Bolgeler b
select i.* from iller i

update iller set BolgeNo=1 where adi in('Bursa','Ýstanbul','Çanakkale')
-- bu þekilde set BolgeNo=2 where adi..... þekilde tek tek ayrý ayrý yapmakdansa  case when ile daha seri yapabiliriz

update iller set BolgeNo=case when adi in ('Adana','Antalya') then 3
                              When Adi In('Ankara') then 4
                              When Adi In('Afyonkarahisar','Ýzmir') then 2
                              when ilkodu in('05','69')then 5   -- isim yerine ilkodu üzerinden atama yapýlabilir (amasya bayburt)
                              When ilkodu IN ('25', '04')then 6 -- Erzurum, Aðrý
                              When ilkodu IN ('16', '34')then 1 -- Bursa, Ýstanbul (Çanakkale listede yok)
    ELSE 7 -- Geriye kalanlar (listede olmayan Adýyaman vb.)
END;


--soru: buutun bolgeleri ve bu bolgelere ait illeri ve bu illere ait ilçeleri  BolgeNo iladi ilçe adlarýna göre sýralý olarak getiren sql
--soru: buutun bolgeleri ve bu bolgelere ait illeri ve bu illere ait ilçeleri  BolgeNo iladi ilçe adlarýna göre sýralý olarak getiren sql
--soru: buutun bolgeleri ve bu bolgelere ait illeri ve bu illere ait ilçeleri  BolgeNo iladi ilçe adlarýna göre sýralý olarak getiren sql

select ic.* from ilceler ic

select b.*,i.*,ic.* from Bolgeler b  left join iller i on b.BolgeNo=i.BolgeNo 
left join ilceler ic on ic.ilkodu=i.ilkodu

--******** 2 adet left join kullandýk ama kullanýmý iyi anla sola baðlanan ilk olarak iller idi onu bolgeler ile iliþkilendirdik
--ardýndan solda kalan iller oldugu için ilceleri iller ile iliþkilendiririz.

-- ilceler tablosunda id gereksiz gibi mesela ic.* yerine  ic.ilkodu,ic.adi yapabilirdik
--ayrýca orderby b.bolgeno i.adi, ic.adi yapmaya gerek yok çünkü zaten default olarak hepsini büyükten kücuge sýralýcak

--select Into(veri/tablo yedekleme)
--select Into(veri/tablo yedekleme)
--select Into(veri/tablo yedekleme)
--select Into(veri/tablo yedekleme)
--select Into(veri/tablo yedekleme)



/*
select * into illerYedek from iller

select * into ilcelerYedek from ilceler
*/



/*
Bu, SQL'de en sýk kullanýlan ve en faydalý "hýzlý yedekleme" komutlarýndan biridir.

Kýsaca ne yaptýðýný açýklayayým:

 Bu Komutun Yaptýðý Ýþ (Tam Olarak)
select * into illerYedek from iller komutu, veritabanýna þu emri verir:

from iller : iller tablosuna git.

select * : Oradaki tüm sütunlarý ve tüm satýrlarý (verinin tamamýný) al.

into illerYedek : Aldýðýn bu verilerle ve bu sütun yapýsýyla illerYedek adýnda YENÝ BÝR TABLO YARAT ve tüm veriyi bu yeni tablonun
içine kopyala.

Kýsacasý bu, iller tablonuzun anlýk bir kopyasýný (klonunu) oluþturur.

 Nasýl Kullanýlýr? (Kullaným Alanlarý)
Bu komutu genellikle "güvenlik" amacýyla kullanýrýz.

En Yaygýn Kullaným Alaný: Tehlikeli bir UPDATE veya DELETE iþlemi yapmadan hemen önce:

Diyelim ki iller tablosunda BolgeNo'su NULL olan herkesi sileceksiniz. Bu riskli bir iþlemdir.

Önce yedeðinizi alýrsýnýz: select * into illerYedek from iller; (Artýk iller tablosunun baþýna bir þey gelse bile verileriniz 
illerYedek'te güvende.)

Sonra riskli silme iþlemini yaparsýnýz: DELETE FROM iller WHERE BolgeNo IS NULL;

Eðer bir hata yaparsanýz ve sildiðiniz verileri geri isterseniz, illerYedek tablosundan geri yükleyebilirsiniz.

Diðer Kullaným Alanlarý:

Orijinal veriyi bozmadan denemeler yapmak istediðiniz bir "oyun alaný" (playground) tablosu oluþturmak.

Bir tablonun verisini baþka bir veritabanýna taþýmak için hýzlýca kopyasýný oluþturmak.

 Çok Önemli Kurallar ve Uyarýlar
Tablo Var Olmamalý: Bu komutun çalýþmasý için illerYedek adýnda bir tablonun veritabanýnda daha önceden var olmamasý gerekir.
Eðer illerYedek tablosu zaten varsa, komut hata verir ("Object already exists").

Kurallarý Kopyalamaz! (En Önemli Uyarý): Bu komut, iller tablosunun "kurallarýný" kopyalamaz.

Kopyaladýklarý: Sütun adlarý (ilkodu, adi), veri tipleri (varchar, int) ve verinin kendisi.

KopyalaMADIKLarý: PRIMARY KEY (Birincil Anahtar), FOREIGN KEY (Yabancý Anahtar/Ýliþkiler), INDEX (Ýndeksler), 
DEFAULT (Varsayýlan Deðerler) veya IDENTITY (Otomatik Artýþ) gibi kurallarý taþýmaz.

Yani illerYedek tablosu, iller tablosunun "kuralsýz", "sadece veri içeren" ham bir kopyasý olur.
*/


--soru:
--Ankara ilçelerinden isminde a geçen verileri silen sql(sub query)
--Ankara ilçelerinden isminde a geçen verileri silen sql(sub query)
--Ankara ilçelerinden isminde a geçen verileri silen sql(sub query)
--Ankara ilçelerinden isminde a geçen verileri silen sql(sub query)


-- önce çaðýralým

select i.* from iller i
select ic.* from ilceler ic

select ic.* from ilceler ic where ic.ilkodu=(select i.ilkodu  from iller i where i.adi='Ankara' )
and ic.adi like '%a%'

--yukardaki önemli bir anlama aydýnlanma  yaþatmaný bir sorgu. biz bu sorguyu calýstýrýnca aslýnda alttakine dönüþüyor ama
-- aklýmýza  þu takýlabilir: sql kodu birkez calýstýrýnca ilk satýr yazdýkdan sonra diðer satýrlarýn hepsinde subquery tekrarmý calýsýcak
--bu sorunun altýnda þu yatýyor sql her sorguyu her satýrda tekrar bakýp calýstýrýyor mu bu kurulan  subq sorgusuna göre deðiþir
--burdaki örnekte sadece birkez calýsýr çünkü 06 döner ve where ic.ilkodu=06 demek gibi calýsýr ama bazý sql sorgularý satýr baðýmlýdýr
--bunlar satýr satýr iþlenirken satýra özgü sonuc üretecektir

select ic.* from ilceler ic where ic.ilkodu='06'
and ic.adi like '%a%'

-- NOT: DELETE UPDATE gibi kullanýmlarda kýsaltma kullanýlmasýna çok gerek yok hatta derleyici  bulmaz zaten


--delete from ilceler  where  ilceler.ilkodu=(select i.ilkodu from iller i where i.adi='Ankara') and ilceler.adi like '%a%'
--not: ilceler.ilkodu dememize bile gerek yoktur direkt  where ilkodu=(subq) þeklinde yaparýz




-- SORU: plaka kodu  05 den büyük olan ve hiçbir ilçesi olmayan illeri silen sql(in/exists ile yaz)
-- SORU: plaka kodu  05 den büyük olan ve hiçbir ilçesi olmayan illeri silen sql(in/exists ile yaz)
-- SORU: plaka kodu  05 den büyük olan ve hiçbir ilçesi olmayan illeri silen sql(in/exists ile yaz)
-- SORU: plaka kodu  05 den büyük olan ve hiçbir ilçesi olmayan illeri silen sql(in/exists ile yaz)

select i.adi from iller i where i.ilkodu >'05' and  i.ilkodu=(select i.ilkodu from ilceler ic where  ic.ilkodu=i.ilkodu)

 

















