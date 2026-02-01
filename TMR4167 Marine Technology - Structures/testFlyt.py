import numpy as np
def test_flyt(nelem, elem,sigma_m, sigma_n, flyt):
    for i in range(nelem):
        flyt1=0
        if elem[i][2]==210*10**9: #Sjekker materiale ved å se på E-modul
            flyt1=flyt[1] #Setter flyt verdien til verdien for stål
        elif elem[i][2]==70*10**9:
            flyt1=flyt[0] #Setter flytverdien til verdien for aluminium
        #Total spenning er lik bøyespenning pluss aksialspenning
        #Deler på flyt-spenningen og ganger med 100 for å finne prosent av flyt
        prosent=((sigma_m[i]+sigma_n[i])/flyt1)*100 
        print("Bjelke nr:", i,"har en total spenning lik:", prosent,'% av flyt.') #Skriver ut prosentene