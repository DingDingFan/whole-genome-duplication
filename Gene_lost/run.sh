basedir=`cd $(dirname $0); pwd -P`;
for i in SALsal  SCHoco SINgra CARaur
do
	pep=$i.pep
	fas=/home/fandingding/Schizothorax/01.assembly/assembly/$i.raw.fasta #genome assembly
	mkdir $i;
	MCScanX $i -e 1e-3  -b 0 -k 50 -s 2
	perl $basedir/mscan.get.lost.gene.pl $i.gene.order $i.collinearity $i
	grep -v \#  $i.lost.bed |perl -ne 'chomp; @a=split; print "$a[3]\t$a[4]\t$a[5]\t$a[2]\n";'|sort -k 1,1 -k 2,2n  > $i.sort.bed
	
	bedtools getfasta -fi $i.fas -bed  $i.sort.bed > $i.sort.bed.fas
	cd $i;
	ln -s ../$i.* ./
	perl $basedir/exonerate.lost.region.run.pl $pep $i.sort.bed.fas  $i.lost.bed	
	cd ../

done
