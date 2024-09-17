import streamlit as st
import pandas as pd
import numpy as np
import pickle
import plotly.express as px
import re
# added this to try and save resources

# not sure why I got the mutation warning when I do not change the model

@st.cache_resource(experimental_allow_widgets=True)
def load_model():
    return pickle.load(open("models/final_model2.pkl", 'rb'))


st.set_page_config(
    page_title="ESRB Prediction",
    page_icon="👋",
)

# Create a page header

st.header("Videogame ESRB Prediction")

st.write("Hello! 👋")

st.write("This is a website made to showcase a model to predict the ESRB ratings of Video Games")





# Load the model you already created...
final_model = load_model()

# Begin user inputs



#read in the csv to get the features
cleaned_data = "data/final_model_data.csv"
df = pd.read_csv(cleaned_data)



st.subheader('Rating Predictor.')

st.write("Below you can enter the descriptors of a potential game and your input will be fed into the model and the prediction will be displayed")

st.write("If you want to see the prediction for a game without any descriptors, just fill in the release date and hit the predictor button")



#For the model input
selected_features = list(df.columns) #36
selected_features = [ele for ele in selected_features if ele not in ['game_title', 'esrb_rating', 'content_descriptors',
       'interactive_elements', 'content_summary', 'platform', 'release_date',
       'updated', 'developers', 'genres', 'publisher',
       'na_sales', 'eu_sales', 'jp_sales', 'other_sales', 'global_sales',  'esrb_encoded']]

selected_features = sorted(selected_features)
# For the dropdown list
descriptor_list = selected_features.copy()
descriptor_list.remove("Number of Descriptors") #31
descriptor_list.remove( 'release_year') #30

#allow user to select features 
user_descriptors = st.multiselect('Descriptors', descriptor_list)

#allow user to select a release date
date = st.text_input(label='What year was the game released? YYYY')

# User runs prediction
clicked = st.button('Try out the Predictor?')


if (clicked) and re.compile("[1-2][0-9][0-9][0-9]").match(date):

    #create empty df
    row = {}
    for i in range(len(selected_features)):
        row[selected_features[i]] = [0]
    new_game_df = pd.DataFrame(row) #32

    #add the two non-listed features
    new_game_df.loc[0,"release_year"] = int(date)
    new_game_df.loc[0,"Number of Descriptors"] = len(user_descriptors)

    #add the listed features
    for descriptor in user_descriptors:
        new_game_df.loc[0,descriptor] =1
    
    
    st.write(new_game_df)
    y_pred = final_model.predict(new_game_df)
    
    st.write("The model predicted that your game will be", y_pred)

    if(y_pred == "E" or y_pred==0):
        st.image('images/e_rating.png', width=50)

    elif(y_pred == "ET" or y_pred==1):
        st.image('images/et_rating.png', width=50)

    elif(y_pred == "T" or y_pred==2):
        st.image('images/t_rating.png', width=50)

    elif(y_pred == "M" or y_pred ==3):
        st.image('images/m_rating.png', width=50)
    
    elif(y_pred == "AO" or y_pred ==4):
        st.image('images/ao_rating.png', width=50)

    else:
        st.write("Error")

    y_pred_proba = final_model.predict_proba(new_game_df)
    
    st.write("The probability for each of the categories in order of E, ET, M and T are")
    # maybe create the dataframe?

    ratings = ["E", "ET", "T", "M"]

    # changing the order

    list_prob = list(list(y_pred_proba[0]))

    # having some trouble with it saying I am out of range

    # needed to use the index of 0 from y_pred_proba

    probs = []

    for num in list_prob:
        probs.append(num*100)

    # swapping the T and M probablilities

    #st.write(probs)
    #st.write(probs[0])
    #st.write(probs[2])
    #st.write(probs[3])

    probs[2], probs[3] = probs[3], probs[2],


    paired_vals = list(zip(probs, ratings))

    #st.write(paired_vals)

    prob_df = pd.DataFrame(paired_vals, columns=["Probability", "ESRB Rating"])

    #st.write(probs)

    # maybe better and easier way to do this

    #st.dataframe(prob_df)

    #fig = px.bar( x=ratings, y=probs, title="Rating Probabilities", range_y= [0, 100])

    fig = px.bar(data_frame = prob_df, x="ESRB Rating", y="Probability", title="Rating Probabilities", range_y= [0, 100])

    # how to label the axis?

    # maybe make a dataframe?

    # also would be nice if there was an easy way to see when certain probabilities are very low

    fig.update_layout({
        'plot_bgcolor': 'rgba(0, 0, 0, 0)',
        'paper_bgcolor': 'rgba(0, 0, 0, 0)',
        })

    # changing the grid axes
    fig.update_xaxes(showgrid=False, gridwidth=1, gridcolor='Gray')
    fig.update_yaxes(showgrid=True, gridwidth=1, gridcolor='Gray')

    # display graph
    st.plotly_chart(fig, use_container_width=True)

    # maybe there is a way to sort and to get rid of the key

    # also maybe sort by percent

    # or sort by proper rating order

    # would be nice to set Axes so it is always at max 100

  

    st.balloons()
    # there were this many game with those descriptors:  len of query
    # these are their names, descriptor cell, and ratings: Get indices of each element in the quesry
    resultIndices = []
    for c in user_descriptors:
        if len(resultIndices)>0: 
            resultIndices = resultIndices.intersection(df[df[c]==1].index)
        else:
            resultIndices=df[df[c]==1].index

    if date:
        resultIndices = resultIndices.intersection(df[df['release_year']==int(date)].index)
        st.write("These are the games which have ", ', '.join(user_descriptors), " from ", date)
        st.write(df.iloc[resultIndices])

    else:
        st.write("These are the games which have ", ', '.join(user_descriptors))
        st.write(df.iloc[resultIndices])
                
                
else:
    if clicked:
        st.write("Your release date is not formatted correctly")

