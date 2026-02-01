import numpy as np
import matplotlib.pyplot as plt
import scipy as sc

def lengder(knutepunkt, element, nelem):
 
    elementlengder = np.zeros((nelem, 1))
    # Beregner elementlengder med Pythagoras' læresetning
    for i in range (0, nelem):
        # OBS! Grunnet indekseringsyntaks i Python-arrays vil ikke denne funksjonen fungere naar vi bare har ett element.
        dx = knutepunkt[int(element[i, 0]), 0] - knutepunkt[int(element[i, 1]), 0]
        dy = knutepunkt[int(element[i, 0]), 1] - knutepunkt[int(element[i, 1]), 1]
        elementlengder[i] = np.sqrt(dx*dx + dy*dy)
 
    return elementlengder



    
