import numpy as np

def lokalK(nelem, elem, elemindex,  elementlengder,punkt, npunkt, geoArr, EIArr):
    k=np.zeros((6,6)) #Lager en 6x6 matrise
    E=elem[elemindex][2] #Henter E-modul
    A= geoArr[int(elem[elemindex][3])-1][4] #Henter tverrsnittsareal
    EI=EIArr[elemindex] #Henter EI
    l=elementlengder[elemindex] #Henter lengden til element
    #Fyller ut stivhetsmatrisen med tabellverdier
    k[0][0]=k[3][3]= E*A/l
    k[0][3]= k[3][0]=-E*A/l
    k[2][4]= k[4][2]= k[5][4]= k[4][5]=6*EI/l**2
    k[2][1]= k[1][2]= k[1][5]= k[5][1]=6*EI/l**2
    k[1][1]= k[4][4]= 12*EI/l**3
    k[4][1]= k[1][4]= -12*EI/l**3
    k[2][2]= k[5][5]= 4*EI/l
    k[2][5]= k[5][2]= 2*EI/l

    return k



