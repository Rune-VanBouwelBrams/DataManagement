-- 1. Geef een lijst met het spelersnummer en de naam van de speler die in Rijswijk wonen en die in 1980 een boete gekregen hebben van 25 euro. 
-- Sorteer van voor naar achter.
-- Probeer gelijk of beter te doen dan "(cost=2.37..2.37 rows=1 width=68)".
SELECT spelersnr, naam
FROM spelers INNER JOIN boetes USING (spelersnr)
WHERE extract(YEAR FROM datum) = '1980' AND plaats = 'Rijswijk' AND  bedrag = 25
ORDER BY 1, 2

-- 2. Geef de naam en het spelersnummer van de spelers die ooit penningmeester geweest zijn van de club, die bovendien ooit een boete betaald hebben van meer dan 75 euro, en die ooit een wedstrijd gewonnen hebben met meer dan 2 sets verschil. 
-- Sorteer van voor naar achter.
-- Probeer gelijk of beter te doen dan "Unique (cost=100.38..100.54 rows=21 width=68)".
SELECT naam, s.spelersnr
FROM spelers as s 
	LEFT OUTER JOIN bestuursleden as be ON s.spelersnr = be.spelersnr
	LEFT OUTER JOIN boetes as b ON be.spelersnr = b.spelersnr
	LEFT OUTER JOIN wedstrijden as w ON b.spelersnr = w.spelersnr
WHERE functie = 'Penningmeester' and  bedrag > 75 and ((gewonnen - verloren) > 2 or (verloren - gewonnen) > 2)
ORDER BY 1, 2

-- 3. Geef van elke speler het spelersnr, de naam en het verschil tussen zijn of haar jaar van toetreding en het gemiddeld jaar van toetreding. 
-- Sorteer van voor naar achter.
-- Probeer gelijk of beter te doen dan "Sort (cost=33.16..33.66 rows=200 width=86)"
SELECT spelersnr, naam, voorletters, jaartoe - (SELECT AVG(jaartoe) FROM spelers) as verschil
FROM spelers
ORDER BY 1,2,3,4

-- 4. Je kan per speler berekenen hoeveel boetes die speler heeft gehad en wat het totaalbedrag per speler is. 
-- Pas nu deze querie aan zodat per verschillend aantal boetes wordt getoond hoe vaak dit aantal boetes voorkwam. 
-- Sorteer van voor naar achter.
-- Probeer gelijk of beter te doen dan "Sort (cost=46.39..46.89 rows=200 width=8)".
SELECT a, count(a) count
FROM (
	SELECT COUNT(*) a
	FROM boetes
	GROUP BY spelersnr
) aantallen
GROUP BY a
ORDER BY 1,2

-- 5. Geef van alle spelers het verschil tussen het jaar van toetreding en het geboortejaar, maar geef alleen die spelers waarvan dat verschil groter is dan 20. 
-- Sorteer van voor naar achter.
-- Probeer zo goed of beter te doen dan "Sort (cost=17.20..17.37 rows=67 width=90)"
SELECT spelersnr, naam, voorletters, (jaartoe - EXTRACT(YEAR FROM geb_datum)) as toetredingsleeftijd
FROM spelers
WHERE (jaartoe - extract(YEAR FROM geb_datum)) > 20
ORDER BY 1,2,3,4

-- 6. Geef alle spelers die alfabetisch (dus naam en voorletters, in deze volgorde) voor speler 8 staan. 
-- Sorteer van voor naar achter.
-- Probeer zo goed of beter te doen dan "Sort (cost=24.31..24.47 rows=67 width=88)"
SELECT spelersnr, naam, voorletters, geb_datum
FROM spelers WHERE naam < (SELECT naam FROM spelers WHERE spelersnr = 8)
ORDER BY 1,2,3,4