
--- Nädal 3 grupitöö, roll B - kliendid ilma ostudeta

-- 1. LEFT JOIN: kõik kliendid, ka need kellel pole oste    
SELECT        c.first_name,        c.last_name,        c.email,        c.city,        c.registration_date,        s.sale_id    
FROM customers c    LEFT JOIN sales s ON c.customer_id = s.customer_id    
WHERE s.sale_id IS NULL;
-- VASTUS: kliente, kellel pole ühtegi ostu on kokku 599. 

-- 2. Kadunud kliente kokku 
SELECT COUNT(*) AS kadunud_kliente    
FROM customers c    
LEFT JOIN sales s ON c.customer_id = s.customer_id    
WHERE s.sale_id IS NULL; 
-- VASTUS: kadunud kliente kokku on 599. 

-- 3. Kadunud klientide analüüs linnade kaupa.
SELECT        c.city,      
COUNT(*) AS kadunud_kliente    
FROM customers c    
LEFT JOIN sales s ON c.customer_id = s.customer_id    
WHERE s.sale_id IS NULL    GROUP BY c.city    
ORDER BY kadunud_kliente DESC;
-- VASTUS: analüüs näitab, et kaunud kliente on kõige rohkem tallinnast, so 231, mis teeb 38,6% kogu kadunud klintide hulgast. 
-- Tartust kadunud kliente on 133, mis teeb 22,2% kõigist kadunud klientidest. 
-- Ehk üle poole, so 60,8% on kadunud kliendid Tallinnast ja Tartust. 

-- Uurin registreerimise kuupäeva:
-- Millal kadunud kliendid registreerusid:
SELECT        c.first_name || ' ' || c.last_name AS klient,        c.registration_date,        c.city,        c.loyalty_tier    
FROM customers c    LEFT JOIN sales s ON c.customer_id = s.customer_id    
WHERE s.sale_id IS NULL    
ORDER BY c.registration_date DESC;    
--VASTUS: kadunud kliendid registreerusid kõige varasemalt 2020-01-02 kuni tänaseni. 

-- Võrdlen kadunud vs aktiivsete klientide arvu: 
SELECT        CASE            WHEN s.sale_id IS NULL THEN 'Kadunud (pole ostnud)'            ELSE 'Aktiivne (on ostnud)'        END AS staatus,       
COUNT(DISTINCT c.customer_id) AS kliente    
FROM customers c    LEFT JOIN sales s ON c.customer_id = s.customer_id    
GROUP BY        CASE            WHEN s.sale_id IS NULL THEN 'Kadunud (pole ostnud)'            ELSE 'Aktiivne (on ostnud)'        END;
-- kui kliente on kokku 3150, siis kadunud kliente on kõigist klientidest 19%, ja aktiivseid kes on ostnud 2551 ehk 81%.


-- 599 kadunud kliendil on emaile puudu 79 kadunud kliendil ehk 13,2% on emailid puudu ehk nendele ei saa tervituskampaania emaili saata, saata saame 86,8%-le kadunud klientidest. 
-- kliendiandmete täielikkus, so 13,8% on mittetäielik turunduse tervituskampaania jaoks. -15% allahindlus. 

SELECT 
    COUNT(*) AS puuduvaid_emaile
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL -- Tuvastab "kadunud" kliendid (ostu puudumine) [1]
  AND c.email IS NULL;  -- Filtreerib nende seast need, kellel email puudub [3]

----- kadunud 599, emailid olemas 520, emailid puudu 79
SELECT 
    COUNT(*) AS kadunud_kokku,
    COUNT(c.email) AS emailid_olemas,
    COUNT(*) - COUNT(c.email) AS emailid_puudu
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL;

--- registreerunute arv (kadunud kliendid) aastate lõikes
--- VASTUS: kõige rohkem kadunud kliente on registreerunud 2024 - 293 ja 2025 - 100. 2020-2023 - kokku 206. 
---- 65,6% kadunud klientidest on registreerunud 2024-2025 aastatel. 
---- passiivsed on tekkinud viimasel kahel aastal. 

SELECT 
    EXTRACT(YEAR FROM c.registration_date::DATE) AS registreerimise_aasta, 
    COUNT(*) AS kadunud_klientide_arv
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL
GROUP BY registreerimise_aasta
ORDER BY registreerimise_aasta;

----- Kadunud klientide arv on järsult tõusnud 2024/2023 ehk 80-lt 293-le. 2025 aastal on kadunud klientidest (100) registreerunuid üksnes jaanuar-veebruar. 
--- 2020-2023 kokku 206 klienti, 2024 293 klienti ning 2025 100 klienti (2 kuud jaanuar veebruar). 
SELECT 
    DATE_TRUNC('month', c.registration_date::DATE) AS registreerimis_kuu, 
    COUNT(*) AS kadunud_kliente
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL
GROUP BY registreerimis_kuu
ORDER BY registreerimis_kuu;

/* 

KADUNUD KLIENTIDE ANALÜÜS

Kadunud kliente on kokku 599 (registreerunud aga pole ostnud). See on kriitiline realiseerimata müügipotentsiaal. 
60,8% asub neist Tallinnas ja Tartus, so vastavalt (231) ja (133).
520 kadunud kliendil on olemas e-mailid, mis tähendab, et neile on võimalik koheselt saata tagasikutsumise kampaania -15% allahindlusega. 
Kuna 65,6% kadunud klientidest on registreerunud 2024-2025, siis on lootus, et nad ei ole nö lõplikult passiivsed ning neid on võimalik meelitada aktiivseteks. 
Positiivne on, et aktiivsete klientide osatähtsus on 80%. 


*/