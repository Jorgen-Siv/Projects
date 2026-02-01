import numpy as np

def boyespenning(nelem, elem, endeM, EIArr, midtmom,geoArr):
    sigma_m=np.zeros(nelem)
    for i in range(nelem): #Itererer over alle bjelke elementene
        #Finner max moment på bjelken
        I=EIArr[i]/elem[i][2] #I=EI/E
        
        #sigma_m = M/I *zmaks
        zmaks=0
        if int(elem[i][3])==1 or int(elem[i][3])==2 or int(elem[i][3])==3: #Hvis rør-profil
            zmaks=geoArr[int(elem[i][3])-1][0]
        elif int(elem[i][3])==4 or int(elem[i][3])==5: #Hvis I- eller boks-profil
            zmaks=geoArr[int(elem[i][3])-1][0]/2
        M1,M2,M_midt=endeM[i][2], endeM[i][5], midtmom[i] #Henter Moment i ende 1 og ende 2 og midt på.
        max_M=abs(max([M1,M2, M_midt], key=abs)) #Finner absolutte maks-verdi for momentet på bjelken
        sigma_m[i]=max_M/I *zmaks
    return sigma_m