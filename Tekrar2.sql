
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


    


    
