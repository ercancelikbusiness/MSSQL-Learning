
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


    
