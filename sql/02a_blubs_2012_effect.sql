DROP TABLE IF EXISTS blubs2012;

CREATE TABLE blubs2012 AS (
    SELECT q1.ogc_fid, q1.wkb_geometry
            , (q2.pre_count / 2.0) AS pre_count
            , (q3.post_count / 2.0) AS post_count
            , (post_count - pre_count) / 2.0 AS delta
    FROM (
        SELECT ogc_fid, wkb_geometry FROM re_vms_detailnetz_verbind
    ) q1
    JOIN (
        SELECT intersection_id AS ogc_fid
                , count(*) AS pre_count
        FROM berlin_bike_accidents_neukoelln_2002_2015
        WHERE (EXTRACT(year from datetime) < 2012) AND (EXTRACT(year FROM datetime) >= 2010)
        GROUP BY intersection_id
    ) q2 ON q1.ogc_fid = q2.ogc_fid
    JOIN (
        SELECT intersection_id AS ogc_fid
                , count(*) AS post_count
        FROM berlin_bike_accidents_neukoelln_2002_2015
        WHERE EXTRACT(year from datetime) > 2012
        GROUP BY intersection_id
    ) q3 ON q1.ogc_fid = q3.ogc_fid
);
