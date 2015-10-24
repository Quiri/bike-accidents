-- 0.0005 ~ 50m
UPDATE berlin_bike_accidents_neukoelln_2002_2015 SET intersection_id = (SELECT q.ogc_fid FROM (
    SELECT re_vms_detailnetz_verbind.ogc_fid, re_vms_detailnetz_verbind.wkb_geometry
    FROM re_vms_detailnetz_verbind
    ORDER BY berlin_bike_accidents_neukoelln_2002_2015.wkb_geometry <-> re_vms_detailnetz_verbind.wkb_geometry ASC
    LIMIT 1
    ) q
    WHERE ST_DWithin(q.wkb_geometry, berlin_bike_accidents_neukoelln_2002_2015.wkb_geometry, 0.0005)
    LIMIT 1
);



--SELECT acc.ogc_fid, acc.strassennam, (SELECT ARRAY(
--        SELECT i.spatial_name
--        FROM re_vms_detailnetz_verbind i
--        ORDER BY acc.wkb_geometry <-> i.wkb_geometry
--        LIMIT 5
--    ))
--FROM berlin_bike_accidents_neukoelln_2002_2015 acc;

