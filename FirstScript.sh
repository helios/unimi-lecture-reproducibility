!#/usr/bin/env bash

source activate unimiPhD

wget ftp://ftp.ensembl.org/pub/release-95/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.chromosome.19.fa.gz

gunzip Homo_sapiens.GRCh38.dna.chromosome.19.fa.gz

wget ftp://ftp.ensembl.org/pub/release-95/gtf/homo_sapiens/Homo_sapiens.GRCh38.95.gtf.gz

gunzip Homo_sapiens.GRCh38.95.gtf.gz

mkdir GenomeDir

STAR --runThreadN 4 --runMode genomeGenerate --genomeDir ./GenomeDir --sjdbGTFfile Homo_sapiens.GRCh38.95.gtf --genomeFastaFiles Homo_sapiens.GRCh38.dna.chromosome.19.fa

#curl -o ERR431583_1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR431/ERR431583/ERR431583_1.fastq.gz
#curl -o ERR431583_2.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR431/ERR431583/ERR431583_2.fastq.gz

#scp user@192.168.200.213:ERR431583_1.fastq.gz ERR431583_1.fastq.gz
#scp user@192.168.200.213:ERR431583_2.fastq.gz ERR431583_2.fastq.gz

fastqc -t 2 ERR431583_1.fastq.gz ERR431583_2.fastq.gz

trimmomatic PE -threads 4 -phred33 ERR431583_1.fastq.gz ERR431583_2.fastq.gz R1_P.fastq.gz R1_U.fastq.gz R2_P.fastq.gz R2_U.fastq.gz ILLUMINACLIP:${CONDA_PREFIX}/share/trimmomatic-0.38-1/adapters/NexteraPE-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

STAR --genomeDir ./GenomeDir \
     --runThreadN 4 \
     --readFilesIn R1_P.fastq.gz R2_P.fastq.gz \
     --readFilesCommand zcat \
     --genomeLoad LoadAndRemove \
     --outFileNamePrefix MySample_ \
     --outReadsUnmapped Fastx \
     --outSAMstrandField intronMotif \
     --outFilterIntronMotifs RemoveNoncanonicalUnannotated \
     --quantMode GeneCounts \
     --outSAMtype BAM SortedByCoordinate \
     --limitBAMsortRAM 5000000000

samtools sort -o MySample_SortedByName.bam -O bam -n -@ 4 BAMFILE

samtools index MySample_SortedByName.bam
