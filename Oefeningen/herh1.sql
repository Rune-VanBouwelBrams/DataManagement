-- 1. Geef voor alle huidige bestuurleden hun functie en de lijst van boetes die voor hen werd betaald.
-- Omdat je dit wil vergelijken met de boetebedragen die betaald werden voor leden die niet in het bestuur zitten, wil je deze boetebedragen ook opnemen in de tweede kolom van je resultaat.
-- Sorteer je antwoord eerst op functie en daarna op het boetebedrag.
SELECT	functie, bedrag
FROM	bestuursleden FULL OUTER JOIN boetes
USING	(spelersnr)
WHERE	eind_datum is null
ORDER BY functie, bedrag

-- 2. Geef voor elke mannelijke speler wiens naam minstens 2 keer de letter 'e' bevat zijn functie die hij op dit moment uitoefent, als die er op dit moment één heeft.
-- Sorteer op naam en functie.
SELECT s.naam, s.geslacht, bs.functie
FROM spelers AS s
LEFT OUTER JOIN bestuursleden AS bs ON bs.spelersnr = s.spelersnr AND bs.eind_datum IS NULL
WHERE s.naam LIKE '%e%e%' AND s.geslacht = 'M'
ORDER BY naam, functie

-- 3. Geef alle spelers die geen boete gekregen hebben en niet in Den Haag wonen.
-- Sorteer op jaar van toetreden nr en verder op de volgende kolommen.
SELECT s.spelersnr, naam, plaats 
FROM boetes b RIGHT OUTER JOIN spelers s 
	ON s.spelersnr = b.spelersnr
WHERE plaats!='Den Haag' AND bedrag IS NULL
ORDER BY jaartoe, spelersnr

-- 4. Geef per team de verloren wedstrijden. Zorg dat teams zonder verloren wedstrijden ook in de output verschijnen.
-- Duid per wedstrijd aan of het om een actief bestuurslid gaat.
-- Sorteer op divisie en wedstrijdnummer.
SELECT te.teamnr, divisie, wedstrijdnr, w.spelersnr,
CASE WHEN functie IS NOT NULL THEN 'actief' 
ELSE '-' 
END AS bestuurslid 
FROM teams as te LEFT OUTER JOIN wedstrijden as w ON te.teamnr = w.teamnr AND verloren > gewonnen LEFT OUTER JOIN bestuursleden as b ON b.spelersnr = w.spelersnr AND eind_datum IS NULL 
ORDER BY divisie, w.wedstrijdnr

-- 5. Geef een alfabetisch gesorteerde lijst van de namen van alle leden van de tennisvereniging die nog geen wedstrijden gespeeld hebben
SELECT naam
FROM spelers as s FULL JOIN wedstrijden as w ON s.spelersnr = w.spelersnr
WHERE wedstrijdnr is null
ORDER BY naam

-- 6. Geef van elke speler (die wedstrijden gespeeld heeft en boetes gekregen heeft) wonend in Rijswijk het spelersnr, de naam, de lijst met boetebedragen en de lijst met teams waarvoor hij/zij een wedstrijd gespeeld heeft. 
-- Geef het resultaat volgens oplopend spelersnr en boetebedrag.
SELECT spelersnr, naam, bedrag, teamnr
FROM spelers as s INNER JOIN boetes as b USING(spelersnr) INNER JOIN wedstrijden as w USING(spelersnr)
WHERE plaats = 'Rijswijk' AND wedstrijdnr is not null 
ORDER BY spelersnr ASC, bedrag ASC

-- 7. Geef een lijst met het spelersnummer, de naam van de speler, de datum van de boete en het bedrag van de boete van al de spelers die een boete gekregen hebben met een bedrag groter dan 45,50 euro en in Rijswijk wonen. 
-- Geef expliciet aan welke join je gebruikt.
SELECT s.spelersnr, naam, datum, bedrag
FROM boetes as b INNER JOIN spelers as s ON b.spelersnr = s.spelersnr
WHERE bedrag > 45.50 AND plaats = 'Rijswijk'

-- 8. Geef voor alle vrouwelijke spelers die in Den Haag, Zoetermeer of Leiden wonen
-- het spelersnummer, hun woonplaats en een lijst van de teams waarvoor ze ooit gespeeld hebben, als ze ooit een wedstrijd gespeeld hebben. 
-- sorteer volgens 1,2,3
SELECT s.spelersnr, plaats, teamnr
FROM spelers as s FULL OUTER JOIN wedstrijden as w ON s.spelersnr = w.spelersnr
WHERE geslacht = 'V' AND (plaats = 'Den Haag' OR plaats = 'Zoetermeer' OR plaats = 'Leiden')
ORDER BY spelersnr, plaats, teamnr

-- 9. Geef per team het hoogste wedstrijdnummer van een wedstrijd, gespeeld door een bestuurslid (actief en niet meer actief) die geen boete heeft gekregen.
-- Sorteer op teamnr.
SELECT te.teamnr, max(wedstrijdnr) as laatstewedstrijd
FROM teams as te LEFT OUTER JOIN wedstrijden as w ON te.spelersnr = w.spelersnr LEFT OUTER JOIN bestuursleden as be ON be.spelersnr = te.spelersnr LEFT OUTER JOIN boetes as b ON b.spelersnr = be.spelersnr
WHERE bedrag = 0
GROUP BY te.teamnr, b.bedrag