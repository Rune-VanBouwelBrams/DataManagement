-- 1. Geef voor elke geboortejaar van de klanten, het aantal klanten, het kleinste klantennummer en het grootste klantennummer. 
-- Geef ook het totaal aantal klanten en het kleinste en grootste klantennummer.
-- Sorteer van voor naar achter.
SELECT geboortedatum as date_part, count(klantnr) as count, min(klantnr) as min, max(klantnr) as max
FROM ruimtereizen.klanten
GROUP BY geboortedatum
ORDER BY 1,2,3,4

-- 2. We willen telkens het aantal reizen en de totale prijs van de volgende situaties. 
-- Voor elke maand van vertrek, voor elk tiental van de reisduur, voor de combinatie van maand van vertrek en tiental van de reisduur en het het totale plaatje.
-- Sorteer van voor naar achter.
