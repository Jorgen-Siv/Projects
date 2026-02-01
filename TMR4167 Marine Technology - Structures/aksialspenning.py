import numpy as np

def aksialspenning(nelem, elem, endeM, geoArr):
    sigma_n=np.zeros(nelem) #Array for aksialspenninger i alle bjelkene
    for i in range(nelem):
        N1=abs(endeM[i][0]) #Aksialkraft i punkt 1
        N2=abs(endeM[i][3]) #Aksialkraft i punkt 2
        N=max(N1,N2) 
        A=geoArr[int(elem[i][3])-1][4] #Henter areal fra geometri
        sigma_n[i]=abs(N/A) #sigma=N/A og plassere på riktig plass i arrayet
    return sigma_n
