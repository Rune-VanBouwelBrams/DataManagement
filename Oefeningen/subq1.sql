-- 1. Geef voor elke speler die een wedstrijd heeft gespeeld het spelersnr en het totaal aantal boetes. 
-- Spelers die een wedstrijd gespeeld hebben, maar geen boetes hebben, moeten ook getoond worden.
-- Sorteer op het aantal boetes en op spelersnr;
select x.spelersnr, 
	case when nbboetes = 0 then null else nbboetes end aantalboetes
from (
SELECT s.spelersnr, COUNT(b.*) as nbboetes
FROM spelers as s LEFT JOIN boetes as b ON s.spelersnr = b.spelersnr
WHERE EXISTS (
SELECT w.spelersnr
FROM wedstrijden as w
WHERE w.spelersnr = s.spelersnr)
GROUP BY s.spelersnr
) x
ORDER BY aantalboetes nulls last, x.spelersnr

-- 2. Geef voor alle spelers die geen penningmeester zijn of zijn geweest alle gewonnen wedstrijden, gesorteerd op wedstrijdnummer.
SELECT s.spelersnr, wedstrijdnr
FROM spelers as s INNER JOIN wedstrijden as w ON s.spelersnr = w.spelersnr
WHERE gewonnen > verloren AND s.spelersnr NOT IN ( 
	SELECT b.spelersnr
	FROM bestuursleden as b
	WHERE functie = 'Penningmeester')
ORDER BY wedstrijdnr

-- 3. Je kan per speler berekenen hoeveel boetes die speler heeft gehad en wat het totaalbedrag per speler is. 
-- Pas nu deze querie aan zodat per verschillend aantal boetes wordt getoond hoe vaak dit aantal boetes voorkwam.
-- Sorteer eerst op de eerste kolom en daarna op de tweede kolom.
select aantalboetes a, count(*) "count" from(
SELECT s.spelersnr, COUNT(b.*) as aantalboetes
FROM spelers as s 
LEFT JOIN boetes as b ON s.spelersnr = b.spelersnr
group by s.spelersnr
having  COUNT(b.*) > 0
	) x group by aantalboetes
order by 1,2;

-- 4. Geef van alle spelers het verschil tussen het jaar van toetreding en het geboortejaar, maar geef alleen die spelers waarvan dat verschil groter is dan 20. 
-- Sorteer deze gegevens beginnend bij de eerste kolom, eindigend bij de laatste kolom.
SELECT spelersnr, naam, voorletters, toetredingsleeftijd
FROM
(
	SELECT spelersnr, naam, voorletters, (jaartoe - EXTRACT(YEAR FROM geb_datum)) as toetredingsleeftijd
	FROM spelers
) x
WHERE toetredingsleeftijd > 20
ORDER BY 1,2,3,4

-- 5. Geef voor elke aanvoerder het spelersnr, de naam en het aantal boetes dat voor hem of haar betaald is en het aantal teams dat hij of zij aanvoert. 
-- Aanvoerders zonder boetes mogen niet getoond worden. 
-- Sorteer, beginnend bij de eerste kolom, eindigend bij de laatste kolom.
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
ORDER BY 1,2,3,4,5

