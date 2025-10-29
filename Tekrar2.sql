
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


    
