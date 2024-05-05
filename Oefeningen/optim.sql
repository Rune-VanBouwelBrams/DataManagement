-- 1. Geef een lijst met het spelersnummer en de naam van de speler die in Rijswijk wonen en die in 1980 een boete gekregen hebben van 25 euro. 
-- Sorteer van voor naar achter.
-- Probeer gelijk of beter te doen dan "(cost=2.37..2.37 rows=1 width=68)".
SELECT s.spelersnr, s.naam
FROM spelers as s, boetes 
WHERE EXTRACT(YEAR FROM boetes.datum) = 1980 
AND s.plaats = 'Rijswijk' 
AND s.spelersnr IN (boetes.spelersnr) 
ORDER BY s.spelersnr

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
SELECT spelersnr, naam, voorletters, (avg(jaartoe) - jaartoe) as verschil
FROM spelers
GROUP BY spelersnr, naam, voorletters, jaartoe
ORDER BY 1,2,3,4

-- 4. 