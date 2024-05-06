-- 1. Geef alle klanten waarbij de voorlaatste letter van de naam 1 van de letters uit het woord 'azerty' is.
-- Gebruik geen OR operator, maar een andere ISO sql operator voor het vergelijken van patronen, sorteer van voor naar achter.
select klantnr, naam, vnaam, geboortedatum
from klanten
where  naam similar to '%(a|z|e|r|t|y)_'
order by 1,2

