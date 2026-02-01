import numpy as np

def moment(npunkt, punkt, nelem, elem, nlast, last, elementlengder, geoArr):
    fimoment= np.zeros((nelem, 2))
    for l in last: #Itererer over lastene 
        if l[0] == 0: #Hvis punktlast på bjelke 
            P=l[2] #Henter kraft
            element= int(l[1]) #Henter hvilket element
            lengde=elementlengder[element] #Lengde
            avstand= l[3]*lengde #Avstand fra punktlast til lokal ende 1
            a=avstand 
            b=lengde-avstand #Avstand til b
            if l[3]==0 or l[3]==1: #I knutepunkt
                M1= -P*a
                M2=P*b
            else: #Ikke i knute punkt, Fra formelsamling for fastinnspenningsmomenter
                M1= - P *a*b**2/lengde**2 
                M2= P *a**2*b/lengde**2
            fimoment[element][0]+=M1
            fimoment[element][1]+=M2
        elif int(l[0]) ==1: #Hvis fordelt last 
            element= int(l[1]) #Henter hvilket element
            D=2*geoArr[int(elem[element][3])-1][0] #Finner Diameter
            #Finner q1 og q2
            q1=l[2]*D/1.5
            q2=l[3]*D/1.5

            lengde=elementlengder[element]#Lengde
            #Bruker formler for fastinnspenningsmpment
            if punkt[int(elem[element][0])][1] <punkt[int(elem[element][1])][1]: #Lokal ende "nederst"
                #M1 og M2 fra q2 (firkantlast)
                M1q2= -1/12 *q2*lengde**2
                M2q2= 1/12 *q2*lengde**2
                #M1 og M2 fra trekant last q1-q2
                M1q1= -1/30 *(q1-q2)*lengde**2
                M2q1= 1/20 *(q1-q2)*lengde**2
            
            else: #Lokal ende "øverest", blir motsatt av den andre situasjonen
                M2q2= -1/12 *q2*lengde**2
                M1q2= 1/12 *q2*lengde**2
                M2q1= -1/30 *(q1-q2)*lengde**2
                M1q1= 1/20 *(q1-q2)*lengde**2
            #Legger verdiene inn i arrayet
            fimoment[element][0]+=M1q1 + M1q2
            fimoment[element][1]+=M2q1+ M2q2

    return fimoment
            

            

            


