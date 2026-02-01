import numpy as np

def krefter(npunkt, punkt, nelem, elem, nlast, last, elementlengder, geoArr,fim):
    fikrefter=np.zeros((nelem,2)) #2d-array for å lagre kreftene

    for l in last: #Itererer over lastene der l vil være all info om en last
        if l[0]==0: #punktlast på bjelke
            P=l[2] #Henter punktlast verdi
            elemindex=int(l[1]) #Finner hvilken bjelke
            print('elindex', elemindex) 
            #Henter fastinnspenningsmomenter
            M1= fim[elemindex][0]
            M2= fim[elemindex][1]
            #Henter relevant lengdeinfo
            lengde=elementlengder[elemindex]
            a=lengde*l[3]
            b=lengde-a
            #Regner ut F1 og F2 ved hjelp av momentlikevekt
            F1=(P*b - M1 -M2)/lengde
            F2= (P*a + M1 + M2)/lengde
            #Plasserer de på riktig plass
            fikrefter[elemindex][0]+= F1
            fikrefter[elemindex][1]+= F2
        elif l[0]==1: #Fordelt last
            #Henter hvilken bjelke og lengde
            elemindex=int(l[1])
            lengde=elementlengder[elemindex]

            #Henter diameter og regner ut q1 og q2
            D=2*geoArr[int(elem[elemindex-1][3])-1][0]
            q1=l[2]*D/1.5
            q2=l[3]*D/1.5
            #Henter fastinnspenningsmomenter
            M1= fim[elemindex][0]
            M2= fim[elemindex][1]
            #Sjekker hvordan lokal ende 1 ligger i forhold til den fordelte laste
            #Blir motsatt utregning for lokal ende "øverst" og lokal ende "nederst"
            if punkt[int(elem[elemindex][0])][1] <punkt[int(elem[elemindex][1])][1]: #Ende 1 nederst 
                #Bruker moment likevekt for å beregne F1 og F2
                F1=(M1+M2-(1/6)*(q1-q2)*lengde**2 - (1/2)*q2*lengde**2)/lengde 
                F2=(-M1-M2-(2/6)*(q1-q2)*lengde**2 - (1/2)*q2*lengde**2)/lengde
                #Legger de på riktig sted
                fikrefter[elemindex][0]+= F1
                fikrefter[elemindex][1]+= F2
            else: #Ende 2 nederst
                #Bruker moment likevekt for å beregne F1 og F2
                F1=(-M1-M2-(2/6)*(q1-q2)*lengde**2 - (1/2)*q2*lengde**2)/lengde
                F2=(M1+M2-(1/6)*(q1-q2)*lengde**2 - (1/2)*q2*lengde**2)/lengde
                #Legger kreftene på riktig sted i arrayet
                fikrefter[elemindex][0]+= F1
                fikrefter[elemindex][1]+= F2
    
    return fikrefter
            