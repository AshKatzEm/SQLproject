import streamlit as st
import pandas as pd
import numpy as np


st.set_page_config(
    page_title="About"
    )

st.write("The three of us trained a model and created this app to showcase it.")

st.write("The final model used was a Random Forest classifier.")

st.write("It was selected based on trials with a number of different models such as DecisionTreeClassifier, MultinomialNB, and gb.XGBClassifier Kmeans, as it was the best performing.")

st.write("It was trained on about 2300 rows of data.")



cleaned_data = "data/Cleaned_complete_dataset.csv"


df = pd.read_csv(cleaned_data)


st.subheader('First 5 rows of the data after some cleaning.')

st.dataframe(df[:5])




st.write("The data is composed of games along with their ratings and content descriptions.")

st.write("The model takes in these content descriptions to try and see if there is a pattern for how games are given their age rating.")

st.write("The model was made with the default hyper parameters as after testing multiple variations using CV Grid Search a noticable improvement was not found.")

st.write("As a final touch, we actually scraped the release dates for many of the games and this improved the performance of the model by 5%. Since we could only get  80% of the release dates, the loss in performace there makes it only slighty better then without release dates and a larger dataset")

st.write("The model achieved an accuracy, f1-score and recall of 87%")

st.write("After this the model was then trained on all the data to create the final model.")





