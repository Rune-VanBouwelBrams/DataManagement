-- 1. Maak een lijst met alle spelers die ooit een boete gekregen hebben die hoger is dan 50 euro. 
-- Geen dubbels. 
-- Sorteer van voor naar achter.
SELECT naam, voorletters, plaats
FROM spelers as s
INNER JOIN boetes as b ON s.spelersnr = b.spelersnr
WHERE bedrag > 50
GROUP BY s.spelersnr, s.naam, s.voorletters, s.plaats
ORDER BY 1, 2, 3

-- 2. Geef van elke boete het betalingsnr, het boetebedrag en het percentage dat het bedrag uitmaakt van de som van alle bedragen. 
-- Sorteer deze data op het betalingsnr. 
-- Zorg dat er maar twee getallen na de komma getoond worden (rond af). 
-- Sorteer van voor naar achter.
SELECT betalingsnr, bedrag, ROUND((bedrag / sum(bedrag) over()) * 100, 2) as round
FROM boetes
ORDER BY 1, 2, 3

-- 3. Geef chronologisch de bestuursleden die voorzitter zijn of geweest zijn (chronologisch op begindatum van het voorzitterschap) met vermelding van deze begindatum, alsook hun naam en huidig adres.
-- Als het vollegie adres niet gekend is dan moet “adres ongekend” weergegeven worden. 
-- Sorteer van voor naar achter.

-- SELECT begin_datum, naam, (straat, huisnr, plaats, postcode) as adres
-- FROM spelers as s
-- INNER JOIN (
-- 	SELECT spelersnr, begin_datum
-- 	FROM bestuursleden
-- 	WHERE functie = 'Voorzitter'
-- 	GROUP BY spelersnr, begin_datum
-- ) as b ON s.spelersnr = b.spelersnr
-- ORDER BY 1, 2, 3

SELECT begin_datum, naam, adres
FROM bestuursleden as b
INNER JOIN (
	SELECT spelersnr, naam, CASE WHEN straat IS NOT NULL AND huisnr IS NOT NULL AND plaats IS NOT NULL AND postcode IS NOT NULL
            THEN CONCAT(straat, ' ', huisnr, plaats, ' ', postcode)
            ELSE 'Adres ongekend'
       END AS adres
	FROM spelers
) as s ON s.spelersnr = b.spelersnr
WHERE functie = 'Voorzitter'
ORDER BY begin_datum

-- 4. Geef alle wedstrijden van het team waarvan speler 6 aanvoerder is. Sorteer
SELECT wedstrijdnr
FROM wedstrijden as w INNER JOIN teams as t ON w.teamnr = t.teamnr
WHERE t.spelersnr = 6

-- 5. Geef alle spelers die geen enkele wedstrijd voor team 1 hebben gespeeld. 
-- Sorteer op naam, daarna op spelersnr.