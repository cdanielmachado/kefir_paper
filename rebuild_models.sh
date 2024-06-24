#!/bin/bash

for file in fasta/*.faa
do
    carve $file -g MILK -i MILK --mediadb misc_data/milk_composition.tsv -v
done

mv fasta/*.xml models/
rm fasta/*.tsv

