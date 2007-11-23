% nmcalc.m
% calcule le nombre minumum de mailles pour une configuration harmonique donnée

% vitesse du son (m/s)
c=340;
% fréquence fondamentale (hz)
f=55;
% nombre d'harmomnique
nh=6;
% diamètre maxi (m)
d=0.078;

l=c/(nh*f);
n=d/l;
n