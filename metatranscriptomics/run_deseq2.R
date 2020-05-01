library("DESeq2")
library("ggplot2")

# to change:
base_dir = "../kefir_paper/metatranscriptomics/"

################################################################################
# species id
# 373(290) = Acetobacter fabarum
# 230a = Leuconostoc mesenteroides
# 261 = Lactococcus lactis
# 322b = Lactobacillus kefiranofaciens

################################################################################
# species ids:
species = c("322b","261","230a","373(290)")

################################################################################
# species ids:
samples_id = c("4337","4340","4346","4582","5105","5108","4338","4342","4347","4584","5106","5109","4339","4343","4348","5104","5107")
# base for selected genes:
base_mapping = paste0(base_dir,"genes_raw.read_counts/")

################################################################################============
# metadata samples
f = paste0(base_dir,"deseq2_metadata")
metad = read.csv(f,sep = "\t", stringsAsFactors = F, header = T,comment.char = "#")

for (sel_species in c("261","322b","230a")){

#------------------------------------------------------
# create metadata
coldata = data.frame(metad)
coldata = coldata[which(coldata$species == sel_species),]
rownames(coldata) = coldata$sample
# coldata is done

#------------------------------------------------------
# we need to create the count data now:
# rows are genes and cols are samples

# not efficient solution:
# find all unique genes:
all_genes = c()
for (i in coldata$sample){
  mapped_reads = data.frame(read.csv(paste0(base_mapping,i,".mgc"),
                                     skip = 2, sep = "\t", stringsAsFactors = F,
                                     header = F))
  colnames(mapped_reads) = c("gene_id","read_count")
  mapped_reads$genome_type = sapply(mapped_reads$gene_id,function(x) strsplit(x,"_")[[1]][1])
  # find only genes from interested species
  pos = which(mapped_reads$genome_type == sel_species)
  all_genes = c(all_genes,mapped_reads$gene_id[pos])
}
# keep only unique
all_unique_genes = unique(all_genes)

# create a matrix with len(all_unique_genes) rows and len(coldata$sample) columns ------------
cts = matrix(0, length(all_unique_genes),length(coldata$sample))
rownames(cts) = all_unique_genes
colnames(cts) = coldata$sample

# put values into the matrix
for (i in as.character(coldata$sample)){
  mapped_reads = data.frame(read.csv(paste0(base_mapping,i,".mgc"),
                                     skip = 2, sep = "\t", stringsAsFactors = F,
                                     header = F))
  colnames(mapped_reads) = c("gene_id","read_count")
  mapped_reads$genome_type = sapply(mapped_reads$gene_id,function(x) strsplit(x,"_")[[1]][1])
  # find only genes from interested species
  pos = which(mapped_reads$genome_type == sel_species)
  rownames(mapped_reads) = mapped_reads$gene_id
  cts[mapped_reads$gene_id[pos],i] = mapped_reads[mapped_reads$gene_id[pos],2]
}

# transform to integers
cts = floor(cts)

# select only genes with at least 50 reads mapping in total and
# it appers in at least 3 samples
pos = which( rowSums(cts) > 50 &
             rowSums((cts>0)) > 2
           ) 

cts = cts[pos,]

cts_rel_ab = t(t(cts)/colSums(cts))

# rund DESeq 2 ============================================================================
dds <- DESeqDataSetFromMatrix(countData = cts,
                              colData = coldata,
                              design= ~ condition)
dds <- DESeq(dds)
resultsNames(dds)
res <- results(dds)

to_plot = data.frame(res)
to_plot$color = "adjusted p-value > 0.05"
to_plot[which(to_plot$log2FoldChange > 0 & to_plot$padj < 0.05),]$color = "Increased expression when paired"
to_plot[which(to_plot$log2FoldChange < 0 & to_plot$padj < 0.05),]$color = "Increased expression when alone"

# save result ============================================================================
write.table(to_plot,paste0(base_dir,sel_species,".DESeq"),
            sep = "\t",quote = F
            )

# plot
ggplot(to_plot,aes(log2FoldChange,-log10(padj),col=color))+geom_point()+
  xlab("Log 2 fold changes")+
  ylab("- log10(adjusted p-value)")+
  scale_color_manual(values=c("#999999", "#d6604d", "#2166ac"))+
  theme_bw()+
  theme(legend.title=element_blank())+
  ggtitle(sel_species)

}