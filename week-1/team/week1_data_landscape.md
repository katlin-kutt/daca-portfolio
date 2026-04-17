# Meeskonna kokkuvõte: Nädal 1 - Andmemaastiku analüüs
**Osakond:** UrbanStyle Turundusanalüüsi osakond

## 1. Tabelite ülevaade ja tehniline seisund

### Müügiandmed
*   **Maht:** 15 234 rida ja 12 veergu.
*   **Kriitilised leiud:**
    *   **Puuduvad andmed:** 1487 real puudub kliendi info (`customer_id` on NULL).
    *   **Anomaaliad:** Tuvastatud negatiivsed tehingusummad, mis viitavad vigadele või süsteemsetele tagastustele.
    *   **Kanalite jaotus:** Unikaalseid kanaleid on 2 (online ja e-pood).
    *   **Asukohtade analüüs:** Kokku 3 füüsilist poodi (Tallinn, Pärnu, Tartu) ning "NULL", mis tähistab veebimüüki.
    *   **Duplikaatide muster:** Tartus tuvastati 279 sularahamaksete duplikaati (unikaalseid arveid 557 vs tehinguid 836). Kogu tabelis on hinnanguliselt ~5000 duplikaati. 

### Kliendiandmed
*   **Maht:** 3150 rida ja 9 veergu.
*   **Andmekvaliteedi probleemid:**
    *   **Erinev vorming:** Linnade nimetused on erineva vorminguga, mis tekitab dubleerivaid koondtulemusi ja takistab täpset filtreerimist.
    *   **Puuduvad kontaktid:** 380 kliendil puudub e-mail.
    *   **Duplikaadid:** Tuvastatud 510 duplikaatset e-maili aadressi.

### Tooteandmed
*   **Maht:** 362 rida ja 9 veergu.
*   **Seisund:** Andmed on komplektsed, puuduvaid väärtusi ei esine.
*   **Hinnad:** Ostuhinnad vahemikus 10–346 €; müügihinnad 13–434 €.

## 2. Peamised järeldused

*   **Suurim üllatus:** NULL-väärtus ei pruugi alati tähendada viga, vaid võib kanda sisulist infot (nt `store_location` NULL tähendab online-kanalit).
*   **Andmekaos:** Hetkel on UrbanStyle'i andmed ebausaldusväärsed ja vajavad puhastamist.

## 3. Otsused ja soovitused

1.  **Andmesisestuse piirangud:** Rakendada kriitilistele veergudele `NOT NULL` piirangud, et vältida tühje kirjeid tulevikus.
2.  **Standardiseerimine:** Ühtlustada tekstivormingud (eriti linnade nimed) ja integreerida andmeallikad ühtsesse süsteemi.
3.  **Tehniline lahendus duplikaatidele:** Kasutada unikaalseid indekseid uute andmete lisamisel:
    `CREATE UNIQUE INDEX sale_id_unique_index ON sales (sale_id);`.
4.  **Andmepuhastus:** Algatada kohene duplikaatide eemaldamise protsess, et tagada raportite tõesus.