-- 1. Geef een lijst van alle hemelobjecten die meer keer bezocht gaan worden dan Jupiter. 
-- (onafhankelijk van het aantal deelnames)
-- Sorteer op objectnaam, diameter.
SELECT h.objectnaam, diameter
FROM hemelobjecten as h
INNER JOIN(
	SELECT objectnaam, count(reisnr) as aantal
	FROM ruimtereizen.bezoeken
	GROUP BY objectnaam
) as bez ON h.objectnaam = bez.objectnaam 
WHERE aantal > (bez.objectnaam = 'Jupiter')
ORDER BY 1,2

-- 2. Geef het hemellichaam dat het laatst bezocht is.
-- Gebruik hiervoor de laatste vertrekdatum van de reis en laatste volgnummer van bezoek. 
-- Tip: gebruik hiervoor een rij-subquery.
-- Gebruik geen limit of top.
SELECT objectnaam FROM bezoeken
WHERE
(reisnr, volgnr) = (
	SELECT reisnr, MAX(volgnr)
	FROM bezoeken
	WHERE reisnr = (
		SELECT reisnr
		FROM reizen
		WHERE vertrekdatum = (
			SELECT MAX(vertrekdatum) AS vertrekdatum
			FROM reizen
			)
		)
	GROUP BY reisnr
	)

-- 3. Geef het reisnr, de prijs en vertrekdatum van de reis met de hoogste gemiddelde verblijfsduur op een hemelobject (=som van de verblijfsduur / aantal bezoeken per reis).
SELECT r.reisnr, r.prijs, r.vertrekdatum 
FROM    (
    SELECT reisnr, SUM(verblijfsduur)/COUNT(volgnr) AS gem_duur
    FROM bezoeken
    GROUP BY reisnr
    ) AS gemiddelde_duur
INNER JOIN reizen AS r ON r.reisnr = gemiddelde_duur.reisnr
WHERE gem_duur = (
    SELECT MAX(gem_duur) 
    FROM (
        SELECT reisnr, SUM(verblijfsduur)/COUNT(volgnr) AS gem_duur
        FROM bezoeken
        GROUP BY reisnr
        ) AS gemiddelde_duur
    )

-- 4. Geef de planeet (draait dus rond de zon) met de meeste satellieten.
-- Sorteer op objectnaam.
SELECT objectnaam 
FROM (
	SELECT h.satellietvan AS objectnaam, COUNT(h.objectnaam) AS aantal_manen
	FROM hemelobjecten AS h
	WHERE h.satellietvan <> 'Zon'
	GROUP BY h.satellietvan
     	) AS aantal_manen
WHERE aantal_manen = (
	SELECT MAX(aantal_manen) 
	FROM 	(
		SELECT h.satellietvan AS objectnaam, COUNT(h.objectnaam) AS aantal_manen
		FROM hemelobjecten AS h
		WHERE h.satellietvan <> 'Zon'
		GROUP BY h.satellietvan
		) AS aantal_manen
	)
ORDER BY objectnaam

-- 5. Geef het op één na kleinste hemellichaam.
-- Je kan dit vinden door handig gebruik te maken van expliciete joins en een doorsnedevoorwaarde. 
-- Tip: probeer eerst een lijst te krijgen van alle hemelobjecten en het aantal hemellichaam dat kleiner is dan dat hemelobject.
SELECT objectnaam, aantalkleiner
FROM 	(
	SELECT hem.objectnaam, COUNT(ho.objectnaam) AS aantalkleiner
	FROM hemelobjecten AS hem
	INNER JOIN hemelobjecten AS ho ON hem.diameter > ho.diameter
	GROUP BY hem.objectnaam
	) AS h
WHERE aantalkleiner = 1