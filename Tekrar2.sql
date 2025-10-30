
--S1: 4 veya daha fazla personele sahip olan departmanlar� getiren sql

select d.Adi, COUNT(*) as PersonelSAyisi  from personel p inner join Departmanlar as d on p.DepKodu=d.Kodu 
group by d.Adi having COUNT(*)>=4

-- inner join kulland�g�m�z i�in DepKodu null olanlar zaten birle�ime girmedi
-- k�saca selectten sonrakiler sadece g�sterimdir.. having izin verdi�i s�rece ��kacaklard�r mesela selectten sonra count yapmasayd�k bile
--having ayn� yaz�l�rd� alttaki ��z�mde bunu anlayacaks�n yani �nceli�ini from'dan sonraki k�s�mlara ver herzaman 
-- yani fromdan sonraki k�s�mlar�n izin verdiklerini select ile yazd�r�yoruz i�leyi� ��yle  fromdan sonra �u oluyor departmanlar� grupla
-- departman�n ilk grubu �rne�in  bilgi i�lemdeki sat�rlar� say(��nk� * kullanm���z p.Id deseydik idleri sayard�) 4 veya daha fazlas� olursa
--filtreden ge�er selectten sonra d.adi k�sm�nda bu filtreden ge�enler yazacakt�r ard�ndan count ise  havingde saym��t� i�te onlar� yazd�r�r

--- ******************************** �NEML� AYDINLANMA *********************************
-- ****** �nceki scripte yazd���m �nemli bir mant�k hatam�z var oda �u: selectten sonraki count asl�nda bir �nceki s�tuna g�re hareket etmiyormu�
--yani group by ile gruplama yap�lmas�na g�re sayma yap�yormu� dolay�s�yla selectten sonraki s�tunlar� bag�ms�z d���nmeliyiz. ! bunu anlamak i�in ;

--Senaryo: diyelimki     ** select p.Ad, COUNT(p.Adi)  from personel p group by p.Ad ** komutu girildi tablodada ali  isminde 3 veli isiminde 4 ki�i olsun
--  Group By  ile ali ismi tek bir grup olcak veli'de  bir grup olcak. selectten sonraki p.Ad, ali ve veliyi birkez yazacak ama yan�ndaki count s�tunu
--Alinin yan�na 3 veliye 4 yazacak ama bu saymay� ilk s�tun p.Ad ' a g�re de�il group by p.Ad  kodun'a g�re yap�yor yani group by k�sm�n� endeks al�p say�yor
--yani selectten sonraki s�t�nlar� bag�ms�z d���n �nceki scriptte(Takrar1'de) yanl�� d���n�yormu�uz




--a�a��daki yapay zekan�n daha zay�f bir ��z�m� ama bunun �zerinden bilgiler verece�im alt�ndaki notlar� oku
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

    --farkettiysen having de id var ilk bak��ta mant��� sa�ma gibi geliyor ama sql mant�g�n� anlamam�z laz�m
    --�imdi d.adi ile gruplama yap�lm�� bu �u demek her bir departman� ayr� ayr� kovalara ay�r having ile ise p yi saym���z
    --akl�na �u gelebilir gruplamay� departman ile yapt�k sayac� personelde yapt�k sistem nas�l gruplardaki id leri ayr� ayr� saymas� gerekti�ini anl�yor?
    --burda kilit nokta �u biz join ile 2 tabloyu birle�tiriyoruz asl�nda depkodu ve id ler ayn� sat�rda  yani tek tablo oldugu i�in hepsi i� i�e
    --dolay�s�yla sayma i�leminden �ncede gruplama yap�ld��� i�in having her grubun id lerini say�yor  selectte departman ad� yaz�cak
    --her departman ad� yaz�ld�g�nda o departmandakilerin idleri say�l�r dolay�s�yla 4 den fazla olanlar�nki g�sterilir
    --ancak bu kodda personel say�s�n� yazd�r�cak s�tun olu�mad�g� i�in sadece departman isimleri yazar



    --S2: Cinsiyeti Erkek olan personellerin departmanlara g�re say�lar�n� getiren sql

    select d.Adi, COUNT(p.Cinsiyet) as ErkekSay�s� from   Personel p inner join Departmanlar as d on d.Kodu=p.DepKodu
    group by d.Adi, p.Cinsiyet having p.Cinsiyet='E'

    --yukardaki kod departmanlar�  ve cinsiyetleri kovalara ay�r�r yani gereksiz yere kad�nlar�da gruplar ard�ndan say�m i�leminide yapar
    --en sonra having sebebiyle kad�nlar� atar  sonucta do�ru c�kt� verir her�ey yolunda gibi ancak gereksiz yere i�lemler yap�lm�� olur o y�zden 
    --where ile filtreleme yap�p sonra gruplay�p sonra sayd�rmal�y�z a�a��daki kod daha iyidir.
    --�nemli bilgi: yukardaki koddan group by k�sm�ndaki p.Cinsiyeti silersek sorgu hata verir ��nk� gruplama yap�lanlar aras�ndan havingi kullanabiliriz
    --cinsiyeti gruplamazsak sql kafas� kar���r ama farkettiysen a�a��daki kodda group by da cinsiyet olmasada  cinsiyet=E yapabildik bunun nedeni
    --zaten gruplamadan �nce kad�nlar� where ile att�k ayr�ca where kullan�nca zaten havinge gerek kalmaz cunku kad�nlar� at�nca geriye zaten sadece
    --erkekler kal�r k�saca 'HAV�NG' gruplama ve count gibi i�lemlerden sonra  �al��an bir filtrelemedir o y�zden bu soruda having verimsiz olcakt�r
    --bu a���ya birka� �e�it yemek yapt�r�p sadece 1 ini yicez diyip di�erlerini ��pe atmaya benzer

    select d.Adi, COUNT(*)as ErkekSayisi  from Personel p  inner join Departmanlar as d on d.Kodu=p.DepKodu where p.Cinsiyet='E' group by d.Adi
    --sadece erkekleri getirirsek sonrada gruplarsak b�ylece gereksiz i�lemler yap�lmam�� olur zaten say�c� sadece erkek personelleri
    --sayacak ��nk� her sat�rdaki personel erkek olacak biz sat�r say�s�n� alsak erkek say�s�n� alm�� gibi oluruz �yle d���n

    select p.* from Personel p
    select d.* from Departmanlar d

    --S3: cinsiyeti erkek olan personellerin departmanlar�na g�re say�lar�n� getiren ve PerSayisi 3 ve daha fazla departmanlar�n�   listeleyen sql

    select d.Adi, COUNT(*) as PersonelSay�s� from Personel as p inner join  Departmanlar as d on p.DepKodu=d.Kodu
    where p.Cinsiyet='E' group by d.Adi having COUNT(p.Cinsiyet)>2

    -- kod tamamen do�rudur �nce inner join ile depkodu olmayanlar elendi where ile kad�nlar elendi ard�ndan  departmanlar�   gruplad� zaten sadece erkek
    --ler kald� i�inde ard�ndan  cinsiyetlerini sayd� sadece erkek oldugu i�in 2 sat�rdan fazla olan departmana izin verdi
    --ard�ndanda selectte  filtrelemelerden ge�enler yaz�lmaya ba�land� �nce d.Adi ile bilgi i�lemi yazd� ve count ise filtrelemeden ge�en hangisi
    --ise onu sayd� yani  selectteki count d.Adi k�sm�nda yazan� de�il zaten  fromdan sonraki a�amada filtrelemeden ge�eni sayd� d.Adi ise filtrelemeden
    --ge�en bilgi i�lem oldugu i�in onu yazd�rd�.

     select p.* from Personel p

     --s4: ad�nda e veya h ge�en personellerin departmanlara g�re say�lar�n� getiren sql

     select d.Adi, COUNT(*) 
from Personel p  inner join Departmanlar as d on d.Kodu=p.DepKodu
group by d.Adi, p.Cinsiyet  
having p.Ad like '%e%' or p.Ad like '%h%'
-- having hatal�d�r a�a��da nedeni yazd�m


     select d.Adi, COUNT(*) as Ad�ndaEveHOlanlar�nSayisi from Personel p inner join Departmanlar as d on d.Kodu=p.DepKodu
    where p.Ad like '%e%' or p.Ad like '%h%' group by d.Adi

    --yukardaki kodda gruplamada cinsiyeti yazsak gereksiz yere ayn� departman� alt alta yaz�p 2 de�er verecekti ama tek sat�rda de�er verse yeterli
    /*Filtreleme, bir grubun hesaplanm�� sonucuna (COUNT > 5 gibi) de�il de, sat�r�n ham verisine (Ad s�tununun i�eri�i gibi) yap�l�yorsa, 
    bu filtre HER ZAMAN WHERE ile yap�l�r. where gruplamadan �nce i�leme girer*/

     select p.* from Personel p

     /* 4. soruda having cal�smama nedeni :
     Hata veriyor, ��nk� GROUP BY komutu o kovadaki 5 farkl� p.Ad de�erini TEK B�R SATIRA ��KERT�R (COLLAPSE) ve HAVING bu tek sat�ra bakar.

SQL'in ne g�rd���n� ad�m ad�m tekrar d���nelim:
JOIN yap�ld�.
GROUP BY d.Adi �al��t�.
SQL, '�nsan Kaynaklar�' grubunu olu�turdu. Bu anda SQL i�in art�k 5 ayr� personel (G�lizar, Sevde, Hilal, Ebru, Orhan) yoktur. Sadece 
TEK B�R SATIR vard�r: Ad� '�nsan Kaynaklar�' olan bir "Grup".
COUNT(*) bu grup i�in �al���r ve "5" de�erini hesaplar.
HAVING p.Ad like '%e%' komutu gelir.
SQL, o TEK "�nsan Kaynaklar� Grubu" sat�r�na bakar ve sorar: "Senin p.Ad de�erin nedir?"
��TE HATA ANI: O tek temsili sat�r�n p.Ad de�eri nedir? 'G�lizar' m�? 'Sevde' mi? 'Hilal' mi? 'Ebru' mu? 'Orhan' m�? Hi�biri ve hepsi. Bu bir BEL�RS�ZL�KT�R.
    SQL'in HAVING komutu "grubun i�ine bak�p Sevde ve Hilal'i ay�klayay�m" diye bir i�lem yapmaz. HAVING sadece o grubun temsili tek sat�r�na 
    bakar ve o sat�r�n p.Ad de�erini sorar. Tek bir de�er bulamad��� i�in de size hata verir.
    ama whereli �rnekde zaten  i�inde sadece e ve h li olanlar grup olusturur dolay�s�yla geriye sadece sat�r sayma kal�r
    
    peki diceksinki where dede ��kertme oluyor orda nas�l say�m yapt� asl�nda orda olay where k�sm�nda zaten bitmi� oluyor ard�ndan sadece grup say�s�n�
    alsak bize yeterli yani gruplama sadece e ve h li olanlar �zerinden kuruldugu i�in o gruba ait ki�i say�s�(sat�r) bize yeterlidir zaten cevapta budur 
    ekstra i�lem yine yap�lamaz ama zaten yap�lmas�nada gerek kalmam��t�r sonu� ��km��t�r bunun senaryo �eklinde  altta yazal�m:
    
    Senaryo 1: HATA VEREN HAVING Sorgunuz

GROUP BY d.Adi: SQL '�nsan Kaynaklar�' kovas�n� al�r.

Kovaya At�lanlar: 'G�lizar', 'Sevde', 'Hilal', 'Ebru', 'Orhan' (5 ki�i).

��kertme: Kova kapan�r. Art�k o 5 ki�i g�r�nmez. Kovan�n �st�nde bir etiket vard�r: "Grup Ad�: �nsan Kaynaklar�", "��indeki Say�: 5".

HAVING p.Ad LIKE '%e%': SQL gelir ve bu kapal� kovaya sorar: "Senin p.Ad de�erin nedir? 'e' i�eriyor mu?"

HATA: Kova cevap veremez. Kovan�n tek bir p.Ad de�eri yoktur. ��inde 5 farkl� de�er vard� ama art�k kapal�. Bu bir belirsizliktir.

Senaryo 2: DO�RU �ALI�AN WHERE Sorgunuz

WHERE p.Ad LIKE '%e%' OR p.Ad LIKE '%h%': SQL daha kovalar� ��karmadan, masadaki t�m personeli filtreler. 'G�lizar' ve 'Burak' gibi isimleri ��pe atar.

GROUP BY d.Adi: SQL '�nsan Kaynaklar�' kovas�n� al�r.

Kovaya At�lanlar: Sadece WHERE filtresinden ge�enler kovaya at�l�r: 'Sevde', 'Hilal', 'Ebru', 'Orhan' (4 ki�i).

��kertme: Kova kapan�r. Art�k o 4 ki�i g�r�nmez. Kovan�n �st�nde bir etiket vard�r: "Grup Ad�: �nsan Kaynaklar�", "��indeki Say�: 4".

SELECT d.Adi, COUNT(*): SQL gelir ve bu kapal� kovan�n etiketini okur:

d.Adi nedir? -> '�nsan Kaynaklar�' (Belirsizlik yok).

COUNT(*) nedir? -> '4' (Belirsizlik yok).

BA�ARILI: Sonu� ekrana yazd�r�l�r.

�zetle: Her iki senaryoda da "��kertme" (gruplama) var.

Hata veren sorguda sorun, ��kertme bittikten sonra o grubun i�indeki ham bir detay� (p.Ad) sormakt�r.

Do�ru sorguda sorun yok, ��nk� ��kertme bittikten sonra sadece grubun kendisiyle ilgili net bilgileri (d.Adi ve COUNT(*)) istiyorsunuz.
Filtrelemeyi (p.Ad) ise en ba�ta, ��kertme ba�lamadan WHERE ile hallettiniz.
*/

select  distinct p.Maas from Personel p -- distinct  bir�eyden fazla varsa onu tek g�sterime indirger 77k 2 adetse 1 kere belirtir.

--*****Sub query/Alt Sorgu  ( birden fazla select ifadesinin oldugu sorgulara alt sorgu denir***

--S1: Personel verilerini departman isimleri ile birlikte getiren SQL

select p.*, d.Adi from personel p  left join Departmanlar as d on d.Kodu=p.DepKodu -- bunla ��zd�k

-- a�a��daki sorgula ile ��kt�lar nas�l oluyor anla yani bir s�tun yaz�nca tablodaki o s�tuna ait hepsi geliyor
--tek bir sat�rl� s�tun i�in where ile yapt�k yani bu mant���  �nce kafanda oturttur

select  d.Adi from personel p  left join Departmanlar as d on d.Kodu=p.DepKodu -- left ile alttaki fark� anla

--sadece departman adlar�n� getirmiyor s�tun sadece d.Adi olabilir ayn� zamanda t�m personel tablosunu getiriyor ba�lant� �zerinden
--personelde kod  e�le�iyorsa departman ismini getiriyor null olanlar� null b�rak�yor inner join olsa  nullar haric ayn� tablo olurdu
select  d.Adi from personel p  inner join Departmanlar as d on d.Kodu=p.DepKodu

select d.Adi from Departmanlar d

select d.Adi  from Departmanlar d  where d.Kodu='D1'

--sub query ile ��z�m

select p.* , (select d.Adi From Departmanlar d where d.Kodu=p.DepKodu)as depAdi   from Personel p -- subquery ��z�m�
select p.*, d.Adi as depAdi from personel p  left join Departmanlar as d on d.Kodu=p.DepKodu -- bizim ��z�mle k�yasla

--hi�bir fark yoktur subquery sat�r sat�r cal�st�g� i�in  where d.Kodu=p.DepKodu �u �ekilde sql taraf�ndan okunur;
--from personel oldugu i�in ilk sat�r� yazarken burak'�n DepKodu D1 dir  yani  subquery de yani () i�inde "where d.Kodu='D1'" olarak alg�layacakt�r buda departmanlar tablosunda bilgi i�lem demektir
--o halde subquery () parantez i�inin ��kt�s� direkt  bilgi i�lemi getircektir komple parantez i�i o sat�r i�in  bilgi i�lemi temsil eder
-- ve parantezden ��k�p yoluna devam edecektir sonra �teki sat�r i�inde ayn� i�lemler tekrarlanacakt�r  k�saca her sat�rda ayn�
--i�lemi yapacakt�r yani subquery ile  sat�r sat�r(row by row) i�lem yapm�� olduk for d�ng�s� gibi d���n..  subquery i�indeki
--p.DepKodu  her sat�r i�in o sat�rdaki personelin DepKodunu al�cakt�r d.Kodu'na atayacakt�r.
--yani burda where d.Kodu =p.DepKodu dememizin nedeni 2 tablo bu konuda uyumlu ama ba�ka bir�eyde yapabilirdik
--d.Ad�=p.Ad� yapsayd�n sorgu sa�ma olurdu ama teoride cal�s�rd� bilgii�lem =burak sonraki sat�rda �zkan �eklinde giderdi anla diye s�yledim

select d.* from Departmanlar d

select p.*, (select d.Adi from Departmanlar d where d.Kodu=p.DepKodu)as DepAd� from personel p


--S2: il�e verilerini il isimleri ile birlikte getiren SQL
select  p.* from iller p
select d.* from ilceler d

select i.*, ( select iller.adi  from iller where iller.ilkodu=i.ilkodu  ) as ilIs�mler�  from ilceler i

--tabloya bak�yorsun ortak s�tun hangisi olabilir onu bulcan  k�saca �nce tablolar birbiriyle uyumlu olmal� zaten

select ilceler.Id,ilceler.ilkodu, (select iller.adi  from iller where iller.ilkodu=ilceler.ilkodu)as ilIs�mleri ,ilceler.adi  from ilceler 

--S3: En y�ksek Maas verisine sahip olan personel/personelleri getiren SQL( ayn� maa�a sahip bir�ok  insan olabilir top kullan�lmaz )

-- �nce alttaki kodlar�n farklar�n� anla  Ercan Diyince ercanla ilgili sat�r�n  t�m s�tunlar�n� getiriyor 
select p.* from Personel p  where p.Ad = 'Ercan'
--alttakinde t�m sat�rlar�n t�m s�tunlar�n� getiriyordu
select p.* from Personel p  

select p.* from Personel p  where p.Maas= (select  MAX(p.Maas) from Personel p)

-- mant��� �ok kolay anl�caz �imdi  a��kl�yorum : amac�m�z en y�ksek maas� bulmak de�ilmi sonucta 1 den fazla ki�ide olsa
--en y�ksek maas 1 tanedir.. e o halde en y�ksek maas� bulan kodu elde edelimki sonra o maasa sahip olanlar� istiyebiliriz
-- () yani subquery i�indeki kod bize en y�ksek maa�� yazd�ran koddur ��kt�s� sadece en y�ksek maas�n say�sal de�eridir
-- o halde kodumuz �uanda �u hale geldi  select p.* from Personel p  where p.Maas= 231250
-- yukardaki 231250 �uanki en y�ksek personelin maas de�eridir ilerde de�i�tirebiliriz ama �uan 231250 dir. g�rd���n gibi
-- bize bu maas� alan personeli getir kodu mevcut oldu bu maas� birden fazla ki�i alsayd� p.* sayesinde hepsini yazd�racakt� ama tek ki�i
-- oda yi�it

select p.* from Personel p  where p.Maas= 77000.0000 -- mesela 770000 olan k�s�m subquery nin nihai sonucu olsayd�  g�rd���n gibi
--c�kt� birden fazla ki�i oluyor


select p.* from Personel p  where p.Ad=(select  p.Ad from Personel p where p.Ad='Ercan')

-- yukarda abuk subuk bir �rnek yazd�m subquery olay�n� anlamak i�in.
--subquery sonucu yani: select  p.Ad from Personel p where p.Ad='Ercan' bunun sonucu yine Ercan'd�r
--o halde ana sorgu select p.* from Personel p  where p.Ad='Ercan' gibi olacakt�r yani bize Ercanla ilgili olan t�m s�tunlar gelir

--S4: departmanlar� personel say�lar� ile  birlikte listeleyen sql

select d.* from Departmanlar d
select p.* from Personel p
















    


    
