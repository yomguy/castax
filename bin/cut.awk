#
# cuts a PostScript file generated by CASTEM 2000 in
#     prolog + files_page_ps
#
BEGIN{
    name_series = "name_root"
    n_figure = 0
    k = 0
}

{
	if( $1 == "StartPage" ){
		n_figure++
		name_file = name_series "." n_figure
#		print name_file
	}

	if( n_figure == 0 ) {

        	if ( k == 0 ) {
        		printf("%%!PS-Adobe-2.0 EPSF-2.0\n") > "prolog";
        		printf("%%%%BoundingBox:\n")     > "prolog";
         		printf("%%%%Pages: 0\n")         > "prolog";
		}

		if ( k == 3 ){
#			print > "prolog";
			printf("%%%%EndComments\n") > "prolog";
		}

		if ( k > 3 && $2 != "rotate" && $5 != "translate" ){
			print > "prolog";
		}

        	k++
        }

	if( $1 == "EndPage" ){
		if( n_figure >= 1){
           		print > name_file;
           		printf("end\n%%%%Trailer\n") > name_file;
#           		close(name_file)
		}
	}

	if( n_figure >= 1 && $1 != "EndPage"  ) print > name_file;
}
END {
  printf("%i\n",n_figure);
}
