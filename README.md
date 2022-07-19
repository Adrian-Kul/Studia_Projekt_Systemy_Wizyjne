# PROJEKT – wizyjna kontrola jakości

Projekt polega na opracowaniu metody i napisaniu implementującego ją programu w Matlab-ie
realizujących zadanie wizyjnej kontroli jakości na podstawie sekwencji wideo. Sekwencja (sztucznie
wygenerowana) zawiera widok z kamery obserwującej proces produkcyjny pewnych produktów
poruszających się na podajniku taśmowym. Wśród produktów przesuwających się przed kamerą
znajdują się zarówno prawidłowe w kilku różnych kategoriach oraz wadliwe. Plik wideo z zapisem nosi
nazwę „OKNO_X.avi”. W pliku „OKNO_X_ref.png” są uwidocznione produkty:                     
• Prawidłowe w trzech kolorach (kolumna 1 i 4)  
• Wadliwe w tych samych trzech kolorach (kolumny 2,3,5 i 6)

Szczegółowe cele do realizacji są następujące:
1. Opracowanie i implementacja sposobu wykonywania zdjęć kolejnych produktów
pojawiających się na obrazie z wirtualnej kamery - wirtualnej kurtyny świetlnej wyzwalającej
migawkę w momencie pojawienia się produktu. Kontrola jakości jest przeprowadzana na
obrazach statycznych, pojedynczych klatkach sekwencji, a zatem ważne jest by każdy produkt
został zarejestrowany tak by możliwa była dalsza analiza jego obrazu. Oczekiwanym efektem
końcowym jest seria pojawiających się kolejno widoków kolejnych produktów na linii
produkcyjnej.
2. Opracowanie i implementacja metody kontroli jakości obrazu statycznego zawierającej
produkt(y) składającej się z etapów filtracji, segmentacji oraz ekstrakcji cech obiektu oraz – na
ich podstawie – jego klasyfikacji do odpowiedniej kategorii. Kategoriami są klasy
odpowiadające poszczególnym produktom prawidłowym w poszczególnych kolorach (6 klas)
oraz produktom wadliwym (bez rozróżniania ani koloru ani rodzaju wadliwości – 1 klasa).
3. Opracowanie i implementacja metody zbierania danych na temat całej partii produktów
(kompletnej sekwencji wideo) – kategorii kolejnych produktów wraz ze zliczaniem produktów
w poszczególnych kategoriach. Dla produktów prawidłowych w każdej kategorii powinny być
także zliczane ich pola powierzchni.
4. Opracowanie i implementacje metod prezentacji wyników w formie prezentacji na panelu
operatorskim oraz danych zbiorczych dla całej partii produkcyjnej (pełnej sekwencji). Obraz na
wirtualnym panelu operatorskim powinien zawierać widok ostatniego produktu na linii wraz
z informacją o jego kategorii, kolejnym numerze w całej sekwencji oraz w swojej klasie. Raport
zbiorczy powinien zawierać łączną liczbę przebadanych obiektów, liczbę obiektów w każdej z
klas (6 „prawidłowych” i 1 „wadliwa”). Dla każdej klasy prawidłowej powinien zawierać także
średnią powierzchnię obiektu oraz odchylenie standardowe pola powierzchni.


ATTENTION: 
Unpack archive to get "OKNO_X.avi” file and put it in project folder.

