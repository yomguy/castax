%
% castomat.m : un outil matlab pour récupérer les évolutions renvoyées par Castax
%
% This program is part of Castax.
%
% Copyright (C) 2002-2005 by Guillaume Pellerin <pellerin@ccr.jussieu.fr>
%
% This software is governed by the CeCILL license under French law and
% abiding by the rules of distribution of free software.  You can  use, 
% modify and/ or redistribute the software under the terms of the CeCILL
% license as circulated by CEA, CNRS and INRIA at the following URL
% "http://www.cecill.info". 
% 
% As a counterpart to the access to the source code and  rights to copy,
% modify and redistribute granted by the license, users are provided only
% with a limited warranty  and the software's author,  the holder of the
% economic rights,  and the successive licensors  have only  limited
% liability. 
% 
% In this respect, the user's attention is drawn to the risks associated
% with loading,  using,  modifying and/or developing or reproducing the
% software by the user in light of its specific status of free software,
% that may mean  that it is complicated to manipulate,  and  that  also
% therefore means  that it is reserved for developers  and  experienced
% professionals having in-depth computer knowledge. Users are therefore
% encouraged to load and test the software's suitability as regards their
% requirements in conditions enabling the security of their systems and/or 
% data to be ensured and,  more generally, to use and operate it in the 
% same conditions as regards security. 
% 
% The fact that you are presently reading this means that you have had
% knowledge of the CeCILL license and that you accept its terms.
%

clear all;
close all;

%%%%%%%%%%%%%
% PARAMETERS
%
% dossier de backup
dirres='/data/pellerin/castem';
% table des profils
tprofil=['tuy02_2_16.2974';'tuy02_2_65.9777';'tuy02_2_34.8294';'tuy02_2_46.7269';'tuy02_2_65.9777'];
% table des fréquences
tfreq=[17;39;70];
% table des vitesses
tu=[0.125;0.25;0.5;0.75;1.0];

% Indices pour les tables précédentes
kp=1;
kf=2;
ku=1;

% Géométrie
lc=0.72;  %longueur du conduit (m)
lr=1.0;  %longueur totale sur l'axe (conduit + extérieur) (m)

% Nombre de périodes
nper=2;
% Nombre de pas temporels par période
npper=36;
% Pas pour l'affichage
pas=9;

% Tables des préfixes, marqueurs, types de ligne, couleurs
evols=['p';'v';'i';'p';'t';'p';'v';'p';'v';'p';'v'];
mark=cellstr(['+';'o';'*';'x';'s';'d';'<';'>';'p']);
line=cellstr(['-';'-';'-';'-';'-';'-';'-';'-';'-';'-']);
color=cellstr(['k';'r';'y';'g';'c';'b';'k';'r';'y';'g';'c';'b';]);

% Extraction des paramètres
tprofil=cellstr(tprofil);
profil=tprofil{kp};
u=num2str(tu(ku));
fi=tfreq(kf);
f=[num2str(fi)];
nt=npper*nper-1;
% facteur pour les échelles
amp=1.2;
% Nombre de points pour la fft
nfft=16384;
fmax=fi*npper;
fe=fi*npper;
nwin=nt;
% Fenêtre opur la fft
wind=hanning(nwin);
fv=[0:nfft/2]*fe/nfft;

eval(['cd ' dirres '/' profil '/' f '/' u '/txt']);

%%%%%%%%%%%%%%%%%%%
% CALCUL ET COURBES
% 
% initialisation de ptotent vtotent ptotsor vtotsor
load 'ev_p_ent_0001.txt';
load 'ev_paxe_0001.txt';
load 'ev_p_col_0001.txt';
nd=length(ev_p_ent_0001(:,1));
nl=length(ev_paxe_0001(:,1));
nc=length(ev_p_col_0001(:,1));
xd=ev_p_ent_0001(:,1);
xdmax=max(xd);

ptotent=0*(1:1:nd)';
vtotent=0*(1:1:nd)';
ptotsor=0*(1:1:nd)'; 
vtotsor=0*(1:1:nd)';

iper=1;

for npl=1:11
    ymax=0.0001;
    xmin=0;
    ymin=0;
    evol=evols(npl,1);
    if evol == 'p'
        unites='Pa';
    elseif evol == 'v'
        unites='m.s^{-1}';
    elseif evol == 'i'
        unites='N.m^{-1}.s^{-1}';
    elseif evol == 't'
        unites='s^{-1}';
    end
    
    if ( npl<3 )
        suff='axe';
        %xmax=ev_paxe_0001(nl,1);
        xmax=lr;
    elseif ( npl>3 & npl<6)
        suff='par';
        %xmax=ev_paxe_0001(nl,1);
        xmax=lc;
    elseif ( npl>5 & npl<8)
        suff='_ent';
        xmax=ev_p_ent_0001(nd,1);
    elseif ( npl>7 & npl<10)
        suff='_sor';
        xmax=ev_p_ent_0001(nd,1);
    elseif ( npl>9 & npl<11)
        suff='_col';
        xmax=ev_p_col_0001(nc,1);  
    end

    evol=[evols(npl,1) suff];
    
    figure(npl);
       
    for i=1:pas:nt
    	iper=mod(i,(nt/nper))+1;
    	iphi=mod(nt,i*pas);
   
    	pdt=upzero(i,4);

	eval(['load ev_' evol '_' pdt '.txt;']);
    	%eval(['xmax=max([xmax ;max(ev_' evol '_' pdt '(:,1))]);']);
    
    	if npl == 6
        	eval(['ptotent(:,i)=ev_p_ent_' pdt '(:,2);']);
    	end
    	if npl == 7
        	eval(['vtotent(:,i)=ev_v_ent_' pdt '(:,2);']);
    	end
    	if npl == 8
        	eval(['ptotsor(:,i)=ev_p_sor_' pdt '(:,2);']);
    	end
    	if npl == 9
        	eval(['vtotsor(:,i)=ev_v_sor_' pdt '(:,2);']);
    	end
    	if npl == 10
        	eval(['pcol(:,i)=ev_p_col_' pdt '(:,2);']);
        end
    	if npl == 11
        	eval(['vcol(:,i)=ev_v_col_' pdt '(:,2);']);
    	end

	set(0,'DefaultAxesColorOrder',[0 0 0],...
	'DefaultAxesLineStyleOrder','-|x|-|<|-|s|-|>|--|x|--|<|--|s|--|>');
	%opts=[line{iper} ',' mark{iper} ];
	eval(['ymax=max([ymax ;max(ev_' evol '_' pdt '(:,2))]);']);
	eval(['ymin=min([ymin ;min(ev_' evol '_' pdt '(:,2))]);']);
	%eval(['xmax=max([xmax ;max(ev_' evol '_' pdt '(:,1))]);']);
	strplot1=['ev_' evol '_' pdt '(:,1),ev_' evol '_' pdt '(:,2)'];
	eval(['ly1=length(ev_' evol '_' pdt '(:,1));']);
	eval(['yplot2=resample(ev_' evol '_' pdt '(:,2),1,round(ly1/4),0);']);
	eval(['xplot2=resample(ev_' evol '_' pdt '(:,1),1,round(ly1/4),0);']);
	eval(['plot(' strplot1 ');']);
	hold all;
	plot(xplot2,yplot2);
	%grid on;
    end
    
    title([evol '-' profil '-' u '-' f]);
    axis([xmin xmax ymin*amp ymax*amp]);
    XLABEL('Position (m)');
    YLABEL([evol '  (' unites ')']);
    legend;
    
end

hold off;

% PLOTS
figure();
load 'ev_pp00.txt';
evol = 'pp00';
y=ev_pp00(:,2);
ly=length(ev_pp00(:,1))
% ajout des zeros
 p=round(log(ly)/log(2));
 epsil=(2^(p+2)-ly);
 y=[y' zeros(1,epsil)]';
 y=resample(y,64,1);
 ly=length(y);
nwin=ly/2;
wind=hanning(nwin);

plot(ev_pp00(:,1),ev_pp00(:,2));
title([evol '-' profil '-' u '-' f]);
    eval(['xmax=max(ev_' evol '(:,1));']);
    eval(['ymax=max(ev_' evol '(:,2));']);
    eval(['ymin=min(ev_' evol '(:,2));']);
axis([0.0 xmax ymin*amp ymax*amp]);
grid on;
xlabel('Fréquence (Hz)');
ylabel('Lp (dB SPL)');
%tf_pp00(:,2)=psd(h,ev_pp00(:,2),'NFFT',nfft,'FS',fe);

% Calcul des spectres
fy=pwelch(y,wind,0,nfft,fe);
% fy=fft(y,nfft);
fya=unwrap(angle(fft(y,nfft)));
aspect=20*log10(abs(fy(1:(nfft/2+1))).^0.5./2e-5);
fya=fya(1:(nfft/2+1));
maxaspect=max(aspect);

figure()
semilogx(fv,aspect,'k');
axis([10 fmax 0 (maxaspect+10)]);
xlabel('Fréquence (Hz)');
ylabel('Lp (dB SPL)');
grid on;

figure();
semilogx(fv,fya,'k');
axis([10 fmax min(fya) max(fya)]);
grid on;
xlabel('Fréquence (Hz)');
ylabel('Phase (rad)');

% P00 = periodogram(ev_pp00(:,2),window,nfft,fe);
% hpsd = dspdata.psd(P00,'Fs',fe);
% plot(hpsd);
% grid on;
% figure()
% tf_pp00=fft(ev_pp00(:,2),nfft);
% plot(freq,20*log10(abs(tf_pp00(1:32769))/2e-5));
% figure()
% plot(freq,angle(tf_pp00(1:32769)));
% grid on;

%eval(['plot(tf_' evol '(:,1),abs(tf_' evol '(:,2)));']);
%eval(['plot(tf_' evol '(:,1),20*log10(abs(tf_' evol '(:,2))/2e-5));']);

figure();
load 'ev_vp00.txt';
plot(ev_vp00(:,1),ev_vp00(:,2));
evol = 'vp00';
title([evol '-' profil '-' u '-' f]);
    eval(['xmax=max(ev_' evol '(:,1));']);
    eval(['ymax=max(ev_' evol '(:,2));']);
    eval(['ymin=min(ev_' evol '(:,2));']);
axis([0.0 xmax ymin*amp ymax*amp]);
grid on;
xlabel('Temps (s)');
ylabel('Vitesse particulaire (m/s)');

figure();
load 'ev_pp05.txt';
evol = 'pp05';
n05=length(ev_pp05(:,1));
window=hanning(n05);
plot(ev_pp05(:,1),ev_pp05(:,2));
title([evol '-' profil '-' u '-' f]);
    eval(['xmax=max(ev_' evol '(:,1));']);
    eval(['ymax=max(ev_' evol '(:,2));']);
    eval(['ymin=min(ev_' evol '(:,2));']);
axis([0.0 xmax ymin*amp ymax*amp]);
grid on;
xlabel('Temps (s)');
ylabel('Pression locale (Pa)');

%tf_pp00(:,2)=psd(h,ev_pp00(:,2),'NFFT',nfft,'FS',fe);
figure()
P05 = periodogram(ev_pp05(:,2),window,nfft,fe);
hpsd = dspdata.psd(P05,'Fs',fe);
plot(hpsd);
grid on;

figure();
load 'ev_pp10.txt';
plot(ev_pp10(:,1),ev_pp10(:,2));
evol = 'pp10';
title([evol '-' profil '-' u '-' f]);
    eval(['xmax=max(ev_' evol '(:,1));']);
    eval(['ymax=max(ev_' evol '(:,2));']);
    eval(['ymin=min(ev_' evol '(:,2));']);
axis([0.0 xmax ymin*amp ymax*amp]);
grid on;
xlabel('Temps (s)');
ylabel('Pression locale (Pa)');

figure();
load 'ev_vp10.txt';
plot(ev_vp10(:,1),ev_vp10(:,2));
evol = 'vp10';
title([evol '-' profil '-' u '-' f]);
    eval(['xmax=max(ev_' evol '(:,1));']);
    eval(['ymax=max(ev_' evol '(:,2));']);
    eval(['ymin=min(ev_' evol '(:,2));']);
axis([0.0 xmax ymin*amp ymax*amp]);
grid on;
xlabel('Temps (s)');
ylabel('Vitesse particulaire (m/s)');

figure();
load 'ev_pp12.txt';
n12=length(ev_pp12(:,1));
window=hanning(n12);
plot(ev_pp12(:,1),ev_pp12(:,2));
evol = 'pp12';
title([evol '-' profil '-' u '-' f]);
    eval(['xmax=max(ev_' evol '(:,1));']);
    eval(['ymax=max(ev_' evol '(:,2));']);
    eval(['ymin=min(ev_' evol '(:,2));']);
axis([0.0 xmax ymin*amp ymax*amp]);
grid on;
xlabel('Temps (s)');
ylabel('Pression locale (Pa)');

%pp12_hd=resample(ev_pp12(:,2),35,1);
pp12=ev_pp12(:,2);
figure()
P12 = periodogram(pp12,window,nfft,fe);
hpsd = dspdata.psd(P12,'Fs',fe);
plot(hpsd);
xlabel('Fréquence (Hz)');
ylabel('Densité spectrale de puissance (dB)');
%figure()
%tf_pp12=fft(ev_pp12(:,2),nfft);
%plot(freq,20*log10(abs(tf_pp12(1:32769))/2e-5));

figure();
load 'ev_residus.txt';
plot(ev_residus);
evol = 'residus';
title([evol '-' profil '-' u '-' f]);
    eval(['xmax=max(ev_' evol '(:,1));']);
    eval(['ymax=max(ev_' evol '(:,2));']);
    eval(['ymin=min(ev_' evol '(:,2));']);
%axis([0.0 xmax ymin*amp ymax*amp]);
grid on;
xlabel('Itération de calcul');
ylabel('Erreur relative (echelle en log10)');

% Calcul des débits entrants et sortants

for idebit=1:1:nt
    zidebit=upzero(idebit,4);
    eval(['load ev_v_sor_' num2str(zidebit) '.txt;']);
    eval(['vtotsor(:,idebit)=ev_v_sor_' num2str(zidebit) '(:,2);']);
end

vtotsorinc=vtotsor;
vtotsor(nd,:)=[];
vtotsorinc(1,:)=[];
xdinc=xd;
xd(nd,:)=[];
xdinc(1,:)=[];

dv=(vtotsorinc+vtotsor)./2;
dx=xdinc-xd;
ds=pi*(xdinc.^2-xd.^2);

for j=2:nt
    dx(:,j)=dx(:,1);
    ds(:,j)=ds(:,1);
end

qt=sum(dv.*ds,1);
figure();
plot(qt);
title([evol '-' profil '-' u '-' f]);
grid on;
xlabel('Temps (s)');
ylabel('Débit total en sortie (m^3/s)');

% FIN castomat.m
%