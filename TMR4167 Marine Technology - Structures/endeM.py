import numpy as np
from lagT import lag_T
from lokalstivhet import lokalK
from vinkel import vinkel

def endeM(npunkt, punkt, nelem, elem, elementlengder, rot, fim, fik,geoArr,EIArr):
    S_total=np.zeros((nelem,6)) #Lager et 2D-array (3 x antall punkter) for å lagre alle resultatene
    for i in range(nelem): #Itererer over alle bjelkene
        #Henter punktene på bjelken
        p1=int(elem[i][0])
        p2=int(elem[i][1])

        #Henter r som vil være rotasjoner og deformasjoner for systemet
        #rot[3*p1] vil tilsvare u_1, rot[3*p1+1] = w_1 og rot[3*p1+2] = omega_1 osv.
        r=[rot[3*p1],rot[3*p1+1],rot[3*p1+2],rot[3*p2],rot[3*p2+1],rot[3*p2+2]]

        vink=vinkel(elem[i], punkt) #Vinkel til bjelken i forhold til x-aksen
        T=lag_T(vink) #Lager transformasjonsmatrisen
        T_t=T.transpose() #Transpondert transformasjonsmatrise
        V= np.dot(r, T_t) #Regner ut Element forskyvningene
        k=lokalK(nelem, elem, i,  elementlengder,punkt, npunkt, geoArr, EIArr) #Finner lokalstivhetsmatrise
        #S_bar er fastinnspenningskrefter og momenter
        #S_bar=[fik[p1][0], fik[p1][1], fim[i][0],fik[p2][0], fik[p2][1], fim[i][1]]
        S_bar=[0, fik[i][0], fim[i][0],0, fik[i][1], fim[i][1]]
        S_1=np.dot(k,V) #Midlertidig verdi
        S=S_1+S_bar #Spenningsresultant for bjelke

        S_total[i]+=[S[0],S[1],S[2],S[3],S[4],S[5]] #verdiene lagres
    return S_total