# SSSD-creds

Using this bash script it is possible to extract Active Directory accounts hashes when credential caching is enabled in SSSD.

```
bash analyze.sh [$path]
```

Without input arguments it takes the SSSD default path "/var/lib/sss/db/" but you can use a different one. If tdbdump is not installed it just lists the ldb files which contain the hashes, you can install it ("apt install tdb-tools") or exfiltrate these files:

![image1](https://raw.githubusercontent.com/ricardojoserf/ricardojoserf.github.io/master/images/SSSD-creds/image1.png)


In a system with tdbdump installed the script extracts the cached accounts and hashes, dumping the results to the file "hashes.txt"

![image2](https://raw.githubusercontent.com/ricardojoserf/ricardojoserf.github.io/master/images/SSSD-creds/image2.png)

The hashes can then be cracked using Hashcat or John the Ripper:

```
john hashes.txt --format=sha512crypt
```

![image3](https://raw.githubusercontent.com/ricardojoserf/ricardojoserf.github.io/master/images/SSSD-creds/image3.png)


### Sources

I create the script after reading this presentation by Tim (Wadhwa-)Brown:

- [Where 2 worlds collide - Bringing Mimikatz et al to UNIX by Tim (Wadhwa-)Brown](https://i.blackhat.com/eu-18/Wed-Dec-5/eu-18-Wadhwa-Brown-Where-2-Worlds-Collide-Bringing-Mimikatz-et-al-to-UNIX.pdf)
