-- 1. Geef het totaal aantal boetes, het totale boetebedrag, het minimum en het maximum boetebedrag dat door onze club betaald werd. 
-- Let er hierbij op dat er gehele getallen worden getoond (rond af indien nodig). 
-- Sorteer van voor naar achter, oplopend. 
-- Deze opgave behoeft geen subquery.
select count(betalingsnr) as aantal_boetes, cast(sum(bedrag) as int) as totaal_bedrag, cast(min(bedrag) as int) as minimum, cast(max(bedrag) as int) as maximum
from boetes

-- 2. Geef voor elke aanvoerder het spelersnr, de naam en het aantal boetes dat voor hem of haar betaald is en het aantal teams dat hij of zij aanvoert. 
-- Toon enkel aanvoerders die boetes gekregen hebben. 
-- Sorteer van voor naar achter, oplopend.
SELECT s.spelersnr, naam, voorletters, aantalboetes, aantalteams
FROM spelers as s 
INNER JOIN (
	SELECT COUNT(teamnr) as aantalteams, spelersnr
	FROM teams
	GROUP BY spelersnr
) as aanv ON s.spelersnr = aanv.spelersnr 
INNER JOIN (
	SELECT COUNT(*) as aantalboetes, spelersnr
	FROM boetes
	GROUP BY spelersnr
) as bps ON s.spelersnr = bps.spelersnr
ORDER BY 1, 2, 3, 4, 5

-- 3. Geef een lijst met het spelersnummer en de naam van de spelers die in Rijswijk wonen en die in 1980 een boete gekregen hebben van 25 euro (meerdere voorwaarden dus). 
-- Gebruik hiervoor geen exists operator maar wel zijn tegenhanger die meestal bij niet-gecorreleerde subquery's wordt gebruikt. 
-- Sorteer van voor naar achter, oplopend.
SELECT s.spelersnr, s.naam
FROM spelers as s, boetes 
WHERE EXTRACT(YEAR FROM boetes.datum) = 1980 
AND s.plaats = 'Rijswijk' 
AND s.spelersnr IN (boetes.spelersnr) 
ORDER BY s.spelersnr

-- 4. Geef alle spelers voor wie meer boetes zijn betaald dan dat ze wedstrijden hebben gespeeld. 
-- Zorg dat spelers zonder wedstrijd ook getoond worden.
-- Sorteer van voor naar achter, oplopend.
SELECT s.naam, s.voorletters, s.geb_datum
FROM spelers s
LEFT OUTER JOIN (
    SELECT spelersnr, COUNT(*) AS aantal_gespeeld
    FROM wedstrijden
    GROUP BY spelersnr
) AS w ON s.spelersnr = w.spelersnr
LEFT OUTER JOIN (
    SELECT spelersnr, COUNT(*) AS boetes_betaald
    FROM boetes
    GROUP BY spelersnr
) AS b ON s.spelersnr = b.spelersnr
WHERE boetes_betaald > aantal_gespeeld
ORDER BY 1, 2, 3

-- 5. Geef alle spelers die geen wedstrijd voor team 1 heeft gespeeld. 
-- Sorteer op naam, daarna op nr.
SELECT s.spelersnr, naam
FROM spelers as s
LEFT OUTER JOIN(
	SELECT spelersnr, teamnr
	FROM wedstrijden
	GROUP BY spelersnr, teamnr
) as w ON s.spelersnr = w.spelersnr
WHERE w.teamnr <> 1
ORDER BY 2, 1

-- 6. Geef voor elke speler die ooit een boete heeft betaald, de hoogste boete weer en hoelang het geleden is dat deze boete werd betaald. 
-- Sorteer van groot naar klein op bedrag en daarna omgekeerd op “leeftijd..” van de boete.
