--   Müügikanalite uurija (roll D, Sales Dimensions Explorer)

--   Ülesanne 
Millised müügikanalid on olemas? 
Millistes kauplustes müüakse? 
Milliseid makseviise kasutatakse? 
Kas on tehinguid ilma asukoha infota?

SELECT channel, store_location, payment_method
FROM sales
LIMIT 10;

---- Urbanstyle kasutab 2 müügikanalit - online ja pood. 

SELECT channel
FROM sales;

SELECT distinct channel
FROM sales;

---- UrbanStyle kaupluste asukohad on järgmised: Tallinn, Pärnu ja Tartu. NB! Asukohtade seas on ka null mis tähendab, et asukoht on väärtusena puuduv!!!
KOkku on asukoht määramata - 5204 rida!

SELECT distinct store_location
FROM sales;

SELECT * FROM sales WHERE store_location IS NULL;

---- UrbanStyle kliendid kasutavad järgmiseid makseviise: järelmaks, kaart, sularaha. NB! Puuduvaid väärtusi ei ole!

SELECT distinct payment_method
FROM sales;

---- Tehingud, mis on tehtud läbi online'i, kokku 5204 ning nendel kõigil on store_location null ehk täitmata, mis ühtlasi tähendab ka seda, et 34,16% müügist toimub onlines ehk veebis. 
Ehk siin on tegu sellega, et kui channel on online siis see võrdub ühtlasi ka veebiostuga. Ehk tulevikus võib ju tekitada tingimuse, et kui channel on online siis store_location ka veeb ehk online võrdub veeb. Nii saaksime nullist lahti. 

SELECT * 
FROM sales 
WHERE channel = 'online'
ORDER BY total_price DESC
LIMIT 15;

SELECT * 
FROM sales 
WHERE channel = 'online';


---- Tehingud, mis on ilma kaupluse asukoha infota: 5204 tehingut

SELECT COUNT(*) AS puuduv_asukoht FROM sales WHERE store_location IS NULL;

-- Kokkuvõte: 
UrbanStylel on olemas müügikanalitena online ja pood. 
Poodide asukohtadeks on: Tallinn, Tartu ja Pärnu. 
Makseviisidena on kasutusel: järelmaks, sularaha ja kaart. 
5204 tehingut on ilma asukoha väärtuseta!
Üllatav oli see, et 15234 reast ehk tehingust 5204 tehingut on ilma asukoha väärtuseta, mis teeb 34,16% kogu tehingute arvust. Info store_location lahtris lihtsalt puudub, andmed on täitmata jäänud ehk müükide tegemisel pole kaasa tulnud asukoha info.

--- Tehingud kokku iga kaupluse asukoha kohta.
Tartu pood 2708 tehingut
Pärnu pood 1618 tehingut
Tallinna pood 5704 tehingut
Veeb ehk online pood, kus store location on null: 5204



SELECT * FROM sales WHERE store_location = 'Tartu';
SELECT * FROM sales WHERE store_location = 'Pärnu';
SELECT * FROM sales WHERE store_location = 'Tallinn';

SELECT * 
FROM sales 
WHERE channel = 'online';

SELECT store_location, SUM(total_price) AS kogukäive
FROM sales
GROUP BY store_location;

SELECT store_location, COUNT(*) AS tehingute_arv
FROM sales
GROUP BY store_location;

-- Online vs pood tehingute arvu võrdlus kanalite järgi: 5204 ja 10030 ehk 34,16% müügist online ja 65,84% pood. 

SELECT COUNT (*) online_tehinguid FROM sales WHERE channel = 'online';
SELECT COUNT (*) online_tehinguid FROM sales WHERE channel = 'pood';


SELECT channel, COUNT(*) AS tehingute_arv
FROM sales
GROUP BY channel;

-- Sularahamaksed Tartus - 836 müüki teostatud sularahaga, sealjuures unikaalsete arve nr-tega on 557 - see tähendab, et invoice id on ka duplikaatidega ehk 279 on duplikaadid. 

SELECT * FROM sales WHERE store_location = 'Tartu' LIMIT 10;
SELECT DISTINCT store_location FROM sales;

SELECT DISTINCT payment_method 
FROM sales;

SELECT COUNT(*) FROM sales WHERE payment_method IS NULL;

SELECT * 
FROM sales 
WHERE store_location = 'Tartu' 
  AND payment_method = 'sularaha';

SELECT COUNT(DISTINCT invoice_id) FROM sales WHERE store_location = 'Tartu' AND payment_method = 'sularaha';