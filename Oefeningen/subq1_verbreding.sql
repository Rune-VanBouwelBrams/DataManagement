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


-- 3. Geef het reisnr, de prijs en vertrekdatum van de reis met de hoogste gemiddelde verblijfsduur op een hemelobject (=som van de verblijfsduur / aantal bezoeken per reis).
SELECT r.reisnr, prijs, vertrekdatum
FROM ruimtereizen.reizen as r
	INNER JOIN(
		SELECT verblijfsduur, reisnr
		FROM ruimtereizen.bezoeken
		-- WHERE max(sum(verblijfsduur)/)
	) as b ON r.reisnr = b.reisnr
	INNER JOIN(
		SELECT reisnr
		FROM ruimtereizen.deelnames
	) as d ON b.reisnr = d.reisnr
WHERE max(sum(verblijfsduur) / count(d.reisnr))