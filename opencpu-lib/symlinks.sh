for f in opencpu-lib/build/*; do
	b=$(basename $f)
	echo "/usr/lib/opencpu/library/$b /usr/lib/R/library/$b" >> debian/opencpu-lib.links;
done

