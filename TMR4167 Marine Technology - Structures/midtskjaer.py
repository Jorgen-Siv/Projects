import numpy as np

def midtskjaer(nelem, elem, punkt, last, elementlengder,endeM):
    midtS=np.zeros(nelem)
    for i in range(nelem):
        Q=endeM[i][1] 
        midtS[i]+=Q #Setter skjærkradt på midten lik Q1 i tilfelle ingen last
    
    for l in last: #Itererer over lastene
        if l[0]==1: #Fordelt last
            elemindex=int(l[1]) 
            q1=0
            q2=0
            L=elementlengder[elemindex]
            if punkt[int(elem[elemindex][0])][1] <punkt[int(elem[elemindex][1])][1]: #lokal ende 1 nederst
                #Har lyst å endre til lokal q-verdi
                #q1 ligger alltid over q2,
                #Hvis lokal ende en er nederst lokal q1= q2 fra input og motsatt
                q1=l[3]
                q2=l[2]
            else: #Lokal ende 1 øverst
                q1=l[2]
                q2=l[3]
            #Henter skjærkraft i ende 1
            Q1=endeM[elemindex][1]
            #Bruker formel for skjærkraft på midten gitt q1, q2, Q1
            midtS[elemindex]= 1/8 *q1*L +3/8*q2*L-Q1
    return midtS

