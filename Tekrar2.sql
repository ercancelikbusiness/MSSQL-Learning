
--S1: 4 veya daha fazla personele sahip olan departmanlarý getiren sql

select d.Adi, COUNT(*) as PersonelSAyisi  from personel p inner join Departmanlar as d on p.DepKodu=d.Kodu 
group by d.Adi having COUNT(*)>=4

-- inner join kullandýgýmýz için DepKodu null olanlar zaten birleþime girmedi
-- kýsaca selectten sonrakiler sadece gösterimdir.. having izin verdiði sürece çýkacaklardýr mesela selectten sonra count yapmasaydýk bile
--having ayný yazýlýrdý alttaki çözümde bunu anlayacaksýn yani önceliðini from'dan sonraki kýsýmlara ver herzaman 
-- yani fromdan sonraki kýsýmlarýn izin verdiklerini select ile yazdýrýyoruz iþleyiþ þöyle  fromdan sonra þu oluyor departmanlarý grupla
-- departmanýn ilk grubu örneðin  bilgi iþlemdeki satýrlarý say(çünkü * kullanmýþýz p.Id deseydik idleri sayardý) 4 veya daha fazlasý olursa
--filtreden geçer selectten sonra d.adi kýsmýnda bu filtreden geçenler yazacaktýr ardýndan count ise  havingde saymýþtý iþte onlarý yazdýrýr

--- ******************************** ÖNEMLÝ AYDINLANMA *********************************
-- ****** önceki scripte yazdýðým önemli bir mantýk hatamýz var oda þu: selectten sonraki count aslýnda bir önceki sütuna göre hareket etmiyormuþ
--yani group by ile gruplama yapýlmasýna göre sayma yapýyormuþ dolayýsýyla selectten sonraki sütunlarý bagýmsýz düþünmeliyiz. ! bunu anlamak için ;

--Senaryo: diyelimki     ** select p.Ad, COUNT(p.Adi)  from personel p group by p.Ad ** komutu girildi tablodada ali  isminde 3 veli isiminde 4 kiþi olsun
--  Group By  ile ali ismi tek bir grup olcak veli'de  bir grup olcak. selectten sonraki p.Ad, ali ve veliyi birkez yazacak ama yanýndaki count sütunu
--Alinin yanýna 3 veliye 4 yazacak ama bu saymayý ilk sütun p.Ad ' a göre deðil group by p.Ad  kodun'a göre yapýyor yani group by kýsmýný endeks alýp sayýyor
--yani selectten sonraki sütünlarý bagýmsýz düþün önceki scriptte(Takrar1'de) yanlýþ düþünüyormuþuz




--aþaðýdaki yapay zekanýn daha zayýf bir çözümü ama bunun üzerinden bilgiler vereceðim altýndaki notlarý oku
SELECT
    d.Adi
FROM
    Personel AS p
INNER JOIN
    Departmanlar AS d ON p.DepKodu = d.Kodu
GROUP BY
    d.Adi
HAVING
    COUNT(p.Id) >= 4;

    --farkettiysen having de id var ilk bakýþta mantýðý saçma gibi geliyor ama sql mantýgýný anlamamýz lazým
    --þimdi d.adi ile gruplama yapýlmýþ bu þu demek her bir departmaný ayrý ayrý kovalara ayýr having ile ise p yi saymýþýz
    --aklýna þu gelebilir gruplamayý departman ile yaptýk sayacý personelde yaptýk sistem nasýl gruplardaki id leri ayrý ayrý saymasý gerektiðini anlýyor?
    --burda kilit nokta þu biz join ile 2 tabloyu birleþtiriyoruz aslýnda depkodu ve id ler ayný satýrda  yani tek tablo oldugu için hepsi iç içe
    --dolayýsýyla sayma iþleminden öncede gruplama yapýldýðý için having her grubun id lerini sayýyor  selectte departman adý yazýcak
    --her departman adý yazýldýgýnda o departmandakilerin idleri sayýlýr dolayýsýyla 4 den fazla olanlarýnki gösterilir
    --ancak bu kodda personel sayýsýný yazdýrýcak sütun oluþmadýgý için sadece departman isimleri yazar



    --S2: Cinsiyeti Erkek olan personellerin departmanlara göre sayýlarýný getiren sql

    select d.Adi, COUNT(p.Cinsiyet) as ErkekSayýsý from   Personel p inner join Departmanlar as d on d.Kodu=p.DepKodu
    group by d.Adi, p.Cinsiyet having p.Cinsiyet='E'

    --yukardaki kod departmanlarý  ve cinsiyetleri kovalara ayýrýr yani gereksiz yere kadýnlarýda gruplar ardýndan sayým iþleminide yapar
    --en sonra having sebebiyle kadýnlarý atar  sonucta doðru cýktý verir herþey yolunda gibi ancak gereksiz yere iþlemler yapýlmýþ olur o yüzden 
    --where ile filtreleme yapýp sonra gruplayýp sonra saydýrmalýyýz aþaðýdaki kod daha iyidir.
    --önemli bilgi: yukardaki koddan group by kýsmýndaki p.Cinsiyeti silersek sorgu hata verir çünkü gruplama yapýlanlar arasýndan havingi kullanabiliriz
    --cinsiyeti gruplamazsak sql kafasý karýþýr ama farkettiysen aþaðýdaki kodda group by da cinsiyet olmasada  cinsiyet=E yapabildik bunun nedeni
    --zaten gruplamadan önce kadýnlarý where ile attýk ayrýca where kullanýnca zaten havinge gerek kalmaz cunku kadýnlarý atýnca geriye zaten sadece
    --erkekler kalýr kýsaca 'HAVÝNG' gruplama ve count gibi iþlemlerden sonra  çalýþan bir filtrelemedir o yüzden bu soruda having verimsiz olcaktýr
    --bu aþçýya birkaç çeþit yemek yaptýrýp sadece 1 ini yicez diyip diðerlerini çöpe atmaya benzer

    select d.Adi, COUNT(*)as ErkekSayisi  from Personel p  inner join Departmanlar as d on d.Kodu=p.DepKodu where p.Cinsiyet='E' group by d.Adi
    --sadece erkekleri getirirsek sonrada gruplarsak böylece gereksiz iþlemler yapýlmamýþ olur zaten sayýcý sadece erkek personelleri
    --sayacak çünkü her satýrdaki personel erkek olacak biz satýr sayýsýný alsak erkek sayýsýný almýþ gibi oluruz öyle düþün

    select p.* from Personel p
    select d.* from Departmanlar d

    --S3: cinsiyeti erkek olan personellerin departmanlarýna göre sayýlarýný getiren ve PerSayisi 3 ve daha fazla departmanlarýný   listeleyen sql

    select d.Adi, COUNT(*) as PersonelSayýsý from Personel as p inner join  Departmanlar as d on p.DepKodu=d.Kodu
    where p.Cinsiyet='E' group by d.Adi having COUNT(p.Cinsiyet)>2

    -- kod tamamen doðrudur önce inner join ile depkodu olmayanlar elendi where ile kadýnlar elendi ardýndan  departmanlarý   grupladý zaten sadece erkek
    --ler kaldý içinde ardýndan  cinsiyetlerini saydý sadece erkek oldugu için 2 satýrdan fazla olan departmana izin verdi
    --ardýndanda selectte  filtrelemelerden geçenler yazýlmaya baþlandý önce d.Adi ile bilgi iþlemi yazdý ve count ise filtrelemeden geçen hangisi
    --ise onu saydý yani  selectteki count d.Adi kýsmýnda yazaný deðil zaten  fromdan sonraki aþamada filtrelemeden geçeni saydý d.Adi ise filtrelemeden
    --geçen bilgi iþlem oldugu için onu yazdýrdý.

     select p.* from Personel p

     --s4: adýnda e veya h geçen personellerin departmanlara göre sayýlarýný getiren sql

     select d.Adi, COUNT(*) 
from Personel p  inner join Departmanlar as d on d.Kodu=p.DepKodu
group by d.Adi, p.Cinsiyet  
having p.Ad like '%e%' or p.Ad like '%h%'
-- having hatalýdýr aþaðýda nedeni yazdým


     select d.Adi, COUNT(*) as AdýndaEveHOlanlarýnSayisi from Personel p inner join Departmanlar as d on d.Kodu=p.DepKodu
    where p.Ad like '%e%' or p.Ad like '%h%' group by d.Adi

    --yukardaki kodda gruplamada cinsiyeti yazsak gereksiz yere ayný departmaný alt alta yazýp 2 deðer verecekti ama tek satýrda deðer verse yeterli
    /*Filtreleme, bir grubun hesaplanmýþ sonucuna (COUNT > 5 gibi) deðil de, satýrýn ham verisine (Ad sütununun içeriði gibi) yapýlýyorsa, 
    bu filtre HER ZAMAN WHERE ile yapýlýr. where gruplamadan önce iþleme girer*/

     select p.* from Personel p

     /* 4. soruda having calýsmama nedeni :
     Hata veriyor, çünkü GROUP BY komutu o kovadaki 5 farklý p.Ad deðerini TEK BÝR SATIRA ÇÖKERTÝR (COLLAPSE) ve HAVING bu tek satýra bakar.

SQL'in ne gördüðünü adým adým tekrar düþünelim:
JOIN yapýldý.
GROUP BY d.Adi çalýþtý.
SQL, 'Ýnsan Kaynaklarý' grubunu oluþturdu. Bu anda SQL için artýk 5 ayrý personel (Gülizar, Sevde, Hilal, Ebru, Orhan) yoktur. Sadece 
TEK BÝR SATIR vardýr: Adý 'Ýnsan Kaynaklarý' olan bir "Grup".
COUNT(*) bu grup için çalýþýr ve "5" deðerini hesaplar.
HAVING p.Ad like '%e%' komutu gelir.
SQL, o TEK "Ýnsan Kaynaklarý Grubu" satýrýna bakar ve sorar: "Senin p.Ad deðerin nedir?"
ÝÞTE HATA ANI: O tek temsili satýrýn p.Ad deðeri nedir? 'Gülizar' mý? 'Sevde' mi? 'Hilal' mi? 'Ebru' mu? 'Orhan' mý? Hiçbiri ve hepsi. Bu bir BELÝRSÝZLÝKTÝR.
    SQL'in HAVING komutu "grubun içine bakýp Sevde ve Hilal'i ayýklayayým" diye bir iþlem yapmaz. HAVING sadece o grubun temsili tek satýrýna 
    bakar ve o satýrýn p.Ad deðerini sorar. Tek bir deðer bulamadýðý için de size hata verir.
    ama whereli örnekde zaten  içinde sadece e ve h li olanlar grup olusturur dolayýsýyla geriye sadece satýr sayma kalýr
    
    peki diceksinki where dede çökertme oluyor orda nasýl sayým yaptý aslýnda orda olay where kýsmýnda zaten bitmiþ oluyor ardýndan sadece grup sayýsýný
    alsak bize yeterli yani gruplama sadece e ve h li olanlar üzerinden kuruldugu için o gruba ait kiþi sayýsý(satýr) bize yeterlidir zaten cevapta budur 
    ekstra iþlem yine yapýlamaz ama zaten yapýlmasýnada gerek kalmamýþtýr sonuç çýkmýþtýr bunun senaryo þeklinde  altta yazalým:
    
    Senaryo 1: HATA VEREN HAVING Sorgunuz

GROUP BY d.Adi: SQL 'Ýnsan Kaynaklarý' kovasýný alýr.

Kovaya Atýlanlar: 'Gülizar', 'Sevde', 'Hilal', 'Ebru', 'Orhan' (5 kiþi).

Çökertme: Kova kapanýr. Artýk o 5 kiþi görünmez. Kovanýn üstünde bir etiket vardýr: "Grup Adý: Ýnsan Kaynaklarý", "Ýçindeki Sayý: 5".

HAVING p.Ad LIKE '%e%': SQL gelir ve bu kapalý kovaya sorar: "Senin p.Ad deðerin nedir? 'e' içeriyor mu?"

HATA: Kova cevap veremez. Kovanýn tek bir p.Ad deðeri yoktur. Ýçinde 5 farklý deðer vardý ama artýk kapalý. Bu bir belirsizliktir.

Senaryo 2: DOÐRU ÇALIÞAN WHERE Sorgunuz

WHERE p.Ad LIKE '%e%' OR p.Ad LIKE '%h%': SQL daha kovalarý çýkarmadan, masadaki tüm personeli filtreler. 'Gülizar' ve 'Burak' gibi isimleri çöpe atar.

GROUP BY d.Adi: SQL 'Ýnsan Kaynaklarý' kovasýný alýr.

Kovaya Atýlanlar: Sadece WHERE filtresinden geçenler kovaya atýlýr: 'Sevde', 'Hilal', 'Ebru', 'Orhan' (4 kiþi).

Çökertme: Kova kapanýr. Artýk o 4 kiþi görünmez. Kovanýn üstünde bir etiket vardýr: "Grup Adý: Ýnsan Kaynaklarý", "Ýçindeki Sayý: 4".

SELECT d.Adi, COUNT(*): SQL gelir ve bu kapalý kovanýn etiketini okur:

d.Adi nedir? -> 'Ýnsan Kaynaklarý' (Belirsizlik yok).

COUNT(*) nedir? -> '4' (Belirsizlik yok).

BAÞARILI: Sonuç ekrana yazdýrýlýr.

Özetle: Her iki senaryoda da "çökertme" (gruplama) var.

Hata veren sorguda sorun, çökertme bittikten sonra o grubun içindeki ham bir detayý (p.Ad) sormaktýr.

Doðru sorguda sorun yok, çünkü çökertme bittikten sonra sadece grubun kendisiyle ilgili net bilgileri (d.Adi ve COUNT(*)) istiyorsunuz.
Filtrelemeyi (p.Ad) ise en baþta, çökertme baþlamadan WHERE ile hallettiniz.
*/

select  distinct p.Maas from Personel p -- distinct  birþeyden fazla varsa onu tek gösterime indirger 77k 2 adetse 1 kere belirtir.

--*****Sub query/Alt Sorgu  ( birden fazla select ifadesinin oldugu sorgulara alt sorgu denir***

--S1: Personel verilerini departman isimleri ile birlikte getiren SQL

select p.*, d.Adi from personel p  left join Departmanlar as d on d.Kodu=p.DepKodu -- bunla çözdük

-- aþaðýdaki sorgula ile çýktýlar nasýl oluyor anla yani bir sütun yazýnca tablodaki o sütuna ait hepsi geliyor
--tek bir satýrlý sütun için where ile yaptýk yani bu mantýðý  önce kafanda oturttur

select  d.Adi from personel p  left join Departmanlar as d on d.Kodu=p.DepKodu -- left ile alttaki farký anla

--sadece departman adlarýný getirmiyor sütun sadece d.Adi olabilir ayný zamanda tüm personel tablosunu getiriyor baðlantý üzerinden
--personelde kod  eþleþiyorsa departman ismini getiriyor null olanlarý null býrakýyor inner join olsa  nullar haric ayný tablo olurdu
select  d.Adi from personel p  inner join Departmanlar as d on d.Kodu=p.DepKodu

select d.Adi from Departmanlar d

select d.Adi  from Departmanlar d  where d.Kodu='D1'

--sub query ile çözüm

select p.* , (select d.Adi From Departmanlar d where d.Kodu=p.DepKodu)as depAdi   from Personel p -- subquery çözümð
select p.*, d.Adi as depAdi from personel p  left join Departmanlar as d on d.Kodu=p.DepKodu -- bizim çözümle kýyasla

--hiçbir fark yoktur subquery satýr satýr calýstýgý için  where d.Kodu=p.DepKodu þu þekilde sql tarafýndan okunur;
--from personel oldugu için ilk satýrý yazarken burak'ýn DepKodu D1 dir  yani  subquery de yani () içinde "where d.Kodu='D1'" olarak algýlayacaktýr buda departmanlar tablosunda bilgi iþlem demektir
--o halde subquery () parantez içinin çýktýsý direkt  bilgi iþlemi getircektir komple parantez içi o satýr için  bilgi iþlemi temsil eder
-- ve parantezden çýkýp yoluna devam edecektir sonra öteki satýr içinde ayný iþlemler tekrarlanacaktýr  kýsaca her satýrda ayný
--iþlemi yapacaktýr yani subquery ile  satýr satýr(row by row) iþlem yapmýþ olduk for döngüsü gibi düþün..  subquery içindeki
--p.DepKodu  her satýr için o satýrdaki personelin DepKodunu alýcaktýr d.Kodu'na atayacaktýr.
--yani burda where d.Kodu =p.DepKodu dememizin nedeni 2 tablo bu konuda uyumlu ama baþka birþeyde yapabilirdik
--d.Adý=p.Adý yapsaydýn sorgu saçma olurdu ama teoride calýsýrdý bilgiiþlem =burak sonraki satýrda özkan þeklinde giderdi anla diye söyledim

select d.* from Departmanlar d

select p.*, (select d.Adi from Departmanlar d where d.Kodu=p.DepKodu)as DepAdý from personel p


--S2: ilçe verilerini il isimleri ile birlikte getiren SQL
select  p.* from iller p
select d.* from ilceler d

select i.*, ( select iller.adi  from iller where iller.ilkodu=i.ilkodu  ) as ilIsýmlerý  from ilceler i

--tabloya bakýyorsun ortak sütun hangisi olabilir onu bulcan  kýsaca önce tablolar birbiriyle uyumlu olmalý zaten

select ilceler.Id,ilceler.ilkodu, (select iller.adi  from iller where iller.ilkodu=ilceler.ilkodu)as ilIsýmleri ,ilceler.adi  from ilceler 

--S3: En yüksek Maas verisine sahip olan personel/personelleri getiren SQL( ayný maaþa sahip birçok  insan olabilir top kullanýlmaz )

-- önce alttaki kodlarýn farklarýný anla  Ercan Diyince ercanla ilgili satýrýn  tüm sütunlarýný getiriyor 
select p.* from Personel p  where p.Ad = 'Ercan'
--alttakinde tüm satýrlarýn tüm sütunlarýný getiriyordu
select p.* from Personel p  

select p.* from Personel p  where p.Maas= (select  MAX(p.Maas) from Personel p)

-- mantýðý çok kolay anlýcaz þimdi  açýklýyorum : amacýmýz en yüksek maasý bulmak deðilmi sonucta 1 den fazla kiþide olsa
--en yüksek maas 1 tanedir.. e o halde en yüksek maasý bulan kodu elde edelimki sonra o maasa sahip olanlarý istiyebiliriz
-- () yani subquery içindeki kod bize en yüksek maaþý yazdýran koddur çýktýsý sadece en yüksek maasýn sayýsal deðeridir
-- o halde kodumuz þuanda þu hale geldi  select p.* from Personel p  where p.Maas= 231250
-- yukardaki 231250 þuanki en yüksek personelin maas deðeridir ilerde deðiþtirebiliriz ama þuan 231250 dir. gördüðün gibi
-- bize bu maasý alan personeli getir kodu mevcut oldu bu maasý birden fazla kiþi alsaydý p.* sayesinde hepsini yazdýracaktý ama tek kiþi
-- oda yiðit

select p.* from Personel p  where p.Maas= 77000.0000 -- mesela 770000 olan kýsým subquery nin nihai sonucu olsaydý  gördüðün gibi
--cýktý birden fazla kiþi oluyor


select p.* from Personel p  where p.Ad=(select  p.Ad from Personel p where p.Ad='Ercan')

-- yukarda abuk subuk bir örnek yazdým subquery olayýný anlamak için.
--subquery sonucu yani: select  p.Ad from Personel p where p.Ad='Ercan' bunun sonucu yine Ercan'dýr
--o halde ana sorgu select p.* from Personel p  where p.Ad='Ercan' gibi olacaktýr yani bize Ercanla ilgili olan tüm sütunlar gelir

--S4: departmanlarý personel sayýlarý ile  birlikte listeleyen sql ****** önemli bilgiler içerir *****

select d.* from Departmanlar d
select p.* from Personel p

--aþaðýda subquerysiz yazýlmýþ kod var ama önce þunu bilmeliyiz;

select p.* from personel p --  dediðimizde aslýnda sql bu tablonun tamamýný yazdýrýyor diye ezberledik ama aslýnda þöyle oluyor
                           -- tablonun aynýsý geliyor ama satýr satýr tüm sütunlar geliyor , aslýnda her sql  satýr satýr ilerler yani;
                           -- ilk baþta ilk personelin id si ismi soy ismi maasý vb ilk satýrý bitiriyor sonra öteki personele
                           --geçiyor. dolayýsýyla subquery yazarken her satýrda o kiþinin verilerini subquery içine atýyoruz onunla
                           --senkronize ilerliyor böyle düþününce mantýk oturuyor yani sadece subquery de satýr satýr gitmiyor. 
SELECT
    d.Adi AS DepartmanAdi,
    COUNT(p.Id) AS PersonelSayisi 
FROM
    Departmanlar AS d  -- 1. Ana tablo olarak Departmanlar'ý seç
LEFT JOIN
    Personel AS p ON d.Kodu = p.DepKodu -- 2. Personeli sola (Departmanlar'a) baðla
GROUP BY
    d.Adi

    -- yukarda olay þöyle oluyor, biz gruplama yaptýðýmýz için sayaç her grubu bir kez sayacak  ve her grup ismi bi kere yazdýrýlacak
    -- ve  sýrayla olacak ilk  departman bilgi iþlem bu yazcak zaten sayacda bunun içindeki p.id leri saymýþ olacak
    --yani aslýnda group by adi ile arka planda sanal bir ayrý tablo oluþuyor bu tabloda her bir kovanýn d.adi mevcut
    --dolayýsýyla her bir d.adi nin  id leri ayný kovada oluyor selectten sonraki d.adi ve count sadece bunlarý okumuþ oluyor
    -- kýsaca biz bunu en baþtan beri farklý yorumluyormuþuz yani d.Adi'na göre count sayýyor falan zannediyordu aslýnda öyle deðil
    --group by ile oluþan sanal tablo her bir d.Adi nin ayný gruplar olarak oluþturduðu için  ve selectler belli oldugu için
    --d.Adi = bilgi iþlem ise onun kovasý zaten hazýr  count id si zaten çokdan hesaplanmýþ oluyor sadece ekrana yazdýrmýþ oluyoruz


--þimdi  subquery ile yapacaðýz ve artýk sql in herþeyi p.* gibi ifadelerde dahil, tüm sql kodlarý satýr satýr
--ilerlediðini mantýgýmýza oturttuk

--aþaðýda birden fazla kod yazýcam aslýnda hepsi ayný þey mantýðý daha iyi anlarsýn

select d.*, (select COUNT(*) from Personel p where p.DepKodu=d.Kodu) as PerSayisi from Departmanlar d left join Personel p on p.DepKodu=d.Adi

select d.*, (select COUNT(*) from Personel p where p.DepKodu=d.Kodu) as PerSayisi from Departmanlar d 

select d.Adi, (select COUNT(p.Id) from Personel p  where p.DepKodu=d.Kodu) as PerSayisi from Departmanlar d

/*
birincisinde left join yazdýk ama gerek yok çünkü satýr satýr iþlem yaparken zaten birbiriyle iletiþimde olacak bu iki tablo,
bunuda subq içindeki where ile zaten saðlýyor dolayýsýyla left join inner join burda cok gereksiz olur
ayrýca ilk select d.* burda ilk departmanýn tüm sütunlarý geliyor ardýndan son sütunda subq var ve buda personele baðlanýyor
ortak sütun hangileriyse where ile bunlarý eþitliyoruz yani aslýnda bu baðlama gibi ama aslýnda baðlama deðil süreç þöyle oluyor=
d.* ile ilk departman  olan bilgi iþlemin tüm sütunlarý geliyor ardýndan  diðer sütun subq oldugu için ona geçtiðimizde
where içinde p.DepKodu = 'D1' oluyor çünkü d.* ile gelen ilk satýrýn d.Kodu = D1 idi dolayýsýyla where ile p.DepKodu= D1 olan
personeller geliyor ve count oldugu için hepsini sayýyor  4 kayýt oldugu için sayac 4 sonucunu veriyor yani gruplama bile yapmamýza
gerek kalmamýþ oldu. ardýndan  bu satýr bitiyor ve 2. satýra geçiyor  önce d.* calýsýyor Muhasebenin tüm sutunlarýný getiriyor.
ardýndan yine subq geçiyor ve orda where p.DepKodu=D2 oluyor  ve  p.DepKodu D2 olan herkesi sayýyor ekrana yazýyor bu þekilde
devam ediyor.
*/


--s5: ortalama maaþýn altýnda ücret alan personelleri getiren sql

/*
Bu, SQL'deki en klasik ve en güzel sorulardan biridir.

Sýrayla her iki yöntemi de inceleyelim:

1. Yöntem: Subquery'li Çözüm (Standart ve Doðru Yol)
Bu soruyu çözmek için bir alt sorgu (subquery) kullanmak en doðal, en okunabilir ve en standart yoldur.

Mantýk: SQL'de WHERE Maas < AVG(Maas) yazamazsýnýz, çünkü WHERE komutu satýr satýr çalýþýr ve o anda ortalamanýn kaç olduðunu bilemez.

Bu yüzden iki adýma ihtiyacýmýz var:

Önce ortalama maaþý bul.

Sonra her personelin maaþýný bu ortalama ile karþýlaþtýr.

dolayýsýyla subquerysiz bu soruyu çözemeyiz ancak TSQL kullanarak çözebiliriz onu en altta yapacaðým
subquerysiz çözememe nedenimiz hem whereden sonra hemde selectten sonra þu iþlemi direkt yazamýyoruz : (p.maas)<(SUM(p.Maas)/COUNT(p.Id))
yada (p.maas)<(AVG(p.Maas)) yani bunu tek satýrda bu þekilde yazmaya sql izin vermez çünkü.
ayrýca where den sonra AVG alma gibi bir iþlem yapýlamaz çünkü  where hazýr birþeyi getirmektedir.  basit matematiksel iþlem hariç
birþey yapamýyoruz ortalama alamaz çünkü ortalama için tek tek tüm maaslar hesaplanmalý where ise satýr satýr iþlem yapmaktadýr
*/





select  p.*  from personel p    where p.Maas< (Select SUM(p.Maas)/COUNT(p.Id)  from Personel p)

--burda iþlemi bölmüþ olduk whereye sadece satýr satýr kontrol etmek düþtü örneðin  getirmesi gereken maaþ ortlama maasýn altýndakiler
--dolayýsýyla her personelin maaþý ile ort maaþý kýyasla ve onu getirir veya getirmez p.* da satýr satýr çalýþcaktýr yani senkron
--bir þekilde her personel için kontrol ederek sýrayla gidecekler örneðin ercan çelik maasý ort maasýn altýnda ise where izin vercek
--p.* ise ercan celik in tüm sütunlarýný gösterecek sonra  sýradaki personele bakýlacak where filtresinden geçerse p.* sayesinde
--tüm sütunlarýyla beraber o personel yazdýrýlcak böyle böyle sýrayla gidilcek yani where 'de p.* da sonuçta ikiside satýr satýr ilerliyor




--TSQL çözümü
-- 1. Adým: Ortalamayý tutmak için bir deðiþken tanýmla
DECLARE @OrtalamaMaas DECIMAL(18, 2);

-- 2. Adým: Ortalamayý hesapla ve bu deðiþkene ata
SET @OrtalamaMaas = (SELECT AVG(Maas) FROM Personel);

-- 3. Adým: Deðiþkeni kullanarak "subquery'siz" ana sorguyu çalýþtýr
SELECT *
FROM Personel
WHERE Maas < @OrtalamaMaas;















    


    
