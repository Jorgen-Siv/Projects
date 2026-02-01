from structure_visualization import *
import scipy.linalg as la
from les_input import *
from lengder import lengder
from boyestivhet import boyestivhet
from moment import moment
from krefter import krefter
from vinkel import vinkel
from lastvektor import lastvektor
from stivhet import stivhet
from bc import bc
from rotasjoner import rotasjoner
from endeM import endeM
from midtmoment import midtmoment
from midtskjaer import midtskjaer
from boyespenning import boyespenning
from aksialspenning import aksialspenning
from testFlyt import test_flyt
# -----Rammeanalyse-----
def main():
    # -----Initialiserer figurer-----
    fig_init, ax_init, fig_def, ax_def = setup_plots()
     
    # -----Til visualiseringen, velg første indeks brukt i nummerering av noder og element-----
    # Endre gjerne selv
    first_index = 0
 
    # -----Leser input-data-----
    npunkt, punkt, nelem, elem, nlast, last, ngeo,geoArr = lesinput()
    
    #EI
    EIArr= boyestivhet(elem,geoArr)
    
    # -----Plott initalramme-----
    plot_structure(ax_init, punkt, elem, 1, first_index)
    #plt.show()

    # -----Regner ut lengder til elementene------
    elementlengder = lengder(punkt, elem, nelem)
    #print(elementlengder)
 
    # -----Fastinnspenningsmomentene------
    # Lag funksjonen selv
    fim = moment(npunkt, punkt, nelem, elem, nlast, last, elementlengder, geoArr)
    #print(fim)

    fik = krefter(npunkt, punkt, nelem, elem, nlast, last, elementlengder, geoArr, fim)
    #print(fik)

    # -----Setter opp lastvektor-----
    # Lag funksjonen selv
    b = lastvektor(fim, npunkt, punkt, nelem, elem, fik,last)
    #print("lastvektor:",b)
    
    # ------Setter opp systemstivhetsmatrisen-----
    # Lag funksjonen selv
    K = stivhet(nelem, elem, elementlengder, npunkt,punkt, geoArr, EIArr)
    #print(K)

    # ------Innfører randbetingelser------
    # Lag funksjonen selv
    Kn, Bn = bc(npunkt, punkt, K, b)
    #print("Kn:", Kn)
 
    # -----Løser ligningssystemet------
    # Lag funksjonen selv
    rot, bareRotasjoner = rotasjoner(Kn, Bn)
    # Hint, se side for løsing av lineære systemer i Python
     
    #------Finner endemoment for hvert element-----
    # Lag funksjonen selv
    endemoment = endeM(npunkt, punkt, nelem, elem, elementlengder, rot, fim, fik,geoArr,EIArr)
 
    #-----Skriver ut hva rotasjonen ble i de forskjellige nodene-----
    print("Rotasjoner i de ulike punktene:")
    print(rot)
 
    #-----Skriver ut hva momentene ble for de forskjellige elementene-----
    print("Elementvis endemoment:")
    print(endemoment)

    #Finner midtmomenter
    midtmom=midtmoment(nelem, elem,punkt,last,elementlengder,endemoment)
    #print('midtmoment:', midtmom)

    #Finner skjærkrefter på midten
    midtSk= midtskjaer(nelem, elem, punkt, last, elementlengder, endemoment)
    #print('midtskjær', midtSk)

    #Finner spenninger
    sigma_m=boyespenning(nelem, elem, endemoment, EIArr, midtmom,geoArr)
    #print(sigma_m)
    
    sigma_n=aksialspenning(nelem, elem, endemoment, geoArr)
    #print("sigma_n", sigma_n)
    
    #Test mot flytspenningen
    test_flyt(nelem, elem,sigma_m, sigma_n, [250*10**6, 420*10**6])
    #-----Plott deformert ramme-----
    skalering = 40;     # Du kan endre denne konstanten for å skalere de synlige deformasjonene til rammen
    plot_structure_def(ax_def, punkt, elem, 1, first_index, skalering*rot)
    plt.show()

main()