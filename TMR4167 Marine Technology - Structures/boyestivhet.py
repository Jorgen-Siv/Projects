import numpy as np

def boyestivhet(elem, geoArray):
    EI=[] #Lager et array for å lagre alle EI-verdiene
    for el in elem:
        elindex=int(el[3]) #Geometri index
        if elindex==3 or elindex==4 or elindex==5: #Rør 
            #Henter relevant info
            R=geoArray[elindex-1][0]
            r= R-geoArray[elindex-1][1]
            I=np.pi*(R**4-r**4)*(1/4) #Formel for I hvis Rør-profil
            EI.append(el[2] * I)  #Legger til i Arrayet
        elif elindex==1: #I_profil 
            #Henter info om I-profilet
            hsteg=geoArray[elindex-1][0]
            bsteg=geoArray[elindex-1][1]
            hflens=geoArray[elindex-1][2]
            bflens=geoArray[elindex-1][3]
            hoyde=2*hflens+hsteg #Total høyden til profilet
            #Finner I for et rektangulært tversniit og fjerner to identiske firkanter for å skape I_profilet
            I=1/12*(bflens*hoyde**3) - 2*(1/12)*(bflens/2 - bsteg/2)*hsteg**3
            EI.append(el[2]*I) #Legger til i Arrayet
        elif elindex==2: #Hvis boksprofil 
            hoyde=geoArray[elindex-1][0] #Høyde
            bredde=geoArray[elindex-1][1]  #Bredde
            h_i=hoyde-2*geoArray[elindex-1][2]
            b_i=bredde-2*geoArray[elindex-1][2]
            I=1/12*bredde*hoyde**3 -1/12*b_i*h_i**3#I for et rektangulært tverrsnitt
            EI.append(el[2]*I) #Legger til i Arrayet
    return EI