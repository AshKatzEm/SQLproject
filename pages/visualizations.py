import streamlit as st
import pandas as pd
import numpy as np
import plotly.express as px
import plotly.graph_objects as go


st.set_page_config(
    page_title="Visuals"
)

st.header("View rating and reasoning distribution")

cleaned_data = "https://raw.githubusercontent.com/HA-work/esrb_project/main/data/cleaned_games.csv"

df = pd.read_csv('data/cleaned_games.csv')


esrb_list = sorted(df['esrb_rating'].unique())

selected_ESRB = st.multiselect(
    'Select which rating to view.',
    esrb_list,
    default=['E']
)

many_shown = st.selectbox(
    'choose which top',
    [5,10,15,20,25,30],
)


ESRB_df = df[df['esrb_rating'].isin(selected_ESRB)].copy()
reasonings= ESRB_df.columns.tolist()
not_needed=['title',"strong_language","num_descriptors","esrb_encoded"]
for items in not_needed:
    reasonings.remove(items)
ESRB_df=ESRB_df[reasonings]


fig = go.Figure()
data = []
for items in selected_ESRB:
    dfone=ESRB_df[ESRB_df['esrb_rating'] == (items)]
    dfone = dfone.swapaxes("index", "columns")
    dfone['sum'] = dfone.drop('esrb_rating', axis=0).sum(axis=1)
    dfone=dfone.drop('esrb_rating', axis=0)
    dfone['reasons']=dfone.index
    dfone=dfone.sort_values(['sum'],ascending=False).head(many_shown)
    data.append(go.Bar(
        x=dfone['sum'],
        y=dfone[ 'reasons'],
        name=items,
        orientation='h'
        ))

fig = go.Figure(data=data)

fig.update_layout(
    autosize=False,
    bargroupgap=0,
    bargap=0.35,
    barmode='stack',
    width=1080,
    height=1000,
    yaxis={'categoryorder':'total ascending'}
)
fig.update_yaxes(automargin=True)

st.plotly_chart(fig, use_container_width=True)