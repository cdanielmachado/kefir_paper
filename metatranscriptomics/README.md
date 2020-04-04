# Meta-transcriptomics gene profiling and DESeq2 analysis

Raw reads for the 13 samples can be downloaded under the project id [PRJEB37001](https://www.ebi.ac.uk/ena/data/search?query=PRJEB37001).

Gene read counts were calculated with [mOTUs2](https://motu-tool.org/), with a
custom database ([download the database](https://zenodo.org/record/3739770#.XohIqW5S_UI)). Download and unzip with:
```
wget https://zenodo.org/record/3739770/files/db_mOTU_kefir_species.tar.gz
tar -zxvf db_mOTU_kefir_species.tar.gz
```

## Run mOTUs
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
- `genes_raw.read_counts` for the DESeq2 analysis
- `genes_insert.scale_counts` for the flux balance analysis


## Run DESeq2
You can run DESeq2 using the R script `run_deseq2.R` which uses `deseq2_metadata` and the samples in the directory `genes_raw.read_counts`. Note that you need to change at line 5 in the script the position of you repo.

The result will be produced in this directory as three files (`230a.DESeq`, `261.DESeq`, `322b.DESeq`), which we already joined into one file: `deseq2_results.xlsx`.
