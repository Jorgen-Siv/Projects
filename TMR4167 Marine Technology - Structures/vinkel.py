from matplotlib.font_manager import X11FontDirectories
import numpy as np

def vinkel(element, punkt):
    #Henter x og y verdier til punktene i bjelken
    x1= punkt[int(element[0])][0]
    y1= punkt[int(element[0])][1]
    x2= punkt[int(element[1])][0]
    y2= punkt[int(element[1])][1]

    #Må sjekke om x1==x2 for ellers vil vi dele på null etterpå
    if x1==x2 and y2>y1: #Vendt 90 grader i forhold til x-aksen, punkt 1 ligger lavere enn 2
        return np.pi/2
    if x1==x2 and y2<y1:#Vendt 270 grader i forhold til x-aksen, punkt 2 liggere lavere enn 1
        return -np.pi/2
    v= np.arctan2((y2-y1), (x2-x1)) #Henter ut vinkel for alle andre situasjoner
    return v