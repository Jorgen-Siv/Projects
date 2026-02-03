# GroupUp

GroupUp er en platform for deg som har lyst til å finne mennesker med like interesser for å danne grupper som møtes.

Under er det noen steg som man må gjennom for å sette opp GroupUp.

- Installer postgres https://www.postgresql.org/download/ 
- Hver gang du blir spurt om å lage et passord under installasjonen eller på postgres 
bruker du passordet: groupup29
- Trykk 'Next' på alle stegene, men når du blir spurt om "Launch Stack Builder at exit?", huker du av alternativet slik at du ikke åpner stack builder,
og trykker 'Finish'.
- Søk på "pgAdmin 4" i søkefeltet på PC-en og åpne programmet. 
- Husk å bruke "groupup29" som passord. 
- Åpne servers (trykk på pilen til venstre for servers)
- Høyreklikk på databaser -> Create database 
- Kall databasen for "groupupdb" -> trykk save

--------------------------------------------------------------------------------------------------------------------------------          
- pip install requirements.txt
- pipenv shell
- cd groupupwebsite
- python manage.py makemigrations
- python manage.py migrate 
- python manage.py runserver
- Åpne localhost: http://127.0.0.1:8000/ 
