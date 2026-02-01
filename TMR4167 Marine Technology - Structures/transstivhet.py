import numpy as np
from lagT import lag_T

from vinkel import vinkel
def transstivhet(k, elem, elemindex, punkt): #k_trans 
    #k_g=T dot k dot T^t
    
    V= vinkel(elem[elemindex], punkt) #Henter vinkelen til bjelken i forhold til x-aksen
    T=lag_T(V) #Lager transformasjonsmatrisen for Vinkelen V
    temp=np.matmul(T,k) #Matrise multiplikasjon T og k 

    #Regner ut k_g
    k_g=np.matmul(temp, np.transpose(T))

    return k_g



