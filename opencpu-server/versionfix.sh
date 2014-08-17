# Hacks to make things work on older systems.

#Apache 2.2 does not want .conf extension
ISAP22=$(apache2 -v | grep "Apache/2.2")
if [ "$ISAP22" ]; then
	mv sites-available/opencpu.conf sites-available/opencpu
	mv sites-available/rstudio.conf sites-available/rstudio
fi
