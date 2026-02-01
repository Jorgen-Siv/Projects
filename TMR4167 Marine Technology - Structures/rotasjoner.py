import numpy as np
import scipy.linalg as la

def rotasjoner(K, b):
    #Invers av Stivhetsmatrisen
    K_inv= la.inv(K)
    #r=K^-1 *R
    #Lagret opprinnelig lastvektoren i et 2D-array
    #Må derfor "flate" det ut til et 1D-array for at dimensjonene skal passe sammen for matrisene
    a=b.flatten()
    #Dot/matrise multiplikasjon av inversen til stivhetsmatrisen og lastvektor
    r=np.dot(K_inv, a)
    #Uviktig, men lager et array for bare rotasjonene av knutepunktene
    r_rot=np.zeros(int(len(r)/3))
    for i in range(len(r_rot)):
        r_rot[i]=r[3*i+2]
    #Returnerer array med alle deformasjonene og rotasjonene samt arrayet med bare rotasjoner.
    return r, r_rot
