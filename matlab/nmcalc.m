% nmcalc.m
% calcule le nombre minumum de mailles pour une configuration harmonique donn�e

% vitesse du son (m/s)
c=340;
% fr�quence fondamentale (hz)
f=55;
% nombre d'harmomnique
nh=6;
% diam�tre maxi (m)
d=0.078;

l=c/(nh*f);
n=d/l;
n