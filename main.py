# -*- coding: utf-8 -*-
import re
import pandas as pd
import numpy as np
import os
import time
import psycopg2
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.firefox.options import Options
# for postgreSQL database credentials. user, password, host, port, database
from config import config
from connect import connect

# sequential directories as data gets cleaned and sorted
download_path = "/Users/asherkatz/GoogleDrive/My Drive/SQLproject/"
options = Options()
options.set_preference("browser.download.folderList", 2)
options.set_preference("browser.download.manager.showWhenStarting", False)
options.set_preference("browser.download.dir", download_path)
options.set_preference("browser.helperApps.neverAsk.saveToDisk", "application/x-gzip")


if __name__ == '__main__':
    connection = connect()
    curs = connection.cursor()

    # Create the Combined table DO NOT DROP COMBINED EVER

    curs.execute("""
                    CREATE TABLE Combined (
                    id SERIAL PRIMARY KEY,
                    game_title TEXT,
                    platform TEXT,
                    esrb_rating TEXT,
                    content_descriptors TEXT,
                    interactive_elements TEXT,
                    content_summary TEXT
                    );
                    """)
    print(curs.statusmessage, ' Combined')
    connection.commit()

    # create webdriver object and sets the profile as defined above.
    driver = webdriver.Firefox()

    real = ['e','i', 'o', 'u', 'y']
    test = ['asher', 'shark']
    # quizziz visit
    driver.get("https://www.esrb.org")


    for vowel in test:
        time.sleep(1)
        # Find the search bar and select it
        barxpath=  "/html/body/div[1]/div[1]/div/div[1]/div[2]/div/div[1]/div/form/input"
        searchbar = WebDriverWait(driver,10).until(EC.element_to_be_clickable((By.XPATH,barxpath)))
        searchbar.send_keys(vowel)

        time.sleep(1)
        # Find the search button for the search bar
        buttonxpath= "/html/body/div[1]/div[1]/div/div[1]/div[2]/div/div[1]/div/form/button/i"
        searchbutton = WebDriverWait(driver,10).until(EC.element_to_be_clickable((By.XPATH, buttonxpath)))
        searchbutton.click()

        #These are the columns of the backup CSV
        columns = ["Game_Title", "Consoles", "ESRB_Rating", "Content_Descriptors", "Interactive_Elements", "Content_Summary" ]
        #This will hold the rows of the CSV
        rows=[]

        # This is the table where all of the data from this vowel will be stored
        curs.execute("""CREATE TABLE rawdata (
                        Game_Title TEXT,
                        Consoles TEXT,
                        ESRB_Rating TEXT,
                        Content_Descriptors TEXT,
                        Interactive_Elements TEXT,
                        Content_Summary  TEXT
                    );
                    """)
        print(curs.statusmessage, ' rawdata')
    # Make the changes to the database persistent
        connection.commit()

        # We get to a page
        while True:
            try:

                time.sleep(1) #Rate limiter

                # loop through all ten entries
                for i in range(1,11):
                    row = {}
                    
                    #get data paths
                    titlexpath=      "/html/body/div[1]/div[1]/div/div/div/div[2]/div/div[" + str(i) + "]/div[1]/h2/a"
                    consolexpath=    "/html/body/div[1]/div[1]/div/div/div/div[2]/div/div[" + str(i) + "]/div[1]/div"
                    ratingxpath=     "/html/body/div[1]/div[1]/div/div/div/div[2]/div/div[" + str(i) + "]/div[2]/table/tbody/tr[2]/td[1]/img"
                    descriptorxpath= "/html/body/div[1]/div[1]/div/div/div/div[2]/div/div[" + str(i) + "]/div[2]/table/tbody/tr[2]/td[2]"
                    interactivexpath="/html/body/div[1]/div[1]/div/div/div/div[2]/div/div[" + str(i) + "]/div[2]/table/tbody/tr[2]/td[3]"
                    summaryxpath=    "/html/body/div[1]/div[1]/div/div/div/div[2]/div/div[" + str(i) + "]/div[2]/table/tbody/tr[2]/td[4]"
                    

                    #get title element
                    title = WebDriverWait(driver,10).until(EC.element_to_be_clickable((By.XPATH, titlexpath)))
                    #get title text
                    titletext=title.text.replace("'","''")
                    #backup csv
                    row[columns[0]] =titletext

                    consoles= WebDriverWait(driver,10).until(EC.element_to_be_clickable((By.XPATH, consolexpath)))
                    # Get consoles text
                    consolestext=consoles.text.replace("'","''")
                    #backup csv
                    row[columns[1]] = consolestext

                    rating= WebDriverWait(driver,10).until(EC.element_to_be_clickable((By.XPATH, ratingxpath)))
                    #alt text of image should be M or other etc.
                    ratingstext=rating.get_attribute('alt').replace("'","''")
                    #backup csv
                    row[columns[2]] = ratingstext

                    descriptors=WebDriverWait(driver,10).until(EC.element_to_be_clickable((By.XPATH, descriptorxpath)))
                    # Get properly formatted descriptors text
                    descriptorstext=str(descriptors.text).replace("<br>","").replace("\n", "").replace("'","''")
                    #backup csv
                    row[columns[3]] = descriptorstext

                    interactives=WebDriverWait(driver,10).until(EC.element_to_be_clickable((By.XPATH, interactivexpath)))
                    # Get properly formatted interactive elements text
                    interactivestext=str(interactives.text).replace("<br>","").replace("\n", "").replace("'","''")
                    #backup csv
                    row[columns[4]] = interactivestext

                    summary= WebDriverWait(driver,10).until(EC.element_to_be_clickable((By.XPATH, summaryxpath)))
                    # Get properly formatted summary text
                    summarytext=str(summary.text).replace("<br>","").replace("\n", "").replace("'","''")
                    #backup csv
                    row[columns[5]] =summarytext

                    

                    curs.execute(f"""INSERT INTO rawdata (Game_Title, Consoles, ESRB_Rating, Content_Descriptors, Interactive_Elements, Content_Summary)
                                 VALUES ('{titletext}','{consolestext}','{ratingstext}', '{descriptorstext}', '{interactivestext}', '{summarytext}');
                                 """)
                    #backup csv
                    rows.append(row)
                    
                    print("Scraped row", i, ' ' + curs.statusmessage)
                    # time.sleep(2) #Rate limiter
                    

                # Commit this page and go to the next
                connection.commit()
                curs.execute("""SELECT * FROM rawdata;
                                """)
                print("rawdata has ", curs.rowcount, " rows")
                #Find the next button
                nextbutton = driver.find_element(By.CLASS_NAME, "next")     
                nextbutton.click()

            except Exception as e:
                print(e)
                df = pd.DataFrame.from_records(rows)
                print("Saving backup csv of scraped data...")
                df.to_csv(download_path+vowel+'gameBackup.csv', index=False)
                # Whatever has gone wrong or that we reached an end, just commit the rawdata and begin transforming it
                print("Committing raw data in warehouse, transforming it and merging with transformed datastore...")
                connection.commit()
                curs.execute("""SELECT * FROM rawdata;
                                """)
                print("rawdata has ", curs.rowcount, " rows")
                curs.execute("""CREATE TABLE multirow AS
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
                                """)
                print("CREATE TABLE multirow from rawdata ", curs.rowcount, ' rows')
                
                curs.execute("""DELETE FROM multirow WHERE Platform='etc.)';
                                """)
                print(curs.statusmessage)
                curs.execute("""-- for mid sentence consoles
                                UPDATE multirow
                                SET Interactive_Elements = REGEXP_REPLACE(Interactive_Elements, '\s\([-A-Za-z,\s0-9]*\)(?=[A-Z])', ', ');
                                """)
                print(curs.statusmessage)
                curs.execute("""-- for end sentence consoles
                                UPDATE multirow
                                SET Interactive_Elements = REGEXP_REPLACE(Interactive_Elements, '\s\([-A-Za-z,\s0-9]*\)(?=$)', '.');
                                """)
                print(curs.statusmessage)
                curs.execute("""-- for end sentence consoles
                                UPDATE multirow
                                SET Interactive_Elements = REGEXP_REPLACE(Interactive_Elements, '\s\([-A-Za-z,\s0-9]*\(.*\)\)', '.');
                                """)
                print(curs.statusmessage)
                curs.execute("""-- Add the multirow data to the combined table
                                INSERT INTO Combined (game_title,platform,esrb_rating,content_descriptors,interactive_elements,content_summary)
                                SELECT game_title,platform,esrb_rating,content_descriptors,interactive_elements,content_summary
                                FROM multirow;
                                """)
                print(curs.statusmessage)
                curs.execute("""-- Deletes perfect duplicate rows from Combined, since much of multirow is probably games already in Combined
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
                                """)
                print(curs.statusmessage)
                curs.execute("""SELECT * FROM Combined;
                                """)
                print("Combined has ", curs.rowcount)
                curs.execute("""DROP TABLE rawdata;
                                DROP TABLE multirow;
                                """)
                connection.commit()


                # Go to the next vowel
                break
        # Find home button
        homexpath= "/html/body/div[1]/header/div[2]/div/div/div[2]/a"
        homebutton = WebDriverWait(driver,10).until(EC.element_to_be_clickable((By.XPATH, homexpath)))
        homebutton.click()

    
    # After all of the data has been scraped and added to the Combined table, add the supplemental data
    curs.execute("""CREATE TABLE Combined2 AS (
                    SELECT *
                    FROM Combined a
                    LEFT JOIN Platforms b
                    on a.platform = b.esrb
                );
                     """)
    print(curs.statusmessage, ' Combined2')

    curs.execute("""-- Left Join on gamedata1 USING ( game_title, gamedata1);
                    CREATE TABLE Combined3 AS (
                        SELECT * 
                        FROM Combined2 a
                        LEFT JOIN gameinfo1 b
                        USING (game_title, gameinfo1)
                    );
                     """)
    print(curs.statusmessage, ' Combined3')

    curs.execute("""-- * Left Join on gamedata2 USING ( game_title, gamedata2);
                    CREATE TABLE Combined4 AS (
                        SELECT * 
                        FROM Combined3 a
                        LEFT JOIN gameinfo2 b
                        USING (game_title, gameinfo2)
                    );
                     """)
    print(curs.statusmessage, ' Combined4')

    curs.execute("""-- Deletes all rows which are perfect duplicates
                    DELETE FROM
                        Combined4 a 
                            USING Combined4 b
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
                     """)
    print(curs.statusmessage, ' Combined4')

    curs.execute("""ALTER TABLE Combined4
                    DROP COLUMN gameinfo1,
                    DROP COLUMN gameinfo2,
                    DROP COLUMN esrb,
                    DROP COLUMN platform,
                    DROP COLUMN platform_id;
                     """)
    print(curs.statusmessage, ' Combined4')

    curs.execute("""ALTER TABLE Combined4
                    RENAME COLUMN translation TO Platform;
                     """)
    print(curs.statusmessage, ' Combined4')
    connection.commit()


    
    curs.close()
    connection.close()

