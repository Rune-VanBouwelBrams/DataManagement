-- 1. Hoeveel sets zijn er in totaal gewonnen, hoeveel sets werden in totaal verloren en welk is het uiteindelijke saldo?
SELECT SUM(gewonnen) as totaal_gewonnen, SUM(verloren) as totaal_verloren, (SUM(gewonnen) - SUM(verloren)) as saldo
FROM wedstrijden as w

-- 2. Geef een totaal overzicht van alle spelers, hun boetes en de functies die ooit vervuld hebben. 
-- Elke speler moet getoond worden, als ie een eventuele boete heeft gekregen en/of een eventuele functie als bestuurslid heeft gehad dan moet dit ook getoond worden. 
-- Toon de volledige naam, het bedrag en datum van de eventuele boete en de eventuele bestuursfuncties. 
-- Sorteer van voor naar achter.


-- 3. Geef een overzicht van de spelers die een boete hebben gekregen, indien deze boete meer van 90 euro is toon je informatie “pijnlijk” anders “te doen”. 
-- Toen de volledige naam en de categorie van de bijhorende boete. Sorteer van voor naar achter.
SELECT naam, voorletters, concat(case when bedrag > 90 then 'pijnlijk' else 'te doen' end) as comment
FROM spelers as s
INNER JOIN boetes as b ON s.spelersnr = b.spelersnr
ORDER BY 1,2,3