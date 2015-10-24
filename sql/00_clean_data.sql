ALTER TABLE berlin_bike_accidents_neukoelln_2002_2015 ADD COLUMN datetime timestamp;
UPDATE berlin_bike_accidents_neukoelln_2002_2015 SET datetime = to_timestamp (datum || ' ' || uhrzeit, 'YYYY-MM-DD HH24:mi:ss');
ALTER TABLE berlin_bike_accidents_neukoelln_2002_2015 DELETE COLUMN datum;
ALTER TABLE berlin_bike_accidents_neukoelln_2002_2015 DELETE COLUMN uhrzeit;

