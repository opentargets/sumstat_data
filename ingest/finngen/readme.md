Ingest Finngen sumstats
============================

Spark workflow to read, clean and transfrom summary stats from Finngen dataset.

#### Usage

```

# Get list of input files on GCS
gsutil -m ls "gs://genetics-portal-analysis/finngen-v2/summary_stats/finngen_*.gz" > configs/inputs/gcs_input_paths_finngen.txt

# Get list of existing output files
gsutil -m ls "gs://genetics-portal-sumstats-b38/unfiltered/gwas/*/_SUCCESS" > configs/inputs/gcs_completed_paths.txt

# Get list of phenotypes https://gist.github.com/mkarmona/35287a6662b82c3bf6f78797f628c2f8
curl http://r2.finngen.fi/api/phenos | jq -r '.[]| @json' > configs/inputs/r2_finngen.json

# Create manifest file
python create_finngen_manifest.py

# Start cluster (see below)

# Submit jobs to cluster
python run_all.py

# Check that its working as expected, then increase cluster number of workers


# Check outputs and any errors
```

#### Starting a Dataproc cluster

```
# Start large server
gcloud beta dataproc clusters create \
            mk-ingest-finngen \
            --image-version=preview \
            --metadata 'CONDA_PACKAGES=scipy' \
            --initialization-actions gs://dataproc-initialization-actions/python/conda-install.sh \
            --properties=spark:spark.debug.maxToStringFields=100,spark:spark.master=yarn \
            --master-machine-type=n1-highmem-16 \
            --master-boot-disk-size=1TB \
            --num-master-local-ssds=0 \
            --num-secondary-workers=0 \
            --worker-machine-type=n1-highmem-16 \
            --num-workers=2 \
            --worker-boot-disk-size=1TB \
            --num-worker-local-ssds=1 \
            --region=europe-west1 \
            --zone=europe-west1-d \
            --initialization-action-timeout=20m \
            --max-idle=15m \
            --project=open-targets-genetics


# To monitor
gcloud compute ssh mk-ingest-finngen-m \
  --project=open-targets-genetics \
  --zone=europe-west1-d -- -D 1080 -N

"EdApplications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --proxy-server="socks5://localhost:1080" \
  --user-data-dir="/tmp/mk-ingest-finngen-m" http://mk-ingest-finngen-m:8088
```

Dataproc info: https://stackoverflow.com/questions/36506070/how-to-queue-new-jobs-when-running-spark-on-dataproc
Dataproc page: https://cloud.google.com/dataproc/docs/concepts/accessing/cluster-web-interfaces
