#projectpath=adnoc
for i in `cat filelist`
do
rm -rvf $i
echo "$i deleted"
done
