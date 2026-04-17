# UrbanStyle puhastamisraport: Nädal 2

## Müügiandmete puhastamisraport

Teostasin põhjaliku kontrolli testtabelis `sales_test` ja tuvastasin järgmise olukorra:
Tuvastatud kokku 5509 probleemset rida. Äriliselt tähendab see kolme tüüpi andmekvaliteedi probleeme, mis moonutavad kogukäivet ja vajavad kiiret sekkumist!

| Kategooria | Leitud probleeme | Kirjeldus |
| :--- | :---: | :--- |
| Duplikaadid | 4013 | Korduvad `sale_id` väärtused (moonutavad kogukäivet) |
| NULL customer_id | 1487 | Puuduv viide kliendile (takistab kliendianalüüsi) |
| NULL sale_date | 0 | Andmed korras |
| NULL total_price | 0 | Andmed korras |
| Tuleviku kuupäevad | 9 | Kuupäev > tänane (loogikavead) |
| **KOKKU** | **5509** | **Korduvad kirjed ja loogikavead** |

**Järeldus:** 
### Prioriteetide järjekord ja äriline mõju
1.  **`customer_id` puudumine:** (KÕRGE) – Ei saa siduda klienti müügiga, mis teeb võimatuks lojaalsusprogrammide analüüsi.
2.  **Duplikaadid:** (KESKMINE kuni KÕRGE) – Tekitavad ebausaldusväärse pildi kogukäibest, mis on investorite jaoks kriitiline viga.
3.  **Tuleviku kuupäevad:** (MADAL) – Väike arv, lihtne parandada, ei mõjuta suurt pilti.

## Teostatud puhastustegevused


### Duplikaatide, NULL-de eemaldamine
1. Kustutasin 5116 dublikaatset rida, jättes alles vaid iga esimese esinemise (`sale_id` alusel). Tulemuseks on sales_test tabelis 10118 rida ilma dublikaatideta. Kasutasin selleks `DELETE` päringut:

```sql

DELETE FROM sales_test
WHERE id NOT IN (
    SELECT MIN(id)
    FROM sales_test
    GROUP BY sale_id
);

2. Asendasin NULL customer_id number nulliga. 
UPDATE sales_test
SET customer_id = 0
WHERE customer_id IS NULL;

3. Parandasin tuleviku kuupäevad
UPDATE sales_test
SET sale_date = CURRENT_DATE
WHERE sale_date > CURRENT_DATE;

### Kontroll:

1. Kontrollisin, kas on ridu, kus on customer_id NULL - EI OLE!
SELECT
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS null_customer_id,
    COUNT(*) FILTER (WHERE sale_date IS NULL) AS null_sale_date,
    COUNT(*) FILTER (WHERE total_price IS NULL) AS null_total_price
FROM sales_test;


2. kontrollisin, kas on tuleviku kuupäevi - tuleviku kuupäevi EI OLE!
SELECT COUNT(*) AS tuleviku_kuupäevad
FROM sales_test
WHERE sale_date > CURRENT_DATE;