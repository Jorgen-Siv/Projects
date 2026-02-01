import numpy as np

def lesinput():
 
    # Åpner inputfilen
    fid = open("jacket.txt", "r")
 
    # Leser totalt antall punkt
    npunkt = int(fid.readline())       # 'fid.readline()' leser en linje, 'int(...)' gjør at linjen tolkes som et heltall
 
    # LESER INN XY-KOORDINATER TIL KNUTEPUNKTENE
    # Nodenummer tilsvarer radnummer i "Node-variabel"
    # x-koordinat lagres i kolonne 1, y-koordinat i kolonne 2
    # Grensebetingelse lagres i kolonne 3; 1 = fast innspent og 0 = fri rotasjon
    punkt = np.loadtxt(fid, dtype = int, max_rows = npunkt)     # 'max_rows = npunkt' sorger for at vi bare leser
                                                                # de 'npunkt' neste linjene i tekstfilen
    ngeo=int(fid.readline()) 
    geoArr=np.loadtxt(fid, dtype = float, max_rows = ngeo)
    # Leser antall elementer
    nelem = int(fid.readline())
 
    # Leser konnektivitet: Sammenheng mellom elementender og knutepunktnummer samt EI for elementene
    # Elementnummer tilsvarer radnummer i "elem"-variabel
    # Knutepunktnummer for lokal ende 1 lagres i kolonne 1
    # Knutepunktnummer for lokal ende 2 lagres i kolonne 2
    # Det anbefales at knutepunktnummerering starter på 0, slik at det samsvarerer med listeindeksering i Python
    # E-modul for materiale lagres i kolonne 3
    # Tverrsnittstype lagres i kolonne 4; I-profil = 1 og rørprofil = 2
    elem = np.loadtxt(fid, dtype = float, max_rows = nelem)
 
    # Leser antall laster som virker på rammen
    nlast = int(fid.readline())
 
    # Leser lastdata
    # Bestem selv verdiene som er nødvendig å lese inn, samt hva verdiene som leses inn skal representere
    last = np.loadtxt(fid, dtype = float, max_rows = nlast)     # <-- Forslag til innlesing av lastdata
 
    # Lukker input-filen
    fid.close()
 
    return npunkt, punkt, nelem, elem, nlast, last, ngeo, geoArr