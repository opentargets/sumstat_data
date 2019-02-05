#!/usr/bin/env bash
#

# Download sumstats
for inf in 1990.binary.gwas.imputed_v3.both_sexes.tsv.gz 1873.ordinal.gwas.imputed_v3.both_sexes.tsv.gz 84_raw.continuous_raw.gwas.imputed_v3.both_sexes.tsv.gz; do
  gsutil cp gs://genetics-portal-raw/uk_biobank_sumstats/neale_v2/raw/$inf - | zcat | head -10000 | gzip -c > ${inf/.tsv.gz/.head.tsv.gz}
done

# Get phenotype file
# wget https://www.dropbox.com/s/d4mlq9ly93yhjyt/phenotypes.both_sexes.tsv.bgz -O phenotypes.both_sexes.tsv.gz
# gunzip phenotypes.both_sexes.tsv.gz

echo COMPLETE