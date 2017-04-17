DROP TABLE IF EXISTS implied_condition;

CREATE TABLE implied_condition (
    Patient_ID int,
    ChronicIllness varchar(44)
);

INSERT INTO implied_condition SELECT * FROM (
    SELECT t.Patient_ID, c.ChronicIllness
    FROM TRANSACTIONS t
    INNER JOIN ChronicIllness_LookUp c
    ON t.Drug_ID = c.MasterProductID
    GROUP BY t.Patient_ID, c.ChronicIllness
);
