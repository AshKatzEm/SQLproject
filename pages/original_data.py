import streamlit as st
import pandas as pd
import numpy as np
import plotly.express as px
import json


@st.cache_resource
def load_data(fp):
    print('Running load_data...')

    # read in the csv via the link
    df = pd.read_csv(fp)

    return(df)


st.set_page_config(
    page_title="Original Data"
    )


st.header("Original Video Game Data")

st.write("This is the original data.")

original_data = "data/complete_raw_dataset.csv"
df = pd.read_csv(original_data)




st.dataframe(data=df)
