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




