# Data analysis for Fantasy Premier League
This project was created to develop more advanced skills on PostgreSQL and to gain exposure on numerous processes such as: data Extraction, Transformation and Loading (ETL), Database creation and management using PGadmin4, and creating relationships between tables.

By complex SQL queries on extracted API data, I hope to provide further insight and analytics into FPL and Football in a general sense, by consturcting queries that produce outputs that is not provided on the application.

This includes:
 - Which teams has the easiest upcoming fixtures as a singular average
 - Which players in each position are the best value picks
 - Which players can be classes as differentials

## Data
Data is retrieved from the open source Fantasy Premier League API endpoints. I have categorised the types of data available into manager data and football data.

Manager data covers the more individual and personal aspects of the API such as Managers points history, leagues entered and standings.

Football data involves everything to do with players, clubs and the Premier league table. This includes data on every player, every fixture, all clubs whilst including FPL attributes like player cost, ICT and fixture difficulty.

For this project I have used Football data.

### Data Extraction

For data extraction, a Python Jupyter notebook is used to call the endpoints through requests
```
bootstrap = 'https://fantasy.premierleague.com/api/bootstrap-static/'
fixtures = 'https://fantasy.premierleague.com/api/fixtures/'
players = 'https://fantasy.premierleague.com/api/elements'
```

`bootstrap['teams']` retrieves all relevant information on teams\
`fixtures` retrieves all 380 fixtures of the season which includes ones to be played\
`players` retrieves data for every Premier league player including their FPL points and cost

### Data Transformation
The data extracted contains many attributes which are not neccessary, for example the players endpoint contains 109 fields. Therefore many columns are dropped.

Each endpoint called is converted into json form, this step allows the data to be stored as a json file to be viewed in full detail, in a more organised form. To handle and manipulate the endpoints, the json files are then normalized into pandas dataframes such as: `pd.json_normalize(fixtureAPI)`

To make sure the data is in the correct form to load onto a database, columns are dropped, and some are renamed. This is especially important for primary keys and foreign keys, maintaining consistent naming conventions allows the fields to be referenced for other tables which is essential for table joins. Further transformation is done on certain columns that need specific data types, such as `['kickoff_time']` to date_time and `['finished']` to boolean.
