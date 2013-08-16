#!/bin/bash

# splitting big PDF files to many small files

echo "*** Splitting big PDF files ***"

which pdfinfo > /dev/null
test $? -ne 0 && { echo "Missing 'pdfinfo'. Install and run again."; exit; }

which pdftk > /dev/null
test $? -ne 0 && { echo "Missing 'pdftk'. Install and run again."; exit; }

test $# -ne 1 && { echo "Syntax: ./splitpdf.sh big.pdf"; exit; }

pdf="$1"
total_pages=$(pdfinfo "$pdf" | grep "Pages" | awk '{print $2}')
total_mb=$(($(stat -c "%s" "$pdf")/1024/1024))

echo "PDF file '$pdf' contains $total_pages page(s) in $total_mb MB"
echo -n "How many pages per smaller file? "
read split_pages

filename=${pdf%%.[Pp][Dd][Ff]}

echo "Splitting PDF by $split_pages page(s)..."
for((split=1;split<=total_pages;split+=split_pages))
do
	till=$((split+split_pages-1))
	test $till -gt $total_pages && till=$total_pages
	echo "Creating ${filename}_${split}-${till}.pdf ..."
	pdftk "$pdf" cat $split-$till output "${filename}_${split}-${till}.pdf"
done
echo "Done."
