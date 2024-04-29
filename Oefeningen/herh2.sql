-- 1. Op welke planeten verblijft men gemiddeld langer dan 2 dagen?
-- Sorteer op objectnaam.
SELECT h.objectnaam, AVG(b.verblijfsduur) as avg
FROM bezoeken as b INNER JOIN hemelobjecten as h USING(objectnaam)
WHERE h.satellietvan = 'Zon'
GROUP BY h.objectnaam
HAVING AVG(b.verblijfsduur) > 2
ORDER BY h.objectnaam, avg

-- 2. Bereken voor de klant wiens naam begint met G en eindigt met s hoeveel hij in totaal al besteed heeft aan reizen.
SELECT naam, SUM(prijs) as sum
FROM klanten INNER JOIN deelnames USING(klantnr) INNER JOIN reizen USING(reisnr)
WHERE naam like('G%s')
GROUP BY naam

-- 3. Maak een lijst met een overzicht van de reizen met deelnemers. 
-- Geef per reis het aantal deelnemers van elke reis. 
-- Orden de lijst dalend op basis van het aantal deelnemers, als er eenzelfde aantal deelnemers is, moeten deze stijgend geordend worden volgens reisnummer.
select reisnr, count(reisnr) as deelnemers
from reizen
inner join deelnames using(reisnr)
group by reisnr
order by deelnemers desc, reisnr

