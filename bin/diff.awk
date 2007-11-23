BEGIN {
  dec = decalage
      }
{
if (NF == 6 && $1 == 6749) {
      printf("%g %g %g %g %g %g\n",$1+dec,$2,$3+dec,$4,$5+dec,$6)
}
else if (NF == 4 && $2 == 6749) {
      printf("%g %g %g %s\n",$1,$2+dec,$3,$4)
}
else if (NF == 5 && $5 == "MX") {
      printf("%g CX %g CX MX\n",($1+dec*0.004),$3)
}
else print

}
