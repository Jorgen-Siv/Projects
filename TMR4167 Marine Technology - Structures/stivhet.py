import numpy as np

from lokalstivhet import lokalK
from transstivhet import transstivhet

def stivhet(nelem, elem, elementlengder, npunkt,punkt, geoArr, EIArr):
    K= np.zeros((npunkt*3,npunkt*3)) #Setter opp matrise 3*knutepunkt x 3*knutepunkt i størrelse 
    for i in range(nelem): #Itererer over alle bjelkeelementene
        #Henter den lokale stivhetsmatrisen for bjelken
        k_lokal=lokalK(nelem, elem, i, elementlengder,punkt, npunkt, geoArr, EIArr) 
        k_global=transstivhet(k_lokal, elem, i, punkt) #Gjør den om til globale verdier
        
        #Ende 1 og 2
        en=int(elem[i][0])
        to=int(elem[i][1])

        #Plasser verdiene på riktig plass i den totale stivhetsmatrisen
        for j in range (3):
            for k in range(3):
                K[3*en + j][3*en+k]+=k_global[j][k] #Ende 11 
                K[3*en + j][3*to+k]+=k_global[j][k+3] #Ende 12
                K[3*to + j][3*en+k]+=k_global[j+3][k] #Ende 21
                K[3*to + j][3*to+k]+=k_global[j+3][k+3] #Ende 22

    return K

