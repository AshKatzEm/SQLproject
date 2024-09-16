CREATE TABLE agames (
    Game_Title TEXT,
    Consoles TEXT,
    ESRB_Rating TEXT,
    Content_Descriptors TEXT,
    Interactive_Elements TEXT,
    Content_Summary  TEXT
)

DROP TABLE agames;

ALTER TABLE agames ADD id SERIAL;

SELECT COUNT(*) FROM (SELECT Game_Title, Content_Summary, COUNT(Game_Title)
FROM agames
GROUP BY Content_Summary, Game_Title
HAVING COUNT(Game_Title)> 1);

DROP TABLE Combined;

SELECT COUNT(*) FROM Combined;

SELECT * FROM Combined LIMIT 5;

CREATE TABLE gameinfo3 (
    id SERIAL,
    slug TEXT,
    name TEXT,
    metacritic TEXT,
    released TEXT,
    tba TEXT,
    updated TEXT,
    website TEXT,
    rating TEXT,
    rating_top TEXT,
    playtime TEXT,
    achievements_count TEXT,
    ratings_count TEXT,
    suggestions_count TEXT,
    game_series_count TEXT,
    reviews_count TEXT,
    platforms TEXT,
    developers TEXT,
    genres TEXT,
    publishers TEXT,
    esrb_rating TEXT,
    added_status_yet TEXT,
    added_status_owned TEXT,
    added_status_beaten TEXT,
    added_status_toplay TEXT,
    added_status_dropped TEXT,
    added_status_playing TEXT
);

CREATE TABLE vgsales (
    Rank TEXT,
    Name TEXT,
    Platform TEXT,
    Year TEXT,
    Genre TEXT,
    Publisher TEXT,
    NA_Sales TEXT,
    EU_Sales TEXT,
    JP_Sales TEXT,
    Other_Sales TEXT,
    Global_Sales TEXT
    );

SELECT * FROM vgsales WHERE Name= 'Spider-Man 2';
-- LIKE '%' || Name || '%';

SELECT Game_Title, COUNT(Game_Title)
FROM agames
GROUP BY Game_Title
HAVING COUNT(Game_Title)> 5;

UPDATE agames
SET Consoles = REPLACE(Consoles, 'PlayStation/PS one', 'PS1' );

UPDATE agames
SET Consoles = REPLACE(Consoles, 'PlayStation 2', 'PS2' );

UPDATE agames
SET Consoles = REPLACE(Consoles, 'PlayStation 3', 'PS3' );



UPDATE agames
SET Consoles = REPLACE(Consoles, 'PlayStation 4', 'PS4');


UPDATE agames
SET Consoles = REPLACE(Consoles, 'PlayStation 5', 'PS5');


UPDATE agames
SET Consoles = REPLACE(Consoles, 'Xbox 360', 'X360');


UPDATE agames
SET Consoles = REPLACE(Consoles, 'Xbox Series', 'XS'); 

UPDATE agames
SET Consoles = REPLACE(Consoles, 'Xbox One', 'XOne'); 

UPDATE agames
SET Consoles = REPLACE(Consoles, 'Xbox', 'XB'); 

UPDATE agames
SET Consoles = REPLACE(Consoles, 'Game Boy Color', 'GBC' );

UPDATE agames
SET Consoles = REPLACE(Consoles, 'Game Boy Advance', 'GBA' );

UPDATE agames
SET Consoles = REPLACE(Consoles, 'NS', 'NG');

UPDATE agames
SET Consoles = REPLACE(Consoles, 'Nintendo DS', 'dS');

UPDATE agames
SET Consoles = REPLACE(Consoles, 'GameCube', 'GC'); 

UPDATE agames
SET Consoles = REPLACE(Consoles, 'Windows PC', 'PC');

UPDATE agames
SET Consoles = REPLACE(Consoles, 'Macintosh', 'MAC');

SELECT Platform, COUNT(DISTINCT Platform)
FROM vgsales
GROUP BY Platform;

SELECT * FROM vgsales WHERE 'GEN' LIKE '%' || Platform || '%';

SELECT * FROM agames WHERE 'Sega Genesis' LIKE '%' || Consoles || '%';

UPDATE agames
SET Consoles = REPLACE(Consoles, 'Sega Saturn', 'SAT');

UPDATE agames
SET Consoles = REPLACE(Consoles, 'Nintendo', 'NES');

UPDATE agames
SET Consoles = REPLACE(Consoles, 'PS Vita', 'PSV');

UPDATE agames
SET Consoles = REPLACE(Consoles, 'Super Nintendo', 'SNES');

UPDATE agames
SET Consoles = REPLACE(Consoles, 'Wii U', 'WiiU');

UPDATE agames
SET Consoles = REPLACE(Consoles, 'Nintendo 64', 'N64');

UPDATE agames
SET Consoles = REPLACE(Consoles, 'Game Gear', 'GG');

SELECT * FROM agames WHERE Game_Title ='Carnival Games';

SELECT DISTINCT Consoles FROM agames ORDER BY Consoles;
-- 'ATARI 2600+, Game Boy, Dreamcast,Sega Genesis', '2600, GB,DC,GEN'

SELECT COUNT(Game_Title), Game_Title 
FROM egames 
GROUP BY Game_Title
HAVING COUNT(Game_Title)>2;

SELECT COUNT(*) FROM agames;

SELECT COUNT(*) FROM egames;

SELECT COUNT(*) FROM ( agames JOIN egames ON agames.Game_Title=egames.Game_Title);

SELECT COUNT(*) FROM ( agames LEFT OUTER JOIN egames ON agames.Game_Title=egames.Game_Title);

SELECT COUNT(*) FROM ( agames INNER JOIN egames ON agames.Game_Title<>egames.Game_Title);

SELECT Game_Title, COUNT(Game_Title)
FROM agames
GROUP BY Game_Title
HAVING COUNT(Game_Title)> 5;

SELECT * FROM (
SELECT Game_Title, ESRB_Rating, Content_Descriptors, Interactive_Elements, Content_Summary, string_agg(Consoles, ', ') AS Console_list
FROM  agames
GROUP BY Game_Title, ESRB_Rating, Content_Descriptors, Interactive_Elements, Content_Summary)
WHERE Game_Title ='FIFA Soccer 14';

SELECT Game_Title, Consoles, ESRB_Rating, Content_Descriptors, Interactive_Elements, Content_Summary 
FROM (
    SELECT Game_Title, string_agg(Consoles, ', ') AS Consoles, ESRB_Rating, Content_Descriptors, Interactive_Elements, Content_Summary
    FROM  agames
    GROUP BY Game_Title, ESRB_Rating, Content_Descriptors, Interactive_Elements, Content_Summary
    )
WHERE Game_Title ='LEGO Star Wars: The Force Awakens';

INSERT INTO agames (Game_Title, Consoles, ESRB_Rating, Content_Descriptors, Interactive_Elements, Content_Summary)
SELECT Game_Title, Consoles, ESRB_Rating, Content_Descriptors, Interactive_Elements, Content_Summary
FROM egames;

SELECT COUNT(*) FROM agames;

-- We're trying to get rows that have the same title, Rating, descriptors, interactive ele, and sumary 
SELECT * FROM (
SELECT Game_Title, COUNT(Game_Title)
FROM agames
GROUP BY Game_Title
HAVING COUNT(Game_Title)>6
)
WHERE COUNT =10;

SELECT * FROM agames WHERE 'LEGO Star Wars: The Force Awakens' LIKE '%' || Game_Title || '%';

ALTER TABLE Games DROP COLUMN game_id, ;

 DROP TABLE Games; 

CREATE TABLE Games (
    game_id SERIAL PRIMARY KEY,
    Game_Title TEXT,
    Content_Descriptors TEXT	
);

INSERT INTO Games (Game_Title, Content_Descriptors)
SELECT Game_Title, Content_Descriptors
FROM agames;

SELECT * FROM Games WHERE 'LEGO Star Wars: The Force Awakens' LIKE '%' || Game_Title || '%';

DELETE FROM
    Games a 
        USING Games b
WHERE
    a.game_id < b.game_id
    AND
    a.Game_Title = b.Game_Title
    AND 
    a.Content_Descriptors = b.Content_Descriptors;

SELECT * FROM Games WHERE 'LEGO Star Wars: The Force Awakens' LIKE '%' || Game_Title || '%';

ALTER TABLE agames DROP COLUMN game_id;

ALTER TABLE agames
ADD game_id SERIAL PRIMARY KEY;

SELECT * FROM agames WHERE 'LEGO Star Wars: The Force Awakens' LIKE '%' || Game_Title || '%';

DROP TABLE testgames;

CREATE TABLE testgames (
    Game_Title TEXT,
    Consoles TEXT,
    ESRB_Rating TEXT,
    Content_Descriptors TEXT,
    Interactive_Elements TEXT,
    Content_Summary  TEXT
);
INSERT INTO testgames (Game_Title, Consoles, ESRB_Rating, Content_Descriptors, Interactive_Elements, Content_Summary)
SELECT Game_Title, Consoles, ESRB_Rating, Content_Descriptors, Interactive_Elements, Content_Summary
FROM agames;


ALTER TABLE testgames ADD COLUMN id SERIAL PRIMARY KEY;

-- for mid sentence consoles
UPDATE testgames
SET Interactive_Elements = REGEXP_REPLACE(Interactive_Elements, '\s\([-A-Za-z,\s0-9]*\)(?=[A-Z])', ', ');

-- for end sentence consoles
UPDATE testgames
SET Interactive_Elements = REGEXP_REPLACE(Interactive_Elements, '\s\([-A-Za-z,\s0-9]*\)(?=$)', '.');

-- for end sentence consoles
UPDATE testgames
SET Interactive_Elements = REGEXP_REPLACE(Interactive_Elements, '\s\([-A-Za-z,\s0-9]*\(.*\)\)', '.');

SELECT DISTINCT Interactive_Elements FROM testgames;

SELECT COUNT(*) FROM 
(
    SELECT Game_Title, COUNT(*), Interactive_Elements, Content_Descriptors,esrb_rating
    FROM testgames
    GROUP BY Game_Title, Interactive_Elements, Content_Descriptors, esrb_rating
    HAVING COUNT(Game_Title)> 1
    AND
    COUNT(Interactive_Elements)>1
    AND
    COUNT(Content_Descriptors)>1
    AND
    COUNT(esrb_rating)>1
    );

-- How many rows have perfect duplicates
SELECT COUNT(*) FROM 
(
    SELECT Game_Title, COUNT(*), Interactive_Elements, Content_Descriptors,esrb_rating, content_summary, consoles
    FROM testgames
    GROUP BY Game_Title, Interactive_Elements, Content_Descriptors, esrb_rating, content_summary, consoles
    HAVING COUNT(Game_Title)> 1
    AND
    COUNT(Interactive_Elements)>1
    AND
    COUNT(Content_Descriptors)>1
    AND
    COUNT(esrb_rating)>1
    AND
    COUNT(content_summary)>1
    AND
    COUNT(consoles)>1
    );

SELECT COUNT(*) FROM 
(
    SELECT Game_Title, COUNT(*), Interactive_Elements, Content_Descriptors,esrb_rating
    FROM testgames
    GROUP BY Game_Title, Interactive_Elements, Content_Descriptors, esrb_rating
    HAVING COUNT(Game_Title)= 1
    AND
    COUNT(Interactive_Elements)=1
    AND
    COUNT(Content_Descriptors)=1
    AND
    COUNT(esrb_rating)=1
    );

SELECT 29990 - 4788;

-- Deletes all rows which are perfect duplicates
DELETE FROM
    testgames a 
        USING testgames b
WHERE
    a.id < b.id
    AND
    a.Game_Title = b.Game_Title
    AND
    a.consoles = b.consoles
    AND 
    a.Content_Descriptors = b.Content_Descriptors
    AND 
    a.esrb_rating = b.esrb_rating
    AND
    a.interactive_elements = b.interactive_elements
    AND
    a.content_summary = b.content_summary;

SELECT COUNT(*) FROM testgames;

/*markdown
we got rid of all of the total duplicates.
We need to merge the dif-console duplicates.
Is the number of dif-console with 3 identical col and dif-console with 4 identical col?
*/

-- dif-console with 4 identical rows
SELECT COUNT(*) FROM 
(
    SELECT Game_Title, COUNT(*), Interactive_Elements, Content_Descriptors,esrb_rating
    FROM testgames
    GROUP BY Game_Title, Interactive_Elements, Content_Descriptors, esrb_rating
    HAVING 
    COUNT(Game_Title)> 1
    AND
    COUNT(Interactive_Elements)>1
    AND
    COUNT(Content_Descriptors)>1
    AND
    COUNT(esrb_rating)>1
   );

-- dif-console with 3 identical rows
SELECT COUNT(*) FROM 
(
    SELECT Game_Title, COUNT(*), Interactive_Elements,esrb_rating
    FROM testgames
    GROUP BY Game_Title, Interactive_Elements,esrb_rating
    HAVING 
    COUNT(Game_Title)> 1
    AND
    COUNT(Interactive_Elements)>1
    AND
    COUNT(esrb_rating)>1
    );

/*markdown
THe amount of dif-consoles with 3 identical columns is 500 more than the amount of dif-consoles with 4 identical columns.
WHY?
*/

-- Lets see the 4 and 5 columns of the dif consoles with 3 identical columns. We can see what the difference is between one set of Content_Discriptors and another
-- SELECT * FROM (
    SELECT COUNT(*), Game_Title, Consoles, Interactive_Elements,esrb_rating, Content_Descriptors
    FROM testgames
    GROUP BY Game_Title, Consoles, Interactive_Elements,esrb_rating,Content_Descriptors
    HAVING 
    COUNT(Game_Title)> 1
    AND
    COUNT(Interactive_Elements)>1
    AND
    COUNT(esrb_rating)>1;
-- ) WHERE 'Minecraft: Xbox 360 Edition' LIKE '%' || Game_Title || '%';

SELECT Game_Title,esrb_rating,Interactive_Elements,Content_Descriptors,consoles, content_summary, id FROM testgames WHERE 'Minecraft: Xbox 360 Edition' LIKE '%' || Game_Title || '%';

-- Deletes all rows where all columns are identical except summary. Same exact game but different summary. Drop the shorter one.
DELETE FROM
    testgames a 
        USING testgames b
WHERE
    (
    a.id < b.id
    OR
    a.id > b.id
    )
    AND
    a.Game_Title = b.Game_Title
    AND
    a.consoles = b.consoles
    AND 
    a.Content_Descriptors = b.Content_Descriptors
    AND 
    a.esrb_rating = b.esrb_rating
    AND
    a.interactive_elements = b.interactive_elements
    AND
    length(a.content_summary) < length(b.content_summary)
    ;

SELECT Game_Title,esrb_rating,Interactive_Elements,Content_Descriptors,consoles, content_summary, id FROM testgames WHERE 'Minecraft: Xbox 360 Edition' LIKE '%' || Game_Title || '%';

/*markdown
THe amount of dif-consoles with 3 identical columns WAS 500 more than the amount of dif-consoles with 4 identical columns. But we reduced things alot. Lets see how much it is now
*/

-- dif-console with 3 identical rows
SELECT COUNT(*) FROM 
(
    SELECT Game_Title, COUNT(*), Interactive_Elements, esrb_rating
    FROM testgames
    GROUP BY Game_Title, Interactive_Elements, esrb_rating
    HAVING 
    COUNT(Game_Title)> 1
    AND
    COUNT(Interactive_Elements)>1
    AND
    COUNT(esrb_rating)>1
   );

-- dif-console with 4 identical rows
SELECT COUNT(*) FROM 
(
    SELECT Game_Title, COUNT(*), Interactive_Elements, Content_Descriptors,esrb_rating
    FROM testgames
    GROUP BY Game_Title, Interactive_Elements, Content_Descriptors, esrb_rating
    HAVING 
    COUNT(Game_Title)> 1
    AND
    COUNT(Interactive_Elements)>1
    AND
    COUNT(Content_Descriptors)>1
    AND
    COUNT(esrb_rating)>1
   );

-- dif-console with ALT 4 identical rows
SELECT COUNT(*) FROM 
(
    SELECT Game_Title, COUNT(*), Interactive_Elements, Content_Summary,esrb_rating
    FROM testgames
    GROUP BY Game_Title, Interactive_Elements, Content_Summary, esrb_rating
    HAVING 
    COUNT(Game_Title)> 1
    AND
    COUNT(Interactive_Elements)>1
    AND
    COUNT(Content_Summary)>1
    AND
    COUNT(esrb_rating)>1
   );

-- Lets see the 4 and 5 columns of the dif-consoles with 3 identical columns. Lets see if we can find the difference between one set of Content_Discriptors and another
    SELECT COUNT(*), Game_Title, Interactive_Elements,esrb_rating, Content_Descriptors, Content_Summary, consoles
    FROM testgames
    GROUP BY Game_Title, Interactive_Elements,esrb_rating,Content_Descriptors, Content_Summary, consoles
    ORDER BY Game_Title;

/*markdown
It's clear that the gap between the 3ir and 4ir is because some dif-console with 4 identical rows have 2 or more "Content Groups". For example, a game is EXACTLY the same on XS, PS5 and PC, and exactly the same on Switch, PSV, two groups each with a slightly different game.
Let's see if we can get a good view of this

*/

CREATE VIEW oneAndMore AS
    SELECT COUNT(*), Game_Title, Interactive_Elements,esrb_rating, Content_Descriptors, Content_Summary
    FROM testgames
    GROUP BY Game_Title, Interactive_Elements,esrb_rating,Content_Descriptors, Content_Summary
    ORDER BY Game_Title;


SELECT 
*
FROM 
  oneAndMore a 
  INNER JOIN oneAndMore b ON a.Game_Title = b.Game_Title 
  AND 
  (
    a.COUNT > b.COUNT
    OR 
    a.COUNT < b.COUNT
  )
    ;

-- dif-console with 5 identical rows
SELECT COUNT(*) FROM 
(
    SELECT Game_Title, COUNT(*), Interactive_Elements, Content_Summary, Content_Descriptors, esrb_rating
    FROM testgames
    GROUP BY Game_Title, Interactive_Elements, Content_Summary, Content_Descriptors, esrb_rating
    HAVING 
    COUNT(Game_Title)> 1
    AND
    COUNT(Interactive_Elements)>1
    AND
    COUNT(Content_Summary)>1
    AND
    COUNT(esrb_rating)>1
    AND
    COUNT(Content_Descriptors)>1
   );

/*markdown
We have 1614 rows which are exactly the same game but different console. Let's try to aggregate the consoles into one row.
*/

SELECT Game_Title, Consoles, ESRB_Rating, Content_Descriptors, Interactive_Elements, Content_Summary 
FROM (
    SELECT Game_Title, string_agg(Consoles, ', ') AS Consoles, ESRB_Rating, Content_Descriptors, Interactive_Elements, Content_Summary
    FROM  testgames
    GROUP BY Game_Title, ESRB_Rating, Content_Descriptors, Interactive_Elements, Content_Summary
    )
WHERE Game_Title ='Avatar: The Last Airbender';

DROP TABLE multirow;

CREATE TABLE multirow AS
(
SELECT 
Game_Title,
UNNEST(regexp_split_to_array(Consoles,', ')) AS Platform,
ESRB_Rating,
Content_Descriptors,
Interactive_Elements,
Content_Summary
FROM testgames
);


DELETE FROM multirow WHERE Platform='etc.)';

SELECT DISTINCT Platform FROM multirow ORDER BY Platform;

-- How many rows have perfect duplicates NOW
SELECT COUNT(*) FROM 
(
    SELECT Game_Title, COUNT(*), Interactive_Elements, Content_Descriptors,esrb_rating, content_summary, Platform
    FROM multirow
    GROUP BY Game_Title, Interactive_Elements, Content_Descriptors, esrb_rating, content_summary, Platform
    -- HAVING COUNT(Game_Title)> 1
    -- AND
    -- COUNT(Interactive_Elements)>1
    -- AND
    -- COUNT(Content_Descriptors)>1
    -- AND
    -- COUNT(esrb_rating)>1
    -- AND
    -- COUNT(content_summary)>1
    -- AND
    -- COUNT(consoles)>1
    );

-- How many rows have perfect duplicates NOW
SELECT COUNT(*) FROM 
(
    SELECT Game_Title, COUNT(*), Interactive_Elements, Content_Descriptors,esrb_rating, content_summary, Platform
    FROM multirow
    GROUP BY Game_Title, Interactive_Elements, Content_Descriptors, esrb_rating, content_summary, Platform
    HAVING COUNT(Game_Title)> 1
    AND
    COUNT(Interactive_Elements)>1
    AND
    COUNT(Content_Descriptors)>1
    AND
    COUNT(esrb_rating)>1
    AND
    COUNT(content_summary)>1
    AND
    COUNT(Platform)>1
    );

SELECT * FROM vgsales WHERE Name= 'Spider-Man 2';
-- LIKE '%' || Name || '%';

SELECT DISTINCT Platform FROM vgsales ORDER BY Platform;

SELECT * FROM gameinfo LIMIT 5;

ALTER TABLE gameinfo3 
DROP COLUMN publishers,
DROP COLUMN added_status_yet,
DROP COLUMN added_status_beaten,
DROP COLUMN added_status_dropped,
DROP COLUMN reviews_count,
DROP COLUMN game_series_count,
DROP COLUMN suggestions_count,
DROP COLUMN ratings_count,
DROP COLUMN achievements_count,
DROP COLUMN playtime,
DROP COLUMN rating_top,
DROP COLUMN rating,
DROP COLUMN website,
DROP COLUMN tba,
DROP COLUMN metacritic,
DROP COLUMN added_status_owned,
DROP COLUMN added_status_toplay,
DROP COLUMN added_status_playing;


SELECT DISTINCT esrb_rating FROM multirow;

SELECT DISTINCT esrb_rating FROM gameinfo3;

/*markdown
So you decided that you were going to create more rows, each with only one column, called Platform.
This matches vggames.
You also cleaned up the gamedata table,
* Do the same row builder from Platforms to Platform on the gamedata table.

* Then You can try to do a join where we add the data from gameinfo to multirow where gameinfo has the same name and platform that multirow has
so LEFT join on multirow.Game_Title = gameinfo.Name AND multirow.Platform = gameinfo.Platform

* Maybe try the same thing with vg_sale but only add the "year" column as a back up.
*/

-- Standardize the esrb rating syntax in case we have to match on that too
UPDATE gameinfo3
SET esrb_rating = REPLACE(esrb_rating, 'Adults Only', 'AO');

UPDATE gameinfo3
SET esrb_rating = REPLACE(esrb_rating, 'Mature', 'M');

UPDATE gameinfo3
SET esrb_rating = REPLACE(esrb_rating, 'Teen', 'T');

UPDATE gameinfo3
SET esrb_rating = REPLACE(esrb_rating, 'Everyone 10+', 'E10+');

UPDATE gameinfo3
SET esrb_rating = REPLACE(esrb_rating, 'Everyone', 'E');

SELECT DISTINCT esrb_rating, COUNT(esrb_rating) FROM gameinfo
GROUP BY esrb_rating;

SELECT DISTINCT platforms FROM gameinfo;

UPDATE gameinfo3
SET platforms = REPLACE(platforms, '.', ', ');

SELECT * FROM gameinfo LIMIT 25;

DROP TABLE gameinfo1;
DROP TABLE gameinfo2;

CREATE TABLE gameinfo1 AS
(
SELECT 
name,	
released AS Release_Date,
updated,
UNNEST(regexp_split_to_array(platforms,', ')) AS Platform,
REPLACE(developers,'.',', ') AS developers,
REPLACE(genres,'.',', ') AS genres
FROM gameinfo3
);

CREATE TABLE gameinfo2 AS(
    SELECT
    Name,
    Platform AS Platform,
    Year AS Release_Year ,
    Publisher ,
    NA_Sales ,
    EU_Sales ,
    JP_Sales ,
    Other_Sales ,
    Global_Sales 
    FROM vgsales
);

SELECT DISTINCT Platform FROM gameinfo2;

DROP TABLE platforms;

CREATE TABLE platforms (
    ESRB TEXT,
    gameinfo1 TEXT,
    gameinfo2 TEXT,
    Translation TEXT
)

ALTER TABLE platforms ADD COLUMN platform_id SERIAL PRIMARY KEY;

INSERT INTO platforms (ESRB, gameinfo1, gameinfo2, Translation)
VALUES 
('3DO','3DO','3DO', '3DO'),
('ATARI 2600+','Atari 2600','2600','Atari 2600'),
('ATARI 7800','Atari 7800',NULL,'Atari 7800'),
('Amazon',NULL,NULL,'Amazon'),
('Android', 'Android',NULL,'Android'),
('Atari 7800',NULL,NULL,'Atari 7800'),
('Atari Jaguar','Jaguar',NULL,'Atari Jaguar'),
('Cable Box',NULL,NULL,'Cable Box'),
('Connected TV''s',NULL,NULL,'Connected TV''s'),
('DS', 'Nintendo DS', 'DS', 'Nintendo DS'),
('DVD',NULL,NULL,'DVD'),
('Digital TV',NULL,NULL,'Digital TV'),
('Dreamcast', 'Dreamcast','DC', 'Sega Dreamcast'),
('Game & Watch',NULL,NULL,'Game & Watch'),
('Game Boy', 'Game Boy', 'GB', 'Game Boy'),
('Game Boy Advance', 'Game Boy Advance','GBA','Game Boy Advance'),
('Game Boy Color','Game Boy Color', 'GB','Game Boy Color'),
('Game Gear','Game Gear', 'GG','Game Gear'),
('GameCube','GameCube','GC','GameCube'),
('Genesis','Genesis', 'GEN','Genesis'),
('Gizmondo',NULL,NULL,'Gizmondo'),
('Hyperscan',NULL,NULL,'Hyperscan'),
('IPTV',NULL,NULL,'IPTV'),
('Intellivision Amico',NULL,NULL,'Intellivision Amico'),
('Linux','Linux',NULL,'Linux'),
('Linux based PC',NULL,NULL,'Linux based PC'),
('Macintosh', 'macOS',NULL,'macOS'),
('Meta Quest',NULL,NULL,'Meta Quest'),
('Meta Quest 2',NULL,NULL,'Meta Quest 2'),
('Microsoft Teams',NULL,NULL,'Microsoft Teams'),
('Mini Console',NULL,NULL,'Mini Console'),
('Mobile (GooglePlay)',NULL,NULL,'Mobile (GooglePlay)'),
('Mobile Phone',NULL,NULL,'Mobile Phone'),
('ModRetro Chromatic',NULL,NULL,'ModRetro Chromatic'),
('N-Gage',NULL,NULL,'N-Gage'),
('NUON',NULL,NULL,'NUON'),
('Neo Geo Pocket Color',NULL,NULL,'Neo Geo Pocket Color'),
('New Nintendo 3DS',NULL,NULL,'New Nintendo 3DS'),
('Nintendo', 'NES', 'NES','NES'),
('Nintendo 3DS', 'Nintendo 3DS','3DS','Nintendo 3DS'),
('Nintendo 64','Nintendo 64','N64', 'Nintendo 64'),
('Nintendo DS', 'Nintendo DS', 'DS', 'Nintendo DS'),
('Nintendo DSi', 'Nintendo DSi',NULL,'Nintendo DSi'),
('Nintendo Game & Watch',NULL,NULL,'Game & Watch'),
('Nintendo Game Boy', 'Game Boy', 'GB','Game Boy'),
('Nintendo Switch', 'Nintendo Switch',NULL,'Nintendo Switch'),
('Online',NULL,NULL,'Online'),
('PDA (Palm',NULL,NULL,'Palm'),
('PS Vita', 'PS Vita', 'PSV','PS Vita'),
('PSP', 'PSP', 'PSP','PSP'),
('Palm Pilot',NULL,NULL,'Palm Pilot'),
('PlayStation 2', 'PlayStation 2','PS2', 'PlayStation 2'),
('PlayStation 3', 'PlayStation 3','PS3', 'PlayStation 3'),
('PlayStation 4', 'PlayStation 4','PS4', 'PlayStation 4'),
('PlayStation 5', 'PlayStation 5','PS5', 'PlayStation 5'),
('PlayStation Certified Device',NULL,NULL,'PlayStation Certified Device'),
('PlayStation/PS one', 'PlayStation','PS','PlayStation 1'),
('Plug-and-Play',NULL,NULL,'Plug-and-Play'),
('Pocket PC',NULL,NULL,'Pocket PC'),
('Pokemon Mini',NULL,NULL,'Pokemon Mini'),
('Samsung TV',NULL,NULL,'Samsung TV'),
('Samsung TV (model Pavv Bordo)',NULL,NULL,'Samsung TV (model Pavv Bordo)'),
('Samsung TV 750',NULL,NULL,'Samsung TV 750'),
('Sega 32X','SEGA 32X',NULL, 'Sega 32X'),
('Sega CD','SEGA CD','SCD', 'SEGA CD'),
('Sega Dreamcast', 'Dreamcast', 'DC','Sega Dreamcast'),
('Sega Genesis', 'Genesis','GEN','Sega Genesis'),
('Sega Saturn', 'SEGA Saturn', 'SAT','SEGA Saturn'),
('Sifteo Cubes',NULL,NULL,'Sifteo Cubes'),
('Stadia',NULL,NULL,'Stadia'),
('Steam',NULL,NULL,'Steam'),
('Steam OS',NULL,NULL,'Steam'),
('Super Nintendo', 'SNES', 'SNES', 'SNES'),
('The400 Mini',NULL,NULL,'The400 Mini'),
('VG Pocket',NULL,NULL,'VG Pocket'),
('Virtual Boy',NULL,NULL,'Virtual Boy'),
('Web Browser', 'Web',NULL,'Web Browser'),
('Web TV',NULL,NULL,'Web TV'),
('Wii','Wii', 'Wii', 'Wii'),
('Wii U','Wii U', 'WiiU', 'Wii U'),
('Win CE',NULL,NULL,'Win CE'),
('Windows CE',NULL,NULL,'Windows CE'),
('Windows PC', 'PC', 'PC', 'Windows PC'),
('Windows Phone',NULL,NULL,'Windows Phone'),
('Xbox','Xbox','XB','Xbox'),
('Xbox 360','Xbox 360','X360', 'Xbox 360'),
('Xbox One','Xbox One','XOne', 'Xbox One'),
('Xbox One X', 'Xbox One','XOne','Xbox One'),
('Xbox Series','Xbox Series S/X',NULL,'Xbox Series'),
('Xbox Series X', 'Xbox Series S/X',NULL,'Xbox Series'),
('Zodiac',NULL,NULL,'Zodiac'),
('iOS','iOS',NULL,'iOS'),
('iPAD',NULL,NULL,'iOS'),
('iPad',NULL,NULL,'iOS'),
('iPod',NULL,NULL,'iOS'),
('iPod Touch',NULL,NULL,'iOS');

SELECT * FROM platforms;

ALTER TABLE platforms ADD COLUMN platform_id SERIAL PRIMARY KEY;

DROP TABLE gameinfo4;

CREATE TABLE gameinfo4 AS (
    SELECT *
    FROM gameinfo1 a
    FULL JOIN Platforms b
    ON a.platform = b.gameinfo1
);

SELECT * FROM gameinfo4 LIMIT 1;

ALTER TABLE gameinfo4
DROP COLUMN platform,
DROP COLUMN gameinfo1,
DROP COLUMN platform_id;

ALTER TABLE gameinfo4
RENAME COLUMN gameinfo2 TO Platform;

DROP TABLE gameinfo;

CREATE TABLE gameinfo AS (
    SELECT * 
    FROM gameinfo4 a
    FULL JOIN gameinfo2 b
    USING (name, platform)
   );

SELECT * FROM gameinfo LIMIT 1;

ALTER TABLE gameinfo
DROP COLUMN platform;

ALTER TABLE gameinfo
RENAME COLUMN esrb TO Platform;

ALTER TABLE gameinfo
RENAME COLUMN name TO Game_Title;

SELECT * FROM gameinfo LIMIT 25;

DROP TABLE Combined;

CREATE TABLE Combined1 AS (
    SELECT *
    FROM multirow
    LEFT JOIN gameinfo
    USING (Game_Title, platform)
    
);

SELECT * FROM Combined1 LIMIT 1;

SELECT translation, COUNT(translation) 
FROM Combined
GROUP BY translation;

SELECT * FROM datedMultiRow LIMIT 1;

*/

SELECT COUNT(*) FROM testgames WHERE consoles<>'Null';


CREATE TABLE mergetest AS(
    SELECT *
    FROM rawdata

);

-- Begin Transforming the raw data
CREATE TABLE multirow2 AS
(
SELECT 
Game_Title,
UNNEST(regexp_split_to_array(Consoles,', ')) AS Platform,
ESRB_Rating,
Content_Descriptors,
Interactive_Elements,
Content_Summary
FROM mergetest
);

SELECT COUNT(*) FROM multirow2 WHERE platform<>'Null';

-- for mid sentence consoles
UPDATE multirow2
SET Interactive_Elements = REGEXP_REPLACE(Interactive_Elements, '\s\([-A-Za-z,\s0-9]*\)(?=[A-Z])', ', ');
-- for end sentence consoles
UPDATE multirow2
SET Interactive_Elements = REGEXP_REPLACE(Interactive_Elements, '\s\([-A-Za-z,\s0-9]*\)(?=$)', '.');
-- for end sentence consoles
UPDATE multirow2
SET Interactive_Elements = REGEXP_REPLACE(Interactive_Elements, '\s\([-A-Za-z,\s0-9]*\(.*\)\)', '.');


-- Add dates and other ancillary data to the scraped esrb rows
CREATE TABLE datedMultiRow2 AS (
    SELECT *
    FROM multirow2
    LEFT JOIN gameinfo
    USING (Game_Title, platform)
    
);

SELECT * FROM gameinfo LIMIT 1;

SELECT COUNT(*) FROM datedMultiRow2 WHERE platform<>'Null';

/*markdown
This will take a cell of a column and split it into other columns in that row.
https://stackoverflow.com/questions/70019118/split-a-string-column-to-new-columns-postgresql

*/

with the_table(s) AS 
(
SELECT content_descriptors FROM descriptorSep
),
arr(a) AS 
(
 SELECT string_to_array(s,',') FROM the_table
)
-- select 
--   a[1] c1,a[2] c2,a[3] c3,a[4] c4,a[5]  c5,
--   a[6] c6,a[7] c7,a[8] c8,a[9] c9,a[10] c10 -- ...
-- from arr;
SELECT  a[1] AS a[1]
-- take the first element in the cell and add it to the column whose name matches that element

--   a[2] a[2],
--   a[3] a[3],
--   a[4] a[4],
--   a[5] a[5],
--   a[6] a[6],
--   a[7] a[7],
--   a[8] a[8],
--   a[9] a[9],
--   a[10] a[10] -- ...
FROM arr;

-- I think at the end, you will have collumns full of XB or Null, for example. Maybe change that to 1 or 0