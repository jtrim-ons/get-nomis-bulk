# Get bulk data from Nomis

This is a *terrible* script for downloading bulk output-area level data from Nomis.
Find the table code you need somewhere like [here](https://www.nomisweb.co.uk/census/2011/bulk/r2_2#QuickStatistics);
for example KS402EW (Tenure).  Then run

```
./get-data.sh ks402
```

This will get the data and put a CSV in a newly-created `tidied-data` directory.  A
file `log.txt` will contain a small amount of information about what has been downloaded.

The script is really unreliable!
