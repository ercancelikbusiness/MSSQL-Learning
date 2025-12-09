
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

    select * from personel

    select  p.DepKodu, count(*) from Personel p where p.Cinsiyet='E'  group by p.Cinsiyet, p.DepKodu


    select  d.Adi, count(*) from Personel p inner join Departmanlar as d on d.Kodu=p.DepKodu
    where p.Cinsiyet='E'  group by d.Adi 



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

-- ÖZEL ÇÖZÜMLER:--------------------------------
--tabloyu farklý bir tabloya kopyalama yapalým:

select   p.Maas as MaxMaas into #MaxMaas  from Personel p order by p.Maas desc  -- #MaxxMaas tablosuna MaxMaas takma adýyla  verileri attýk 

select p.*  from Personel p  where p.Maas = (select  max(MaxMaas) from #MaxMaas ) -- tablodaki max maasý seçtik

--alternatif çözüm:

select p.*  from Personel p  where p.Maas=(select top 1 p.Maas from Personel p order by p.Maas desc)

---------------------- ÖZEL ÇÖzümler yukardaydý ------------------------------------------

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





select  p.*  from personel p    where p.Maas< (Select SUM(p.Maas)/COUNT(p.Id)  from Personel p) -- subq yapmasaydýn whereyi böyle yapamazdýn
-- yani where <  SUM(p.Maas)/COUNT(p.Id)  yapýlamaz  < den sonra  tek bir deðer yazmalýyýz gibi düþün

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


--S6 illeri ilçe sayýlarý ile birlikte getiren sql

select i.* from iller i
select ic.* from ilceler ic




select i.*,(select COUNT(*) from ilceler ic where ic.ilkodu = i.ilkodu) as ilceSayisi  from iller i

--s7 bütün departmanlarý personel sayýlarý ile birlikte getiren sql

select d.* from Departmanlar d

select d.* ,(select COUNT(p.Id) from Personel p where p.DepKodu = d.Kodu) as PerSayisi from Departmanlar d

--yukardaki kodu türkçeye çeviriyorum:   d.* ile sýrayla tüm departmanlarýn sütunlarýný satýr satýr (sýrayla) olacak þekilde ekrana
--yazdýracak ancak her satýrda subq de çalýþacak ilk satýrda bilgi iþlem  tüm sütunlarýyla yansýr  ve d.* dan sonra subq oldugu için
--en sonda bir sütun daha vardýr(PerSayisi) iþte bu sütunda where p.DepKodu = D1  uygulanýr çünkü d.* ýn ilk satýrý bilgi iþlem idi onunda d.Kodu D1
--oldugu için where p.Depkodu = D1 buda D1 olanlarý getir demektir count personel tablosunda  D1 olanlarý sayar ve bir sonuc döndürür bu 4 dür sonra 
--ilk satýr tamamen bitmiþtir sonra  d.* tüm tabloyu satýr satýr yazdýrýyor demiþtik yani 2. satýra muhasebeye geçeriz ayný iþlemler onun
--içinde gerçekleþecektir böyle sýrayla gider. burda ince nüans sum count gibi  fonksiyonklar tablonun geneline bakýp bir sonuç döndürebiliyor
--ama onun haricinde satýr satýr ilerlenmektedir.


--S8: Departmanlarýn tüm bilgilerini personel maas toplamlarý ile birlikte getiren sql

select d.* ,(select SUM(p.Maas) from Personel p where p.DepKodu =d.Kodu) as TumCalýsanlarýnMaasToplamý from Departmanlar d

/* yukardaki kodun türkçesi sýrayla tüm departmanlarý p.* ile satýr satýr yazdýrýcak her satýrda o departmanýn kodu deðiþeceði için
subq daki d.Kodu güncellenecek p.DepKodu da o koda göre iþlem yapcak buraya kadar artýk ezberledik zaten þimdi sonra olan þu:
depkodu d1 olan birden fazla personel oldugu için sum ibaresi hepsini toplucak ve ilk satýr iþlemi tamamlanacak bilgi iþlem yanýna
toplam ile personelleri maasý yazcak sýrayla tüm departmanlarda uygulanacak null olanlarý null olarak yazacak ancak bunu tekrar1 deki
isnull fonksiyonuyla sýfýrda yapabiliriz*/

--d.* yerine  istediðimiz sütunlarýda alabilirdik ayrýca isnull ile yaptým nullarý sýfýr yansýtýcak

select d.Kodu,d.Adi ,isnull((select SUM(p.Maas) from Personel p where p.DepKodu =d.Kodu),0) as TumCalýsanlarýnMaasToplamý from Departmanlar d




--S9  departmanlarý toplam personel sayýsý ve toplam maas deðerleri ile birlikte getiren sql

select
d.*,
(select COUNT(p.Id) from Personel p where p.DepKodu=d.Kodu)as PerSayisi,
(SElect sum(p.Maas) from personel p where p.DepKodu=d.Kodu)as MaasToplam
from Departmanlar d

--s10 ilçe isminde A Harfi geçen illere ait ilçe sayýlarýný getiren sql

select ic.* from ilceler ic

select i.adi , COUNT(ic.adi) from iller i left join ilceler ic on i.ilkodu=ic.ilkodu  where  ic.adi like '%a%' group by i.adi

--yukarda left join ile yaptým ancak  inner join gibi yani  adýnda a bulunan ilçeleri olanlarý yazdýrýr çünkü where komutu joinden
--hemen sonra calýsacak ve filtreleme yapýcak bu yüzden left join anlamsýz hale gelir aþaðýdaki gibi direkt join  iþlemine koþul ekle
--çünkü where  þartý saðlamayaný çöpe atar ancak join iþlemleri  þart saðlanmazsa null yazar  ama yinede tabloda gösterir çünkü
--soldaki iller tablosunun yapýsýný korumak zorundayým der ve herþeyi gösterir iþte where ile join farký budur burda ekstradan
--join iþlemindede filtreleme vb yapýlabildiðini gördük  birden fazla yapýlacak filtrelemeler and veya or gibi operatorlerle saðlanýr
--bu wheredede böyledir joindede böyledir. ama herþeyin yazdýrýlmasýný istiyorsan where kullanma ancak subq ile aþaðýda bir örnek
--yapcam orda where kullanýldýgý halde left join gibi herþeyi yazdýrýcak  bunu onun altýna yazýcam

SELECT
    i.adi,
    COUNT(ic.adi) AS IlceSayisi -- Sadece eþleþen ilçelerin 'adi' sütununu say
FROM
    iller i
LEFT JOIN
    ilceler ic ON i.ilkodu = ic.ilkodu AND ic.adi LIKE '%a%' -- Filtre JOIN'in parçasý olmalý
GROUP BY
    i.adi;



select i.adi , (select COUNT(*)  from ilceler ic where ic.ilkodu=i.ilkodu AND ic.adi like '%a%')AS IlceSayisi from iller i
--yukardaki kod ayný left join gibi  herþeyi gösterecektir çünkü satýr satýr devam ediyor yani bu left joinli örneðimizle ayný çýktý verir
-- ilk left joinli örnekte where kullanmak hata demiþtik ama burda kullandýk  çünkü  bu þundan kaynaklanýyor. where komutu subq içinde
--yani iller zaten sýrayla hepsi caðýrýlýcak onu engelleyecek bir koþul yok sadece  diðer sütunda where var ve oda gelen verileri
--deðerlendiricek. eðer a yoksa sayac onu 0 sayýcak dolayýsýyla il hertürlü geleceði için yan sütuna 0 yazýp geçicek ama hertürlü
--gösterilecek



--S11  Ankara adana bayburt malatya illerine ait ilçe isminde A harfi geçen illere ait ilçe sayýlarý toplamýný getiren sql

select i.adi,(select COUNT(*) from ilceler ic where ic.ilkodu=i.ilkodu and ic.adi like '%a%')  from iller i 
where i.adi='Ankara'or i.adi='Adana'or i.adi='Bayburt'or i.adi='Malatya'

-- yada bu formatta olur::: where i.adi in ('Ankara','Adana','Bayburt','Malatya')

--yukardan anlayacaðýn üzere bir mantýðý daha oturttuk. where den sonra i.adi dedik selectte tekrar i.adi dedik saçma gibi geldi
--ama burda nüans þu mesela selecetten sonra i.* deseydik
--where ile i.adý koþullarýna uyanlar    bu 4  il isimlerine ait olan tüm sütunlar gelirdi çünkü from iller diyoruz
--ayrýca bu illere ait tüm veriler i.* demesek bile   örneðin il kodu vb saklanmýþ olacaktýr sadece selectteki yazana göre o veriyi getiricek
--ama hafýzada tüm verilerini tutucak , bunun kanýtý subq deki  where eþitliðinden anlýyoruz zaten  
--yani  select ile i.adi dememiz sadece adýný göstersede
--where de yaptýklarýmýz bu 4 ilin tüm sütun verilerinin tutuldugunu  gösterir çünkü from iller ibaresi hepsini tutacaktýr
--yani bu nüansý  unutma yani selectten sonra sadece i.adi yazdýk wheredede i.adi diyip sadece il isimleri yazdýk diye düþünme
-- son olarak subq içinde sayac  gruplama yapmadan nasýl sayýyor diye kafan karýþmasýn subq de where ilkodu=ilkodu ile zaten 
--atýyorum 01 ilinin tüm verilerini getirtiyoruz ('Ankara' satýrý için çalýþýr, Ankara'nýn 'a' içeren ilçe sayýsýný bulur (örn: 12). sonra adana için falan)
--ve ilcesinde a geçenlerin hepsini sayýyoruz yani tüm iþlem zaten tek satýrda o il için
--bitiyor dolayýsýyla gruplamaya gerek kalmýyor

--SORU: sadece ilçesi olan illeri getiren SQL

select i.* from iller i
select ic.* from ilceler ic

select i.adi   from iller i inner join ilceler ic on i.ilkodu=ic.ilkodu group by i.adi

-- inner join eþleþme olmayanlarý silip atýyor idi yani il kodu 03 olan bir il  03=ic.kodu burda sonuc yok ise direkt onu görmezden gelir
--listeden atar aslýnda olay eþleþme olmayanlarý inner joinin direkt silip atmasýyla ilgili.

--subq kullanarak ancak þöyle olur

select  i.adi from iller i where  i.ilkodu in ( select  ic.ilkodu from ilceler ic)
--farkettiysen ortak sütun eþlemesi yapmadýk çünkü burda gerek yoktu.. subq illaki ortak sütün = lemesi içermez 
--ancak burda þöyle bir handikap vardýr   subq içindeki  il kodlarý  bir il içinde birden fazla ilçe olacaðý için  birden fazla  ayný il kodu 
--içerecektir.  yani il kodlarý 06 06 06 diye tekrar edecek fakat farkettiysen çýktýmýz sorunsuz çalýþtý yani birden fazla adana
--vb yazmadý   burda sonucun doðru olmasý where ile alakalý where bir kez þart saðlandýysa ayný or operatörü gibi diðerlerine bakmaz
--evet 06   mevcut koþul saðlandý der ve geçer ama böyle olmasaydý çýktýmýz mesela adananýn ilçe sayýsý kadar adanayý tekrar tekrar yazdýrýrdý
-- iþte bunun için distinct kullanabiliriz ancak asýl kullaným exists ile olmalý

select  i.adi from iller i where  i.ilkodu in ( select  distinct ic.ilkodu from ilceler ic)
--þimdi  in içinde her il kodu 1 kez tekrarlanacak dolayýsýyla arka planda  daha az iþ yapýlmýþ olacak
--distinct anlamý tekrarlayan ifadeleri tek bir gösterim haline getirir

--aþaðýda aradaki fark anlaþýlýr
select  distinct ic.ilkodu from ilceler ic
select   ic.ilkodu from ilceler ic

---- exists ile çözüm ----

--exists ile çözmeden aþaðýdaki olayý anlayalým
select 1  from iller i
select 'asdjkad'  from iller i
--farkettiysen iller tablosu seçili ama select kýsmý abzürt veriler içeriyor. ancak çýktý tablonun satýr sayýsý kadar yazdýrma yapýyor
--kýsaca select kýsmý senin emrindeki birþey ama tabloyla uyarlý harekette edebiliyor burdan cýkan sonuc sudur eðer  from sonrasý
--doðruysa çýktý rastgele birþey ayarlanabilir bu true demektir þimdi sql dünyasýnda böyle kullanýmlarda yani sonuc true mi bilmek için
--genelde 1 kullanýlýr


--alttaki kodu anlamak için altýna yaptýðým açýklama sonrasý  = lik olmayan bir örnek yazýcam  olayý daha iyi anlarsýn
select i.adi  from iller i where exists  (select 1 from ilceler ic  where  ic.ilkodu=i.ilkodu)
/*
þimdi exists ile bu soru bu þekilde saðlýklý çözülür en doðru çözüm inner join sonrada exists dir
burda yaðtýðýmýz þey þu iller tablosundaki tüm il adlarýný  where filtresinden geçerse yazdýr  dedik ama where den sonra birde
exists de kullandýk bu þu anlama gelir exists den sonraki kod true verirse where koþuluda true olur  o halde sýralama þöyle olcak
ana sorgu tüm illeri sýrayla yazdýracaktýr(sql sýrayla giderdi) ilk sýrada Adana var  adanayý yazdýrmadan önce where koþulu ile karþýlaþýr
 gerisi yukarda anlattýðým þekilde ilerler yani alt sorgudaki where þöyle olur ic.ilkodu='01' adanýnýn il kodu 01 oldugu için alt sorguda
 01 iletilir  ic.ilkodu 01 e sahip oldugu için alt sorgu  bir çýktý verecek durumdadýr yani true'dir(4 adet 01 kodlu ilçe var 4 satýr 
 1 yazdýrýcak ama  bu önmli deðil. bir satýr bile yazdýrabiliyor olmasý onu true yapmýþ demektir) dolayýsýyla exits true döner
 o halde ana sorgudaki where'de true döner son olarak ana sorgu tamam adanayý yazdýrabilirim der ve yazdýrýr sýrayla iþlemler devam eder
 NOT: 1 yerine ic.* veya iç.ilkodu gibi farklý þeylerde yazabilirdik ama sonuç true mi false mi bu önemli old için 1 yazarýz
 */

select i.adi  from iller i where exists  (select 1 from ilceler ic  )
-- eðer alt sorgu where içermese exists her il için true dönecektir ve iller tablosu aynen çalýþýcaktýr
--not: ayný ilden birden fazla gelmez iller tablosu ayný gelir çünkü ana sorgu adana iþlemindeyken alt sorgu 1 kez true verse yeterlidir
--ne demiþtik where ile  tek koþul yeterli daha doðrusu true false babýna gelen herþeyde bu böyle. dolayýsýyla alt sorgu 1 kez true verse
--exists true döner ve ana sorgu için adana okeydir ama bu tüm iller için true olacak cunku alt sorgu koþulsuz þartsýz her çalýþýmda
--true dönecektir çünkü hiçbir iliþki yok yani ana sorgu ne kadar satýr  olursa olsun her satýrda alt sorgu yani subq sýfýrdan calýsacaktýr
--dolayýsýyla ana sorguda kaç satýr varsa hepsi true döncek anlamsýz birþey olcak bu yüzden alt sorguyada where ekliyerek
--ana sorgu ile aralarýnda bir þart oluþturmalýyýz bir baðlam olmalý


--SORU sadece bünyesinde personelleri olan departmanlarý getiren sql

select p.* from Personel p

select d.Adi from Departmanlar d where exists (select 1 from Personel p where p.DepKodu=d.Kodu)

--  ana sorgu departman adlarýný yazdýr diyor  ama where filtresi var o  ilk yazýlacak departmaný filtreye sokar Bilgi iþlem
--alt sorguda d.Kodu istendiði için bilgi iþlemin d.Kodu D1 diyor   p.DepKodu=D1 mevcut olacaðý için alt sorgu true döner ve bilgi iþlm yazar

--SORU: sadece ilçesi olmayan illeri getiren sql

select  i.adi from iller i where  not exists (select 1 from ilceler ic where ic.ilkodu=i.ilkodu)
-- þimdi burda ilcesi olmayanlarý istiyor dolayýsýyla ilcesi  olanlar true dönecektir olmayanlar false
--ancak  not exists demek false olanlarý true kabul etmek demektir yani eðer  alt sorgu false ise not exists bunu true kabul edecek
--dolayýsýyla where false olanlarý true gibi görecek 

--SORU sadece bünyesinde personelleri olmayan departmanlarý getiren sql

select d.Adi from Departmanlar d where not exists (select 1 from Personel p where p.DepKodu=d.Kodu )

















    


    
