-- 1. Geef de diameter van het grootste hemellichaam dat bezocht is op de vroegste reis waar klantnr 126 niet op meegegaan is.
SELECT MAX(diameter) AS grootste
FROM hemelobjecten as hem JOIN bezoeken as b USING(objectnaam) JOIN reizen as r USING(reisnr)
WHERE vertrekdatum = (
        SELECT MIN(vertrekdatum)
        FROM reizen
        WHERE reisnr NOT IN (
                SELECT klantnr
                FROM deelnames
                WHERE klantnr = 126
        )
)

-- 2. Geef de deelnemers waarbij hun aantal reizen die ze ondernemen groter is dan alle hemelobjecten (die niet beginnen met de letter 'M') hun aantal keren dat ze bezocht zijn. 
-- Of anders geformuleerd:
-- Geef de deelnemers met meer deelnames dan het grootste aantal bezoeken aan een hemelobject dat niet met de letter 'M' begint (:deze deelnemer meer deelnames heeft dan de "grootste" .. = deze deelnemer heeft meer deelnames dan "alle" ..)
-- Sorteer op klantnr.
SELECT klantnr, vnaam, naam, COUNT(reisnr) as aantaldeelnames
FROM klanten INNER JOIN deelnames USING(klantnr)
GROUP BY klantnr, vnaam, naam
HAVING COUNT(reisnr) > ALL (
        SELECT COUNT(*)
        FROM bezoeken
        WHERE NOT EXISTS (
                SELECT objectnaam
                FROM hemelobjecten
                WHERE objectnaam LIKE 'M%'
                AND bezoeken.objectnaam = hemelobjecten.objectnaam
        )
        GROUP BY objectnaam
)

-- 3. Geef alle niet-bezochte hemelobjecten, buiten het grootste hemellichaam.
-- Sorteer op diameter en objectnaam.
SELECT objectnaam, afstand, diameter
FROM hemelobjecten
WHERE NOT EXISTS (
        SELECT reisnr
        FROM bezoeken as b
        WHERE b.objectnaam = hemelobjecten.objectnaam
)
AND diameter < ANY (
        SELECT max(diameter)
        FROM hemelobjecten
)
ORDER BY diameter, objectnaam

-- 4. Maak een lijst van klanten die meer dan 2 keer een reis gemaakt hebben waarbij er geen bezoek was aan Jupiter.