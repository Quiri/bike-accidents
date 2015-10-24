DROP TABLE IF EXISTS intersections_accident_type;

CREATE TABLE intersections_accident_type AS (
    SELECT q1.ogc_fid, q1.wkb_geometry
            , q2.unfalltyp
            , q2.count
            , (select count(*) from berlin_bike_accidents_neukoelln_2002_2015 where intersection_id = q1.ogc_fid) as total_count
            , q2.count::float / (select count(*) from berlin_bike_accidents_neukoelln_2002_2015 where intersection_id = q1.ogc_fid)::float as percentage
    FROM (
        SELECT ogc_fid, wkb_geometry FROM re_vms_detailnetz_verbind
    ) q1
    INNER JOIN (
        SELECT intersection_id AS ogc_fid
                , unfalltyp
                , count(*) as count
        FROM berlin_bike_accidents_neukoelln_2002_2015
        GROUP BY intersection_id, unfalltyp
    ) q2 ON q1.ogc_fid = q2.ogc_fid
)
