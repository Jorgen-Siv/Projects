import numpy as np

def bc(npunkt, punkt, K, b):
    #Finner punktene som skal er fastinnsspent

    for i in range ( npunkt ):
        if punkt [i][2] == 1: #Sjekker om fastinnspent
            for t in range (3) :
                K [3* i+t ][3* i +t] = K [3* i+ t ][3* i+t ]*10**6 #Ganger med 10^6 på diagonalen
    return K , b
    
