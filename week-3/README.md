# Nädal 2: SQL JOINs -- UrbanStyle'i andmete ühendamine

## Mida ma tegin
- Õppisin ühendama erinevaid andmetabeleid (nt customers, sales, products), et leida seoseid, mis on peidus killustatud andmetes.
- Kasutasin erinevaid JOIN-tüüpe vastavalt ülesandele: INNER JOIN sobivate paaride leidmiseks ja LEFT JOIN, et tuvastada nö "vaimkliendid" ehk registreerunud kliendid, kes pole kunagi ostnud.
- Ühendades kliendi ja müügi tabeleid, uurisin kadunud kliente.
- Rakendasin tabelite aliaseid (nt s, c, p), et muuta keerukad päringud loetavamaks.
- Osalesin meeskonnatöös, kus ma analüüsisin kadunud kliente ja koostasin sellekohase koondraporti.
- Vormistasin oma nädala töö GitHubi portfoolios.

## Peamised õppetunnid
- Selgus vahe Primary Key (unikaalne tunnus tabelis) ja Foreign Key (viide teise tabeli unikaalsele tunnusele) vahel, mis on tabelite ühendamise alus.
- Selgus, kuidas erinevad JOIN-id filtreerivad tulemusi – INNER JOIN annab vaid kattuvuse, LEFT JOIN aga säilitab kogu vasakpoolse tabeli info.
- Mõistsin, kui oluline on tõlkida numbrid äriliseks oluliseks infoks – näiteks "kadunud klientide" leidmine ja selle monitoorimine ja hiljem turundustegevustes kasutamine võidab nö kadunud müüki. 


## Failid
- **[week3_roll_b_kadunud_kliendid.sql](individual/week3_roll_b_kadunud_kliendid.sql)** – Kadunud klientide JOIN-analüüs SQL päringud koos selgitavate kommentaaridega
- **[week3_results_join-1.PNG](individual/week3_results_join-1.PNG)** – kadunud kliendid ülevaade
- **[week3_results_join-2.PNG](individual/week3_results_join-2.PNG)** – kadunud kliendid linnade lõikes kuvatõmmis
- **[week3_results_join-3.PNG](individual/week3_results_join-3.PNG)** – aktiivsete ja kadunud klientide arv kuvatõmmis
- **[week3_results_join-4.PNG](individual/week3_results_join-4.PNG)** – kadunud klientide emailide olemasolu kuvatõmmis


## Meeskonna töö
- **[week3_team_summary.md](team/week3_team_summary.md)** – meeskonna ühine tulemuste ülevaade