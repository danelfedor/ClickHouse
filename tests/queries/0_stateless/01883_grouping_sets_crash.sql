DROP TABLE IF EXISTS grouping_sets;

CREATE TABLE grouping_sets(fact_1_id Int32, fact_2_id Int32, fact_3_id Int32, fact_4_id Int32, sales_value Int32) ENGINE = Memory;

INSERT INTO grouping_sets
SELECT
    number % 2 + 1 AS fact_1_id,
       number % 5 + 1 AS fact_2_id,
       number % 10 + 1 AS fact_3_id,
       number % 10 + 1 AS fact_4_id,
       number % 100 AS sales_value
FROM system.numbers limit 1000;

SELECT
    fact_3_id,
    fact_4_id
FROM grouping_sets
GROUP BY
    GROUPING SETS (
        ('wo\0ldworldwo\0ldworld'),
        (fact_3_id, fact_4_id))
ORDER BY
    fact_3_id, fact_4_id;

SELECT 'SECOND QUERY:';

SELECT
    fact_3_id,
    fact_4_id
FROM grouping_sets
GROUP BY
    GROUPING SETS (
    (fact_1_id, fact_2_id),
    ((-9223372036854775808, NULL, (tuple(1.), (tuple(1.), 1048576), 65535))),
    ((tuple(3.4028234663852886e38), (tuple(1024), -2147483647), NULL)),
    (fact_3_id, fact_4_id))
ORDER BY
    (NULL, ('256', (tuple(NULL), NULL), NULL, NULL), NULL) ASC,
    fact_1_id DESC NULLS FIRST,
    fact_2_id DESC NULLS FIRST,
    fact_4_id ASC;

SELECT 'THIRD QUERY:';

SELECT
    extractAllGroups(NULL, 'worldworldworldwo\0ldworldworldworldwo\0ld'),
    fact_2_id,
    fact_3_id,
    fact_4_id
FROM grouping_sets
GROUP BY
    GROUPING SETS (
        (sales_value),
        (fact_1_id, fact_2_id),
        ('wo\0ldworldwo\0ldworld'),
        (fact_3_id, fact_4_id))
ORDER BY
    fact_1_id DESC NULLS LAST,
    fact_1_id DESC NULLS FIRST,
    fact_2_id ASC,
    fact_3_id DESC NULLS FIRST,
    fact_4_id ASC;

DROP TABLE IF EXISTS grouping_sets;