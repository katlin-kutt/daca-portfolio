# Meeskonna koondraport: Nädal 2 - Andmete puhastamine
**Osakond:** UrbanStyle Turundusanalüüsi osakond

## 1. Müügiandmete tabel
Tuvastati **5509 probleemset rida**. Äriliselt tähendab see kolme tüüpi andmekvaliteedi probleeme, mis moonutavad UrbanStyle'i kogukäivet ja vajavad kiiret sekkumist.

| Kategooria | Leitud probleeme | Kirjeldus |
| :--- | :---: | :--- |
| Duplikaadid | 4013 | Korduvad `sale_id` väärtused (moonutavad kogukäivet) |
| NULL customer_id | 1487 | Puuduv viide kliendile (takistab kliendianalüüsi) |
| NULL sale_date | 0 | Andmed korras |
| NULL total_price | 0 | Andmed korras |
| Tuleviku kuupäevad | 9 | Kuupäev > tänane (loogikavead) |
| **KOKKU** | **5509** | **Korduvad kirjed ja loogikavead** |

### Prioriteetide järjekord ja äriline mõju
1.  **`customer_id` puudumine:** (KÕRGE) – Ei saa siduda klienti müügiga, mis teeb võimatuks lojaalsusprogrammide analüüsi.
2.  **Duplikaadid:** (KESKMINE kuni KÕRGE) – Tekitavad ebausaldusväärse pildi kogukäibest, mis on investorite jaoks kriitiline viga.
3.  **Tuleviku kuupäevad:** (MADAL) – Väike arv, lihtne parandada, ei mõjuta suurt pilti.

---

## 2. Kliendiandmete tabel
Tuvastati **562 probleemset rida**. Puuduvate emailidega kliendid on sisuliselt anonüümsed kliendid, kelle puhul pole selge, kui paljud neist on erinevad inimesed ning kellele ei saa muuhulgas ka e-posti teel teateid saata. Duplikaatsete e-mailidega kliendid moonutavad statistilisi andmeid oste sooritanud klientide arvu kohta ning näiteks ka seda, kui palju kliente erinevates linnades tegelikult on.

| Kategooria | Leitud probleeme | Kirjeldus |
| :--- | :---: | :--- |
| Duplikaatsed e-mailid | 128 | Sama e-mail mitmel kliendil (moonutab klientide arvu) |
| NULL eesnimi/perenimi | 0 | Andmed korras |
| Ebajärjekindlad linnanimed | 54 | Erinevad nimekujud (nt tallinn vs Tallinn) |
| NULL e-mail | 380 | Puuduvad kontaktandmed (anonüümsed kliendid) |
| **KOKKU** | **562** | |

---

## 3. Tooteandmete tabel
Tuvastati **12 probleemset rida**. Tooteanalüüsi suurim takistus on tootenimede dubleerimine.

| Kategooria | Leitud probleeme | Kirjeldus |
| :--- | :---: | :--- |
| Duplikaatsed nimed | 12 | Sama tootenimi esineb mitu korda |
| NULL nimi/hind | 0 | Andmed korras |
| Loogilised vead | 0 | Negatiivsed või äärmuslikud hinnad puuduvad |
| Ebajärjekindlad kategooriad | 0 | Kategooriate nimekujud on konsistentsed |
| NULL kategooria | 0 | Klassifitseerimine on täielik |
| **KOKKU** | **12** | |
