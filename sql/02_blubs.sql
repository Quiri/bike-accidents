DROP TABLE IF EXISTS blubs;

CREATE TABLE blubs AS (
    SELECT q1.ogc_fid, q1.wkb_geometry
            , q2.unfallka0
            , q2.count, q2.unfallkost, q2.beteiligte, q2.getoetete, q2.leichtverl, q2.schwerverl
    FROM (
        SELECT ogc_fid, wkb_geometry FROM re_vms_detailnetz_verbind
    ) q1
    JOIN (
        SELECT intersection_id AS ogc_fid
                , unfallka0
                , count(*) AS count
                , sum(unfallkost) AS unfallkost
                , sum(beteiligte) AS beteiligte
                , sum(getoetete) AS getoetete
                , sum(leichtverl) AS leichtverl
                , sum(schwerverl) AS schwerverl

        FROM berlin_bike_accidents_neukoelln_2002_2015
        GROUP BY intersection_id, unfallka0
    ) q2 USING (ogc_fid)
)
