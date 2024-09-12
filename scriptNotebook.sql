-- gameinfo1
-- gameinfo2
-- platforms

CREATE TABLE Combined2 (
    id SERIAL PRIMARY KEY,
    game_title TEXT,
    platform TEXT,
    esrb_rating TEXT,
    content_descriptors TEXT,
    interactive_elements TEXT,
    content_summary TEXT
    );

CREATE TABLE rawdata (
    Game_Title TEXT,
    Consoles TEXT,
    ESRB_Rating TEXT,
    Content_Descriptors TEXT,
    Interactive_Elements TEXT,
    Content_Summary  TEXT
);


\copy rawdata From '/Volumes/GoogleDrive/My Drive/SQLproject/ygamebackup.csv' DELIMITER ',' CSV HEADER;

-- Begin Transforming the raw data
CREATE TABLE multirow AS
(
SELECT 
Game_Title,
UNNEST(regexp_split_to_array(Consoles,', ')) AS Platform,
ESRB_Rating,
Content_Descriptors,
Interactive_Elements,
Content_Summary
FROM rawdata
);

DELETE FROM multirow WHERE Platform='etc.)';

-- for mid sentence consoles
UPDATE multirow
SET Interactive_Elements = REGEXP_REPLACE(Interactive_Elements, '\s\([-A-Za-z,\s0-9]*\)(?=[A-Z])', ', ');

-- for end sentence consoles
UPDATE multirow
SET Interactive_Elements = REGEXP_REPLACE(Interactive_Elements, '\s\([-A-Za-z,\s0-9]*\)(?=$)', '.');

-- for end sentence consoles
UPDATE multirow
SET Interactive_Elements = REGEXP_REPLACE(Interactive_Elements, '\s\([-A-Za-z,\s0-9]*\(.*\)\)', '.');

-- Add the multirow data to the combined table
INSERT INTO Combined2 (game_title,platform,esrb_rating,content_descriptors,interactive_elements,content_summary)
SELECT game_title,platform,esrb_rating,content_descriptors,interactive_elements,content_summary
FROM multirow;

-- Deletes all rows which are perfect duplicates
DELETE FROM
    Combined2 a 
        USING Combined2 b
WHERE
    a.id < b.id
    AND
    a.Game_Title = b.Game_Title
    AND
    a.Platform = b.Platform
    AND 
    a.Content_Descriptors = b.Content_Descriptors
    AND 
    a.esrb_rating = b.esrb_rating
    AND
    a.interactive_elements = b.interactive_elements
    AND
    a.content_summary = b.content_summary;

DROP TABLE rawdata;
DROP TABLE multirow;

/*markdown
Things to do after combining all of the 6 col data
* ~~CHECK THAT WE GOT FULL PLATFORMS COLUMN~~
* ~~if yes, create a copy of Combined2 and merge with platforms to get a perfect translation column~~
* This is where things might get hard:
* ~~Rename the gamedata1 'platform' column to "gamedata1"~~ 
* ~~Left Join on gamedata1 USING ( game_title, gamedata1);~~
* ~~Check that platform and translation columns are still full~~
* ~~Rename the gamedata2 'platform' column to "gamedata2" ~~
* ~~Left Join on gamedata2 USING ( game_title, gamedata2);~~
* ~~Check that platform and translation columns are still full~~
* if all checks out, DROP the extra platform columns, leaving only Translation
* Rename translation to platform
* try downloading as a csv
*/

SELECT COUNT(*) FROM Combined2 WHERE platform<>'Null';

CREATE TABLE Combined3 AS (
    SELECT *
    FROM Combined2
);

CREATE TABLE Combined4 AS (
    SELECT *
    FROM Combined3 a
    LEFT JOIN Platforms b
    on a.platform = b.esrb
);

SELECT * FROM Combined4 LIMIT 1;





ALTER TABLE gameinfo1
RENAME COLUMN platform TO gameinfo1;
ALTER TABLE gameinfo1
RENAME COLUMN name TO game_title;

-- Left Join on gamedata1 USING ( game_title, gamedata1);
CREATE TABLE Combined5 AS (
    SELECT * 
    FROM Combined4 a
    LEFT JOIN gameinfo1 b
    USING (game_title, gameinfo1)
);

-- * Check that platform and translation columns are still full
SELECT DISTINCT translation, COUNT(translation) FROM Combined5 GROUP BY translation;

SELECT * FROM gameinfo2 LIMIT 1;

-- * Rename the gamedata2 'platform' column to "gamedata2" 
ALTER TABLE gameinfo2
RENAME COLUMN platform TO gameinfo2;
ALTER TABLE gameinfo2
RENAME COLUMN name TO game_title;

-- * Left Join on gamedata2 USING ( game_title, gamedata2);
CREATE TABLE Combined6 AS (
    SELECT * 
    FROM Combined5 a
    LEFT JOIN gameinfo2 b
    USING (game_title, gameinfo2)
);

SELECT DISTINCT translation, COUNT(translation) FROM Combined6 GROUP BY translation;

-- Deletes all rows which are perfect duplicates
DELETE FROM
    Combined6 a 
        USING Combined6 b
WHERE
    a.id < b.id
    AND
    a.Game_Title = b.Game_Title
    AND
    a.gameinfo2 = b.gameinfo2
    AND 
    a.Content_Descriptors = b.Content_Descriptors
    AND 
    a.esrb_rating = b.esrb_rating
    AND
    a.interactive_elements = b.interactive_elements
    AND
    a.content_summary = b.content_summary;

SELECT * FROM Combined6 WHERE game_title='Crookz - The Big Heist';


ALTER TABLE Combined6
DROP COLUMN gameinfo1,
DROP COLUMN gameinfo2,
DROP COLUMN esrb,
DROP COLUMN platform,
DROP COLUMN platform_id;


ALTER TABLE Combined6
RENAME COLUMN translation TO Platform;

-- -- Final step before KAGGLE
-- ALTER TABLE Combined
-- DROP COLUMN platform;

-- ALTER TABLE Combined
-- RENAME COLUMN translation TO Platform;

-- COPY Combined TO '/tmp/ESRB_rating_dataset.csv' DELIMITER ',' CSV HEADER;
-- COPY Combined TO '/Volumes/GoogleDrive/My Drive/SQLproject/ESRB_rating_dataset.csv' DELIMITER ',' CSV HEADER;

-- SELECT COUNT(platform) FROM Combined WHERE platform<>'Null';



-- -- Add dates and other ancillary data to the scraped esrb rows
-- CREATE TABLE datedMultiRow AS (
--     SELECT *
--     FROM multirow
--     LEFT JOIN gameinfo
--     USING (Game_Title, platform)
    
-- );