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





