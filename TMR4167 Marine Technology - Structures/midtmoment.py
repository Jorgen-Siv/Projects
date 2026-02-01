import numpy as np

def midtmoment(nelem, elem, punkt,last,elementlengder,endeM):
    midtmom=np.zeros(nelem)
    for i in range(nelem): #Itererer over alle bjelkene
        L=elementlengder[i] #Lengde
        #Midtmoment som resultat av endemoment
        midtmom[i]+=-(1/2)*endeM[i][2]+(1/2)*endeM[i][5]

    for l in last: #Itererer over alle lastene
        if l[0]==1:
            elemindex=int(l[1])
            L=elementlengder[elemindex]
            q1=0
            q2=0
            if punkt[int(elem[elemindex][0])][1] <punkt[int(elem[elemindex][1])][1]: #lokal ende nederst
                #Har lyst å endre til lokal q-verdi
                #q1 ligger alltid over q2,
                #Hvis lokal ende en er nederst lokal q1= q2 fra input og motsatt
                q1=l[3]
                q2=l[2]
            else: #Lokal ende øverst
                #lokal q1= q1 fra input og q2=q2 fra input
                q1=l[2]
                q2=l[3]
            #Henter ut skjørkraft og moment i ende 2
            M2=endeM[elemindex][5]
            Q2=endeM[elemindex][4]
            print(M2, Q2)
            #Formel for midtmoment gitt q1,q2, M2 og Q2 pluss lengde
            midtmom[elemindex]=1/48*q1*L**2 +5/48*q2*L**2 + M2 - 1/2*Q2*L**2
        elif l[0]==0: #Hvis punktlast på bjelke
            elemindex=int(l[1])
            L=elementlengder[elemindex]
            P=l[2]
            a=l[3]*L #Avstand fra ende 1 til last
            if a>0.5: 
                b=a-0. #Avstand til midten
                midtmom[elemindex]+=-P*b
            elif a<0.5:
                b=0.5-a #Avstand til midten
                midtmom[elemindex]+=P*b
        elif l[0]==2: #Hvis knutepunktslast
            elemindex=int(l[1])
            L=elementlengder[elemindex]
            P=l[2]*np.sin(l[4]) #Last i lokal skjærretning
            if l[3]==0:
                midtmom[elemindex]+=P*L/2 #L/2 = avstand til midten
            elif l[3]==1:
                midtmom[elemindex]-=P*L/2
    
    return midtmom

