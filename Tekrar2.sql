
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

     select d.Adi, COUNT(*) as AdýndaEveHOlanlarýnSayisi from Personel p inner join Departmanlar as d on d.Kodu=p.DepKodu
    where p.Ad like '%e%' or p.Ad like '%h%' group by d.Adi

    --yukardaki kodda gruplamada cinsiyeti yazsak gereksiz yere ayný departmaný alt alta yazýp 2 deðer verecekti ama tek satýrda deðer verse yeterli
    /*Filtreleme, bir grubun hesaplanmýþ sonucuna (COUNT > 5 gibi) deðil de, satýrýn ham verisine (Ad sütununun içeriði gibi) yapýlýyorsa, 
    bu filtre HER ZAMAN WHERE ile yapýlýr. where gruplamadan önce iþleme girer*/

     select p.* from Personel p


    


    
