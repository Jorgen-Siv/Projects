import numpy as np

def lag_T(vinkel): 
    T=np.zeros((6,6)) #Lager 6x6 matrise med nuller
    #Fyller ut med verdier fra tabell
    T[0][0]= T[1][1]= T[3][3]=T[4][4]=np.cos(vinkel)
    T[2][2]= T[5][5]=1 
    T[1][0]=T[4][3]=np.sin(vinkel)
    T[0][1]=T[3][4]=-np.sin(vinkel)
    return T