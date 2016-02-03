mkdir -p opencpu-lib/symlinks
for f in opencpu-lib/build/*; do
	b=$(basename $f)
	echo "/usr/lib/opencpu/library/$b /usr/lib/R/library/$b" >> debian/opencpu-lib.links;
	ln -sf "/usr/lib/opencpu/library/$b" "opencpu-lib/symlinks/$b"
done
