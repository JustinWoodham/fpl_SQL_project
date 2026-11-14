import requests
import json
import pandas as pd
from sqlalchemy import create_engine

managerInfo = 'https://fantasy.premierleague.com/api/entry/8746052/history/'
leagueInfo = 'https://fantasy.premierleague.com/api/leagues-classic/781206/standings/'
gwInfo = 'https://fantasy.premierleague.com/api/entry/8746052/event/7/picks/'
bootstrap = 'https://fantasy.premierleague.com/api/bootstrap-static/'

# League from home = 781206


r = requests.get(managerInfo).json()
l = requests.get(leagueInfo).json()
g = requests.get(gwInfo).json()
bootstrap = requests.get(bootstrap).json()


elements = bootstrap['elements']
teams = bootstrap['teams']

def makeJson(api, name):
    with open(name , "w") as f:
        json.dump(api, f, indent=2)


#makeJson(teams, 'team_data')

dataframe = pd.json_normalize(teams)

#print(dataframe)
#print(dataframe.columns.tolist())
df = dataframe.drop(['code', 'draw', 'form', 'loss', 'played', 'points', 'position', 'strength', 
                     'team_division', 'unavailable', 'win', 'link_url', 'strength_attack_home', 
                     'strength_attack_away', 'strength_defence_home', 'strength_defence_away', 'pulse_id'], axis=1)


print(df)

#URL Format: dialect+driver://username:password@host:port/database

#SQL ALCHEMY STUFF""" 

link = 'postgresql+psycopg2://postgres:Bs153ej123!@localhost5432/fpl'

#engine = create_engine(link)