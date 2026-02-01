import numpy as np
from vinkel import vinkel

def lastvektor(fim, npunkt, punkt, nelem, elem, fik,last):
    lastv=np.zeros((npunkt, 3))
    
    for i in range(nelem):
        #Henter vinkel
        vink=vinkel(elem[i], punkt)
        
        #Legger til fastinnspenningsmomentene i lastvektor 
        lastv[int(elem[i][0])][2]+= -fim[i][0]
        lastv[int(elem[i][1])][2]+= -fim[i][1]

        #Legger til fastinnspenningskreftene i z-retning
        lastv[int(elem[i][0])][1] += -fik[i][0]*np.cos(vink)
        lastv[int(elem[i][1])][1] += -fik[i][1]*np.cos(vink)

        #Legger til fastinnspenningskrefter i x-retning
        lastv[int(elem[i][0])][0] += -fik[i][0]*-np.sin(vink)
        lastv[int(elem[i][1])][0] += -fik[i][1]*-np.sin(vink)

    for l in last: #Itererer over lastene
        if l[0]==2: #Hvis last er knutepunktslast
            vk= l[4] #Kraftvinkel
            p=l[2]
            vb= vinkel(elem[int(l[1])-1], punkt) #Bjelkevinkel
            kpunkt= int(elem[int(l[1])][int(l[3])]) #Henter knutepunkt

            vink=vk+vb #Finner total vinkel
            fx= p*-np.cos(vink) #Kraft i global x-verdi
            fz=p*np.sin(vink) # Kraft i global z-verdi
            #Legger verdier på riktig plass
            lastv[kpunkt][0]+= - fx  
            lastv[kpunkt][1]+= - fz

    return lastv









