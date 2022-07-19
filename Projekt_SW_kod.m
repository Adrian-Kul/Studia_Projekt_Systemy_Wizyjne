%
% needs unpacked „OKNO_X.avi” file in project folder
%

v = VideoReader('OKNO_1.avi'); %wczytanie sekwencji wideo
nr = 0; %numer produktu w ca³ej sekwencji
produkty_ilosc(1:7)=0; %wektor przechowujacy ilosc produktow w danej kategorii (index wektora odpowiada nr kategorii)
produkt = struct('pole',{},'euler',{},'kolor',{},'kolor_wartosc',{},'kategoria',{}); %struktura do zapisu produktow
suma_pole(1:6) = 0; %zmienna do zapisy sumy pol w danej kategorii
sr_pole(1:6) = 0; %zmienna przechowujaca wartosc sredniego pola w danej kategorii
S(1:6) = 0; %odchylenie standardowe w poszczegolnych kategoriach

line = im2uint8(zeros(v.Height,v.Width,3)); %stworzenie lini, za pomoc¹ ktorej wykrywane beda produkty
line(round(size(line,1)/2),:,:) = 255;

f = figure; %stworzenie figury do wyswietlania
while hasFrame(v)
    vidFrame = readFrame(v); %wczytywanie kolejnych klatek z sekwencji wideo
    
    figure(f) %wybranie figury f
    subplot(1,2,1) %podzielenie figury na dwie czesci i wybranie pierwszej
    image(vidFrame+line); %wyswietlenie klatki wideo wraz z linia detekcji
    
    im = imreconstruct(line,vidFrame); %rekonstrukcja w celu wchwycenia obiektow przechodzacych przez linie detekcji

    %segemntacja przez kolor
    s_R = im(:,:,1) >55;
    s_G = im(:,:,2) >55;
    s_B = im(:,:,3) >55;
    seg = s_R + s_G + s_B; %zlozenie wynikow segmentacji w poszczegolnych skladowych

    seg_f = medfilt2(seg,[3 3]); % filtracja filtrem medianowym

    [e, num] = bwlabel(seg_f); % etykietowanie
    
    if num > 0  %dalsze operacje nastepuja w momencie, gdy zostanie wykryty obiekt w wyniku segementacji
        i  = i + 1; %zliczanie ilosci wykryc obiektu 
        if i == 20   %gdy uzyska sie obiekt z segmentacji 20 razy z rzedu, to nastepuje dalsze przetwarzanie
            nr = nr + 1; %zawiekszenie liczby wykrytych obiektow
            cechy = regionprops(e,'Area','BoundingBox','EulerNumber'); %wyznaczenie cech produktu
            boundingboxes = cat(1, cechy.BoundingBox); %pobranie danych o ramce wykrytego produktu
            produkt(nr).pole = cat(1, cechy.Area);  %zapis wartosci pola powierzchni
            produkt(nr).euler = cat(1, cechy.EulerNumber); %zapis wartosci liczby eulera
            
            x = round(boundingboxes(1)); %zapis wspolrzednej x ramki obiektu
            y = round(boundingboxes(2)); %zapis wspolrzednej y ramki obiektu
            obiekt = im(y:y+boundingboxes(1,4),x:x+boundingboxes(1,3),:); %ekstrakcja wykrytego produktu z klatki wideo
            figure(f)
            subplot(1,2,2)
            imshow(obiekt); %pokazanie wykrytego obiektu obok obrazu zarejestrowanego
            
            produkt(nr).kolor_wartosc = max(obiekt,[],[1 2]); %okreslenie wartosci koloru obiektu przez wartosc max w ka¿dym wymiarze osobno (RGB)
            
            %okreslenie nazwy koloru w zaleznosci od wartosci koloru
            if (produkt(nr).kolor_wartosc(1,1,1) > 60) && (produkt(nr).kolor_wartosc(1,1,2) < 55) && (produkt(nr).kolor_wartosc(1,1,3) < 55)
                produkt(nr).kolor = 'czerwony';
            end
            
            if (produkt(nr).kolor_wartosc(1,1,1) < 55) && (produkt(nr).kolor_wartosc(1,1,2) > 70) && (produkt(nr).kolor_wartosc(1,1,3) < 55)
                produkt(nr).kolor = 'zielony';
            end
            
            if (produkt(nr).kolor_wartosc(1,1,1) < 55) && (produkt(nr).kolor_wartosc(1,1,2) > 55) && (produkt(nr).kolor_wartosc(1,1,3) > 55)
                produkt(nr).kolor = 'cyjan';
            end
            
            %okreslenie kategorii na podstawie koloru i l. eulera: 1:3 - dwojki; 4:6 - osemki, 7 - produkt wadliwy
            if produkt(nr).euler == 1
                if strcmp(produkt(nr).kolor,'czerwony')
                    produkt(nr).kategoria = 1;
                end
                if strcmp(produkt(nr).kolor,'cyjan')
                    produkt(nr).kategoria = 2;
                end
                if strcmp(produkt(nr).kolor,'zielony')
                    produkt(nr).kategoria = 3;
                end
            end
            
            if produkt(nr).euler == -1
                if strcmp(produkt(nr).kolor,'czerwony')
                    produkt(nr).kategoria = 4;
                end
                if strcmp(produkt(nr).kolor,'cyjan')
                    produkt(nr).kategoria = 5;
                end
                if strcmp(produkt(nr).kolor,'zielony')
                    produkt(nr).kategoria = 6;
                end
            end
            
            if (produkt(nr).euler < -1) || (produkt(nr).euler == 0) || (produkt(nr).euler > 1)
                produkt(nr).kategoria = 7;
            end
            
            %zwiekszenie ilosci produktow w danej kategorii (zwiekszenie ilosci o 1)
            produkty_ilosc(produkt(nr).kategoria) = produkty_ilosc(produkt(nr).kategoria) + 1;
            
            if produkt(nr).kategoria <7 %dalsze dzia³anie tylko dla kategorii 1-6
                suma_pole(produkt(nr).kategoria) = suma_pole(produkt(nr).kategoria) + produkt(nr).pole; %doliczenie pola do sumy pol w wykrytej kategorii
                sr_pole(produkt(nr).kategoria) = suma_pole(produkt(nr).kategoria) / produkty_ilosc(produkt(nr).kategoria); %obliczanie sredniego pola powierzchni
            end
            
            %przygotwanie informacji o wykrytym produkcie do wyœwietlenia i wyswietlenie jej pod jego widokiem
            str = {['Kategoria: ',num2str(produkt(nr).kategoria)],...
                ['Iloœæ produktow w sekwencji: ',num2str(nr)],...
                ['Iloœæ produktów w tej kategorii: ',num2str(produkty_ilosc(produkt(nr).kategoria))]};
            figure(f)
            text(1,size(obiekt,1)+2,str,'VerticalAlignment','cap')
        end
    else
        i = 0; %zerowanie licznika wykryc obiektu, gdy nie zostaje wykryty obiekt
    end
    
    pause(1/(10000*v.FrameRate)); %pauza w celu odswiezenia figury, na tyle mala aby nie wydluzac czasu realizacji programu
end

%stworzenie wektora zawierajacego wartosci pol powierzchni w jednej z kategorii i obliczenie odchylenia standardowego
for kategoria = 1 : 6 %powtarzanie opracji dla kategori od 1 do 6
pola = 0; %zerowanie wektora pol
k = 1;  %ustalenie indexu wektora jako pierwszy
for j = 1 : nr %przeszukiwanie w dotychczas wykrytych produktach wartosci pol powierzchni w danej kategorii
    if produkt(j).kategoria == kategoria
        pola(k) = produkt(j).pole; %zapis wartosci pola do wektora, jesli kategoria sie zgadza
        k = k+1; %zwiêkszenie indexu wektora
    end
end
S(kategoria) = std(pola); %obliczanie odchylenia standardowego pola powierzchni dla stworzonego wektora pol
end

%przygotowanie tekstu do wyœwietlenia, zosta³ on podzielony na dwie zmienne: tekst i dane
%dane numeryczne s¹ zmieniane na zmienn¹ typu string
tekst = {['Liczba przebadanych obiektów: ',num2str(nr)],'','',...
    'Liczba produktów w poszczególnych kategoriach:','',...
    'Pierwsza: ','Druga:','Trzecia:','Czwarta:','Pi¹ta:','Szósta:','Siódma:'};
dane = {
    [num2str(produkty_ilosc(1)),' (œrednia powierzchnia: ',num2str(sr_pole(1),3),' ; odchylenie standardowe: ',num2str(S(1),3),')'],...
    [num2str(produkty_ilosc(2)),' (œrednia powierzchnia: ',num2str(sr_pole(2),3),' ; odchylenie standardowe: ',num2str(S(2),3),')'],...
    [num2str(produkty_ilosc(3)),' (œrednia powierzchnia: ',num2str(sr_pole(3),3),' ; odchylenie standardowe: ',num2str(S(3),3),')'],...
    [num2str(produkty_ilosc(4)),' (œrednia powierzchnia: ',num2str(sr_pole(4),3),' ; odchylenie standardowe: ',num2str(S(4),3),')'],...
    [num2str(produkty_ilosc(5)),' (œrednia powierzchnia: ',num2str(sr_pole(5),3),' ; odchylenie standardowe: ',num2str(S(5),3),')'],...
    [num2str(produkty_ilosc(6)),' (œrednia powierzchnia: ',num2str(sr_pole(6),3),' ; odchylenie standardowe: ',num2str(S(6),3),')'],...
    num2str(produkty_ilosc(7))
    };

figure %utworzenia nowej figury, na ktorej zostanie wyswietlony raport koncowy 
annotation('textbox',[0 0 1 1],'String',tekst); %wyœwietlenie pierwszego tekstu
annotation('textbox',[0.13 0.3 1 0.5], 'String',dane, 'LineStyle','none'); %wyœwietlenie drugiego tekstu

