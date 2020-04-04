# Meta-transcriptomics gene profiling and DESeq2 analysis

Raw reads for the 13 samples can be downloaded under the project id [PRJEB37001](https://www.ebi.ac.uk/ena/data/search?query=PRJEB37001).

Gene read counts were obtained using [mOTUs2](https://motu-tool.org/), with a
custom database ([download the database](https://zenodo.org/record/3739770#.XohIqW5S_UI)). Download and unzip with:
```
wget https://zenodo.org/record/3739770/files/db_mOTU_kefir_species.tar.gz
tar -zxvf db_mOTU_kefir_species.tar.gz
```

## Running mOTUs
mOTUs was run with the following parameters for the following DEseq2 analysis:
```
motus profile -db db_mOTU_kefir_species -n 4337 -M 4337.mgc -f 4337_forward.fastq.gz  -r 4337_reverse.fastq.gz -y insert.raw_counts
```

and with following parameters for flux balance analysis:
```
motus profile -db db_mOTU_kefir_species -n 4337 -M 4337.mgc -f 4337_forward.fastq.gz  -r 4337_reverse.fastq.gz
```

Where in both cases, the resulting read counts per gene will be saved in `4337.mgc`.

The results of the profiling can be found in the following directories:
