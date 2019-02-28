# NYC DOT placard data, 2015-2018

Thanks to a [FOIL request filed by Mallory Bulkley](https://twitter.com/mallorybulkley/status/1100382505788760065) (thanks!!), the NYC DOT has made available some information about parking placards issued in 2015 through 2018. She kindly [published this PDF on Dropbox](https://www.dropbox.com/s/4x9bfxtlmul7drm/Records%20sent%202018-31145.pdf).

Unfortunately, this information was provided as a PDF rather than structured data. This project is a quick-and-dirty attempt to extract the data from that PDF and present it as a CSV.


# Instructions
You probably just want to download the [extracted, cleaned CSV](nyc_dot_placards_2015-2018.csv).

If you're interested in duplicating these results, here's what I did:
- Have a working installation of Ruby. I used 2.6.0, but anything reasonably modern should work.
- Have a working installation of Java. 1.8.0 worked for me.
- Download and extract a recent version of [tabula-java](https://github.com/tabulapdf/tabula-java/releases). (1.0.2 is current at the time of writing.)
- Invoke the extraction script: `TABULA=./path/to/extracted/tabula.jar ./1_extract.sh`. (Took about 1.5hr on my 2015 Macbook Pro. It'd be *a lot* faster if I didn't invoked tabula separately for each page, but otherwise I couldn't get the line numbers in the output.)
- Clean up the raw, extracted data. Because the tables in the input PDF aren't consistently formatted, there are several places where columns need to be nudged.
- Run the cleanup script with: `./2_cleanup.rb`
- Open [extracted, cleaned CSV](nyc_dot_placards_2015-2018.csv) in Excel or whatever.

# License
Best wishes, no guarantees.
