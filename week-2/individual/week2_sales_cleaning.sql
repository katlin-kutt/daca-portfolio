---Grupitöö nr 3 roll A müügiandmete puhastamine

-- praegu sales tabelis ridu - 15234
SELECT Count(*) as ridade_arv 
from sales;

--turvaline koopia 
DROP TABLE sales_test;
CREATE TABLE sales_test as        
SELECT * FROM sales;

CREATE TABLE sales_test AS SELECT * FROM sales;
-- Kontrolli ridade arvu - 15234 

SELECT COUNT(*) AS ridade_arv FROM sales_test;

-- Samm 2. Leia duplikaadid — millised tellimused korduvad? -- 4013 duplikaatset sale_id, kõige suurem koopiate arv 6. 
SELECT sale_id, COUNT(*) AS koopiate_arv
FROM sales_test
GROUP BY sale_id
HAVING COUNT(*) > 1
ORDER BY koopiate_arv DESC;

-- Samm 3. Loe kokku duplikaatsete ridade arv: --5116 rida on duplikaadid
SELECT COUNT(*) AS duplikaat_read
FROM sales_test
WHERE id NOT IN (
    SELECT MIN(id)
    FROM sales_test
    GROUP BY sale_id
);

-- Samm 4. Leia NULL väärtused kriitilistes väljades: 1487 NULL customer_id-d, 0 NULL sale_date, 0 NULL total_price
SELECT
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS null_customer_id,
    COUNT(*) FILTER (WHERE sale_date IS NULL) AS null_sale_date,
    COUNT(*) FILTER (WHERE total_price IS NULL) AS null_total_price
FROM sales_test;

--Samm 5. Kontrolli kuupäevade formaati — kas on tuleviku kuupäevi? jah, tuleviku kuupäevi on 9
SELECT COUNT(*) AS tuleviku_kuupäevad
FROM sales_test
WHERE sale_date > CURRENT_DATE;

SELECT 4013+1487+9

--Samm 6 Puhastamisraport: jätkuvalt 15234 rida. 

--Kontroll
select Count (*)
from sales_test;

--Puhastamise läbiviimine
-- 1. kustutab duplikaadid, jätan alles ainult esimese rea iga sale_id kohta!!!!

DELETE FROM sales_test
WHERE id NOT IN (
    SELECT MIN(id)
    FROM sales_test
    GROUP BY sale_id
);

--1.1 nüüd kontrollin ridade arvu - 10118 ehk 15234 miinus 5116 = 10118
select Count (*)
from sales_test;

--2. asendan NULL customer_id number nulliga. 
UPDATE sales_test
SET customer_id = 0
WHERE customer_id IS NULL;

--kontrollin, kas on ridu kus on customer_id NULL - EI OLE!!!!
SELECT
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS null_customer_id,
    COUNT(*) FILTER (WHERE sale_date IS NULL) AS null_sale_date,
    COUNT(*) FILTER (WHERE total_price IS NULL) AS null_total_price
FROM sales_test;

--3. parandan tuleviku kuupäevad
UPDATE sales_test
SET sale_date = CURRENT_DATE
WHERE sale_date > CURRENT_DATE;

-- kontrollin, kas on tuleviku kuupäevi - tuleviku kuupäevi EI OLE!!!!
SELECT COUNT(*) AS tuleviku_kuupäevad
FROM sales_test
WHERE sale_date > CURRENT_DATE;

-- Kontrollin tervet tulemust: - ridu 10118
SELECT COUNT(*) AS ridu_parast FROM sales_test;

-----------------------------------------------------------------------------

--Ülesande kaart B - kliendiandmete puhastamine

--1. kontrollin customers_test ridade arvu - 3150 
SELECT COUNT(*) AS ridade_arv FROM customers_test;


-- 2. duplikaatsed emailid ---------------------------neid on kokku 128 v.a NULLid rida
SELECT email, COUNT(*) AS koopiate_arv
FROM customers_test
GROUP BY email
HAVING COUNT(*) > 1
ORDER BY koopiate_arv DESC;

--3. leian puuduvad nimed: null_eesnimi 0, null_perenimi_null
SELECT
    COUNT(*) FILTER (WHERE first_name IS NULL OR first_name = '') AS null_eesnimi,
    COUNT(*) FILTER (WHERE last_name IS NULL OR last_name = '') AS null_perenimi
FROM customers_test;

--4. kontrollin linnade nimekujusid, kas on ebajärjekindlusi? 54 erinevat
SELECT city, COUNT(*) AS arv
FROM customers_test
GROUP BY city
ORDER BY city;

--5. kontrollin kontaktandmeid - puuduvad telefoninumbrid ja e-mailid: null telefoni, NULL emaili 380
SELECT
    COUNT(*) FILTER (WHERE phone IS NULL OR phone = '') AS null_telefon,
    COUNT(*) FILTER (WHERE email IS NULL OR email = '') AS null_email
FROM customers_test;

SELECT city, COUNT(*) FROM customers_test
GROUP BY city HAVING COUNT(*) > 1;

-- Puhastamine, asendamine
--1. asendan NULL-id
UPDATE customers_test
SET first_name = 'Tundmatu'
WHERE first_name IS NULL OR first_name = '';

UPDATE customers_test
SET last_name = 'Tundmatu'
WHERE last_name IS NULL OR last_name = '';

SELECT COUNT(*) 
FROM customers_test 
WHERE last_name = 'Tundmatu';


--2. emailid on NULLID - 380
SELECT COUNT(*) 
FROM customers_test 
WHERE email IS NULL;

--2.1 update NULLIDELE emailis - nüüd null
UPDATE customers_test
SET email = 'Tundmatu_email'
WHERE email IS NULL OR email = '';

--2.2 kordan päringut customer tabeli kohta 
SELECT
    COUNT(*) FILTER (WHERE first_name IS NULL OR first_name = '') AS null_eesnimi,
    COUNT(*) FILTER (WHERE last_name IS NULL OR last_name = '') AS null_perenimi,
    count(*) FILTER (WHERE email IS NULL OR email = '') AS null_email
FROM customers_test;

select count (*)
FROM customers_test,
WHERE email = 'Tundmatu_email';

SELECT 
    COUNT(*) AS asendatud_arv,
    (SELECT COUNT(*) FROM customers_test WHERE email IS NULL OR email = '') AS jaak_nullid
FROM customers_test 
WHERE email = 'Tundmatu_email';

SELECT customer_id, first_name, last_name, email 
FROM customers_test 
WHERE email = 'Tundmatu_email'
LIMIT 10;

SELECT customer_id, first_name, last_name, email
FROM customers_test
WHERE email IS NULL OR email = '';

SELECT COUNT(*) AS puuduvate_emailide_arv
FROM customers_test
WHERE email IS NULL OR email = 'Tundmatu_email';

--3. Ühtlustan linnanimed INITCAP + TRIM
UPDATE customers_test
SET city = INITCAP(TRIM(city))
WHERE city != INITCAP(TRIM(city));

SELECT city
FROM customers_test;

-- 3.1 standardiseeri emailid väiketähtedeks
UPDATE customers_test
SET email = LOWER(TRIM(email))
WHERE email != LOWER(TRIM(email));

-- 3.2 Kontrollin tulemust - linnanimesid on unikaalseid 12. 
SELECT city, COUNT(*) AS arv
FROM customers_test
GROUP BY city ORDER BY city;

SELECT COUNT(DISTINCT city) AS unikaalsed_linnad
FROM customers_test;

--3.3 standardiseeri telefoninumbrid
SELECT phone,
    CASE
        WHEN phone LIKE '+372%' THEN phone
        WHEN phone LIKE '372%' THEN '+' || phone
        WHEN LENGTH(phone) = 7 THEN '+372' || phone
        ELSE phone
    END AS standardne_telefon
FROM customers_test
WHERE phone IS NOT NULL
LIMIT 10;

-- Ülesande C kaart - tooteandmete puhastamine
-- enne products tabelis ridu - 362
SELECT COUNT(*) AS ridade_arv FROM products;

--1. loon testkoopia products tabelist

CREATE TABLE products_test AS SELECT * FROM products;
SELECT COUNT(*) AS ridade_arv FROM products_test;

--1.2  leian duplikaadid - korduvad tootenimed - neid on 12.
SELECT product_name, COUNT(*) AS koopiate_arv
FROM products_test
GROUP BY product_name
HAVING COUNT(*) > 1
ORDER BY koopiate_arv DESC;

--1.3 leian NULL väärtused kriitilistes väljades - product_name, category, omahind ja jaehind

SELECT COUNT(*) AS ridade_arv FROM products;

SELECT * FROM products_test;

SELECT
    COUNT(*) FILTER (WHERE product_name IS NULL OR product_name = '') AS null_nimi,
    COUNT(*) FILTER (WHERE category IS NULL OR category = '') AS null_kategooria,
    COUNT(*) FILTER (WHERE retail_price IS NULL) AS null_jaehind,
    COUNT(*) FILTER (WHERE cost_price IS NULL) AS null_omahind
FROM products_test;

--1.4 kontrollin loogilisi vigu, kas on ebareaalseid hindu? negatiivset omahinda ei ole. 
--1.4.1 negatiivsed hinnad
SELECT COUNT(*) AS negatiivne_omahind
FROM products_test
WHERE cost_price < 0;

--1.5 äärmuslikud hinnad nii omahinnad kui ka jaehinnad > 1000.- - selliseid ei ole. 
SELECT product_name, cost_price
FROM products_test
WHERE cost_price > 1000
ORDER BY cost_price DESC;

SELECT product_name, retail_price
FROM products_test
WHERE retail_price > 1000
ORDER BY retail_price DESC;

--1.6 kontrollin kategooriate järjekindlust - ei ole erineviad kujusid. 
SELECT category, COUNT(*) AS arv
FROM products_test
GROUP BY category
ORDER BY category;

-- kategooriatel ei ole puuduvaid väärtusi. 
SELECT category
FROM products_test
WHERE category is NOT NULL;

--- 5 erinevat kategooriat
SELECT category, COUNT(*)
FROM products_test
GROUP BY category;

SELECT count (DISTINCT category)
FROM products_test;

SELECT
Count(*) AS Ridade_Arv,
Count(DISTINCT category) AS Unikaalseid_kategooriaid,
Count(*) - Count(distinct category) AS Duplikaate
FROM products_test;

SELECT category, COUNT(*)
FROM products_test
GROUP BY category;

-- eco sertifikaat on NULL ehk puudu 18 real - 
SELECT eco_certified
FROM products_test
WHERE eco_certified IS NULL;

SELECT product_id, product_name, supplier, eco_certified
FROM products_test 
WHERE eco_certified IS NULL;

-- asendan eco sertifikaadi 18 rida, FALSE-ga 
UPDATE products_test 
SET eco_certified = FALSE 
WHERE eco_certified IS NULL;

-- ühtlustan kategooriate nimed kuigi ei ole vaja, on neid ikka 5
UPDATE products_test
SET category = INITCAP(TRIM(category))
WHERE category != INITCAP(TRIM(category));

-- eemaldan product name duplikaadid mida oli 12 

--algselt - 362
SELECT product_name, COUNT(*)
FROM products_test
GROUP BY product_name;


DELETE FROM products_test
WHERE product_name NOT IN (
    SELECT MIN(product_name)
    FROM products_test
    GROUP BY product_name
);

SELECT product_name, COUNT(*)
FROM products_test
GROUP BY product_name;

SELECT
Count(*) AS Ridade_Arv,
Count(DISTINCT product_name) AS Unikaalseid_tootenimesid,
Count(*) - Count(distinct product_name) AS Duplikaate
FROM products_test;


-- lisan case when kategooriate standardiseerimiseks.
UPDATE products_test
SET category = CASE
    WHEN LOWER(TRIM(category)) IN ('shoes', 'jalanõud', 'footwear') THEN 'Shoes'
    WHEN LOWER(TRIM(category)) IN ('shirts', 'särgid', 'tops') THEN 'Shirts'
    WHEN LOWER(TRIM(category)) IN ('pants', 'püksid', 'trousers') THEN 'Pants'
    ELSE INITCAP(TRIM(category))
END;

-- ÜLESANNE KAART D - ristvalideerimine ja kvaliteedikontroll - ridade arv 350
SELECT COUNT(*) AS ridade_arv FROM products_test;

-- kontrollin kas kõik müügis viidatud kliendid eksisteerivad
-- 1. ORBID müügid - kas on customer_id, mida pole customer tabelis. orbkliente on 0
SELECT COUNT(*) AS orb_klient
FROM sales s
LEFT JOIN customers c ON s.customer_id = c.customer_id
WHERE c.customer_id IS NULL AND s.customer_id IS NOT NULL;

--2. kontrolli, kas kõik müügis viidatud tooted eksisteerivad
-- orbid müügid, kas product_id mida pole products tabelis - neid on 0
SELECT COUNT(*) AS orb_toode
FROM sales s
LEFT JOIN products p ON s.product_id = p.product_id
WHERE p.product_id IS NULL AND s.product_id IS NOT NULL;

--3. kontrolli hindade kooskõla - kas müügihind ja tootehind klapivad. 664 real ei klapi!

SELECT s.sale_id, s.total_price, p.retail_price AS tootehind, s.quantity,
       s.total_price - (p.retail_price * s.quantity) AS erinevus
FROM sales s
JOIN products p ON s.product_id = p.product_id
WHERE ABS(s.total_price - (p.retail_price * s.quantity)) > 1
ORDER BY ABS(s.total_price - (p.retail_price * s.quantity)) DESC
LIMIT 20;

WITH muugi_kontroll AS (
    SELECT s.sale_id, s.total_price, p.retail_price AS tootehind, s.quantity,
           s.total_price - (p.retail_price * s.quantity) AS erinevus
    FROM sales s
    JOIN products p ON s.product_id = p.product_id
)
SELECT *
FROM muugi_kontroll
WHERE ABS(erinevus) > 1
ORDER BY ABS(erinevus) DESC
;

-- 4. kontrolli kas on kliente kes pole kunagi ostnud - neid on 592
SELECT COUNT(*) AS vaimkliendid
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.customer_id IS NULL;

--5. kontrollin kas on tootedi mida pole kunagi müüdud - 12 vaimtoodet
SELECT COUNT(*) AS vaimtooted
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.product_id IS NULL;

-- loetelu nendest 12 tootest mis pole kunagi müünud. 
SELECT 
    p.product_id, 
    p.product_name, 
    p.category
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.product_id IS NULL;

-- LEFT JOIN näitab ka need read, kust vastet EI leita. 1487
SELECT COUNT(*) FROM sales s
LEFT JOIN customers c ON s.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- millistel toodetel on suurimad hinnaerinevused - tallinn, tartu ja online poodides. 

SELECT 
    p.product_name, 
    p.retail_price AS listi_hind, 
    s.unit_price AS tegelik_muugihind,
    ABS(p.retail_price - s.unit_price) AS hinnaerinevus,
    s.sale_date,
    s.store_location
FROM products p
JOIN sales s ON p.product_id = s.product_id
WHERE ABS(p.retail_price - s.unit_price) > 0
ORDER BY hinnaerinevus DESC
LIMIT 10;

SELECT channel, COUNT(*) 
FROM sales_test 
WHERE store_location IS NULL 
GROUP BY channel;

--kontroll mitu rida on sales_test tabelis
SELECT Count(*) as ridade_arv 
from sales_test;

SELECT Count(*) as ridade_arv 
from sales;