# HTTP Archive Topics API Classification
[![DOI](https://zenodo.org/badge/800720707.svg)](https://doi.org/10.5281/zenodo.17584315)

Classification of HTTP Archive origins by the Topics API.

## Getting Started

1. Clone this repository along with its submodule with: `git clone --recurse-submodules <HTTPS or SSH URL>`.

2. Place the `.csv` files with the HA origins under ha_urls.

3. Launch classification (we recommend using a `screen` session):
 - (if you have dependencies installed): `./classify_origins.sh`
   - **System Dependencies:** `python3`, GNU `parallel`, `unzip`
   - **Python Dependencies:** `pandas`, `tflite-support`
 - (if using Docker): 
    ```
    docker build -t topics-image:latest .
    docker run --rm -it -v ${PWD}:/workspaces/topics \
        -w /workspaces/topics --entrypoint ./classify_origins.sh topics-image:latest
    ```
4. Refer to the created `.tsv` file for the classification results. Find the
   corresponding taxonomy under the corresponding folder in `topics_classifier`
   (-2 stands for the Unknown topic).



## Parallelization

To classify millions of domains, make sure to deploy a VM with a large number of
vCPUs to leverage GNU parallel to its full extent. No special need for RAM or
storage behind the minimum required for the instance chosen.

As a reference, classifying the latest CruX top 1M list on an `c6g.8xlarge`
(32 vCPUs) `ec2` instance takes about 40 minutes.