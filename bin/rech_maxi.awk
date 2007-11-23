BEGIN {
	cm2pt = 250.0000

	xmin =  1.e+30
	xmax = -1.e+30
	ymin =  1.e+30
	ymax = -1.e+30

	taille_police = 9
	largeur_unit = 0.6
	facteur_hauteur = 0.56
}

function verif (x, y)
{
	if(x < xmin) xmin = x
	if(x > xmax) xmax = x
	if(y < ymin) ymin = y
	if(y > ymax) ymax = y
}

(NF == 5 && $5 == "MX") {
#	printf("Ligne avec MX : '%s'\n",$0)
	valx = $1 * cm2pt
	valy = $3 * cm2pt
#	TEST : On ne prend pas en compte le titre => PAS DE RAISON
#	if(valx > 0.001 && valy > 0.001) {
		verif(valx,valy)
#	}
}

(NF == 4 && ($4 == "DL" || $4 == "DS")) {
	verif($2,$3)
	nb_pts = $1
	if((2 * nb_pts) != nf_preced) {
#		printf "ERREUR !!! %s\n",$0
#		printf "\tnb_pts = %d\n",nb_pts
#		printf "\tnf_preced = %d\n",nf_preced
	}
	for(i=1;i<=(nf_preced / 2);i++) {
		numx = 2*i - 1
		numy = 2*i
		verif(a[numx],a[numy])
	}
}

($NF == "SX") {
#	printf "Une chaine de caractères trouvéé : `%s'\n",$0 > "/dev/tty"
	valx = a[1] * cm2pt
	valy = a[3] * cm2pt
#	TEST : On ne prend pas en compte le titre => PAS DE RAISON
#	if(valx > 0.001 && valy > 0.001) {
		longueur = length($0)
		long_chain = length($0)
		for(i=longueur;i>=1;i--) {
			if(substr($0,i,1)==")") {
				if(long_chain==longueur) {
					long_chain = i
				}
			}
			if(substr($0,i,1)=="\\") long_chain -= 1
		}
		long_chain -= 2
		valx += long_chain * taille_police * largeur_unit * 10.
#		printf "Longueur de la chaîne trouvée = %2d\n",long_chain > "/dev/tty"

		valy += taille_police * facteur_hauteur * 10.

		verif(valx,valy)
#	}
}

{
	a[0] = $0
	for(i=1;i<=NF;i++) a[i]=$i
	nf_preced = NF
}

END {
	if ( "RESU" == "bb" ) {
	  xmin = xmin - 100
	  ymin = ymin - 100
	  xmax = xmax + 100
	  ymax = ymax + 100
	  if(xmin < 0) xmin = 0
	  if(ymin < 0) ymin = 0
	  printf("s/%%%%BoundingBox:/%%%%BoundingBox: %g %g %g %g/",xmin*0.1,ymin*0.1,xmax*0.1,ymax*0.1)
	}
	if ( index("RESU","x1") != 0 ) printf("%g ",xmin);
	if ( index("RESU","y1") != 0 ) printf("%g ",ymin);
	if ( index("RESU","x2") != 0 ) printf("%g ",xmax);
	if ( index("RESU","y2") != 0 ) printf("%g ",ymax);
	printf("\n") ;
}

