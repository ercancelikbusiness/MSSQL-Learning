--Transact SQL
--deðiþken tanýmlama 

--burda yapýlanlar  önce declare kýsmýyla seçilip yapýlmalýdýr tek baþlarýna çalýþmýyor...

declare @personelsayisi int , @toplamMaas float

set @personelsayisi=10
set @toplamMaas=225000.68


--select @personelsayisi as Psayisi, @toplamMaas as TMaas  -- bu kýsmý sadece seçip calýstýramayýz komple declareden itibaren seç calýstýr(Toplu)

--print 'Merhaba T-SQL'

--print 'personel sayýsý: ' +@personelSayisi  -- hata verir

--yukarda hata vermesinin nedeni  ilk yazýlan metin 2. si sayý bu ikisini toplamaya calýsýr metni sayýya çevirmeye calýsýr
--sql e  bizim bunlarý toplama  sadece metin birleþtirme yap dememiz lazým

--print 'personel Sayisi:'+ convert(varchar(10),@personelsayisi)
--yada
--print 'personel SAyisi:' + cast(@personelsayisi as varchar(10)) -- varcharlardan sonra parantezle sayý belirtmesekde olur 
--ama  cast kullanýyorsak  varchardan önce as kullanmalýyýz convertte ise direkt (varchar , @...) yapýlabilir
--****** ayrýca @ li deðiþkenlerdeki büyük küçük harf birebir olmasýna gerek yok @PersonelSayisi yazarsan yinede oluyor

--print 'Personel Sayisi::::' + convert(varchar,@personelsayisi)
--print 'Personel Sayisi::::' + cast(@personelsayisi as varchar)

--print 'Personel Sayisi::::' + cast(@personelsayisi as varchar)+' toplaMMaas:::'+cast(@toplammaas as varchar)

--print @personelSayisi  -- bu þekilde düz yazýlabilir  

set @personelsayisi =(select count(*) from BikeStoresTekrar.sales.staffs) -- burdaki dbo deðil
set @toplamMaas=(select sum(Personel.Maas) from BeltekTekrarDB.dbo.Personel) 

--not: sum(personel.maas)  yerine (maas) yazýlabilirdi bu arada personel tablonun ismi kýsaltma gibi kullanýldý çünkü tablonun ismi bu

print 'ToplamMaas: '+ cast(@toplammaas as varchar) 
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------


--case when kullanýmý

--1. yöntem

--soru: personellerin departmanlarýna gore zamlý maas hesabýný yapan ve ekrana listeleyen sql

-- bilgi iþlem %40 // D1 miþ   select * from Departmanlar
--insan kaynaklarý %20 d3
--muhasebe %25  D2
--üretim %35 d4
--diðer %15

--not: öncelikle tekrar 3 notumuzdada case when kullanmýþtuk orada esnek yapýyý kullandýk burda ise basit case yapýsý kullanýcaz
--soruyu çözdükten sonra farký açýklayacaðým

select
p.*,
case p.DepKodu when 'D1' then 40
               when 'D2' then 20
               when 'D3' then 35
               else 15  
               end as ZamOraný, -- farkettiysen whenlerden sonra , yok ama case kýsmýný yazarken önceden virgül koyarak yaz hata vermesin
case p.DepKodu when 'D1' then p.Maas+p.Maas*40/100
               when 'D2' then p.Maas+p.Maas*20/100
               when 'D3' then p.Maas+p.Maas*35/100
               else p.Maas+p.Maas*15/100
               end as ZamlýMaas
from personel p 

--burda basit when case kullandýk  depkodu  ne ise ona göre zam oraný sütunlarýný ayarladýk sonra maaslarýna zam uyguladýk
--yani D1  olanlara 40 yazdý ve D1 olanlarýn maaslarýna zam uyguladý ve ayrý sütunda gösterdi
--tekrar 3 de yaptýðýmýz ise esnek when case idi onunda kýsa örneðini gösterelim

/*
update iller set BolgeNo=case when adi in ('Adana','Antalya') then 3
                              when ilkodu in('05','69')then 5   
                              When ilkodu IN ('25', '04')then 6 
                              When ilkodu IN ('16', '34')then 1 
    ELSE 7 -- Geriye kalanlar (listede olmayan Adýyaman vb.)
END;
-- burda  BolgeNo kýsmýný düzenlicez dedik ve içinde adi þu olanlarý 3 veya ilkodu þu olanlarýn BolgeNo sunu 6 yap gibi uyguladýk
--esnek dememizin nedeni farkettiysen adi veya ilkodu kullanabildik ve in operatörü mevcut idi ama illaki in olmasýna gerek yok
--+ - = falanda olabilirdi altta farkký case when kullanýmlarý mevcuttur esnek ve basit halleri  kullanýma göre deðiþiyor
*/


-- soruyu subq kullanarak yapalým
-- soruyu subq kullanarak yapalým
-- soruyu subq kullanarak yapalým

select p.*,
case p.DepKodu when (select d.Kodu from Departmanlar d where d.Adi='Bilgi iþlem') Then p.Maas *1.4 -- maas +(maas*40/100)
               when (select d.Kodu from Departmanlar d where d.Adi='Muhasebe') then Maas+(Maas*25/100)
               when (select d.Kodu from Departmanlar d where d.Adi='Ýnsan Kaynaklarý') then p.Maas *1.2
               when (select d.Kodu from Departmanlar d where d.Adi='Üretim%') then p.Maas+(p.Maas*35/100)
               else p.Maas+(p.Maas *15/100)
end as ZamliMaas
from  Personel p


--soru: personellerin cinsiyet ve  departmanlarýna gore zamlý maas hesabýný yapan ve ekrana listeleyen sql

-- bilgi iþlem E:%40 K:%30 // D1 miþ   select * from Departmanlar
--insan kaynaklarý E%20 K%25 d3
--diðer %15

select
p.*,
case when p.DepKodu = 'D1' and p.Cinsiyet='K' then 30
     when p.DepKodu = 'D1' and p.Cinsiyet='E' then 40
     when p.DepKodu = 'D3' and p.Cinsiyet='K' then 25
     when p.DepKodu = 'D3' and p.Cinsiyet='E' then 20
     else 15
     end as ZamOraný,
case when p.DepKodu = 'D1' and p.Cinsiyet='K' then p.Maas+p.Maas*30/100
     when p.DepKodu = 'D1' and p.Cinsiyet='E' then p.Maas+p.Maas*40/100
     when p.DepKodu = 'D3' and p.Cinsiyet='K' then p.Maas+p.Maas*25/100
     when p.DepKodu = 'D3' and p.Cinsiyet='E' then p.Maas+p.Maas*20/100
     else p.Maas+p.Maas*15/100
     end as ZamlýMaas
from personel p
--not: illeri bölgelere yerleþtirirken case whenden önce BolgeNo demiþtik yukardan onun farkýna bak ve in kullandýk
--yani orda bir deðiþken içine atama yaptýk burda sadece gösterim þeklinde kullandýk

---------------------******************** view konusu ******************----------------
---------------------******************** view konusu ******************----------------
---------------------******************** view konusu ******************----------------
--view(görünüm) 1 veya 1 den fazla tabloda sadece select komutu kullanýlarak elde edilen veri çýktýlarýdýr
-- çok sýk baþvurulan sql sorgu sonuclarýný bir gorunumde saklamak için kullanýlýr veri giriþ  çýkýþ 
--ve güncellemenin sýk oldugu tablolarda tercih edilmez
-- view nesnelerine eriþim/kullaným týpký tablolar gibidir
--soru: tüm bölgeleri illeri ve ilçe bilgileri ile birlikte getiren sql




select b.* from Bolgeler b
select i.* from iller i
select ic.* from ilceler ic

create view vTurkiye
as
select 
b.BolgeNo,
i.adi,
i.ilkodu,
ic.adi as ilceadi,  -- ilceler ve iller tablosunda ayný olan sütun isimlerine mecburen takma ad vermeliyiz yoksa hata verirdi
ic.ilkodu as ilcekodu
from Bolgeler b
left join
iller i on i.BolgeNo=b.BolgeNo  -- tablonun satýr satýr akacaðýný düþün ve  önce ana tablo "b ye deðer gelecek" i ona göre þekil alacak i.BolgeNo=1 gibi.
left join
ilceler ic on ic.ilkodu=i.ilkodu

select v.* from vTurkiye v
