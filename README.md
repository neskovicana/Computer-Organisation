Magicna sekvenca brojeva je sekvenca brojeva duzine 2^n 
za koju vazi: Svaki integer u njoj pripada [0, 2^n - 1], 
Prvi integer je 0, Svaki integer pojavljuje se samo jednom, 
Binarna reprezentacija svaka dva susedna para integera 
razlikuje se tacno za 1 bit, i Binarna reprezentacija prvog 
i poslednjeg elementa  razlikuje se tacno za 1 bit. PS. Razlika
se ne odnosi na aritmeticku razliku vec na razliku u zapisu broja.

Primer:
Ulaz: n = 2
Izlaz: [0,1,3,2]
Objasnjenje: Binarna reprezentacije [0,1,3,2] je [00,01,11,10].
- 00 i 01 se u zapisu razlikuju za 1 bit (jedinica u drugom broju)
- 01 i 11 se u zapisu razlikuju za 1 bit (prva cifra kod oba broja)
- 11 i 10 se u zapisu razlikuju za 1 bit
- 10 i 00 se u zapisu razlikuju za 1 bit Slicno, [0,2,3,1] je takode magicna sekvenca ciji je zapis [00,10,11,01].
- 00 i 10 se u zapisu razlikuju za 1 bit
- 10 i 11 se u zapisu razlikuju za 1 bit
- 11 i 01 se u zapisu razlikuju za 1 bit
- 01 i 00 se u zapisu razlikuju za 1 bit 

Napisati funkciju koja za uneto n ispisuje bar jednu magicnu sekvencu.
