# Prerequisites

To run the pipeline you will need an installed pipeline, preferentially using the docker image.
We assume a working Docker instance with user added to the docker group.

The sofware was tested on Linux, Linux subsystem for Windows, and MacOS docker installations.
Current hardware requirements vary on dataset, but can go up to 256GB of RAM used while running fragment clustering.

# Installation

* Click [here](https://github.com/midiaIDorg/midiaID/archive/refs/heads/main.zip) to download the `midiaID-main.zip` file.
* Unzip file and get into the unzipped folder.
* On Linux, run `./install_linux stable`. On Windows, run `./install_windows stable`.

That will:
* pull the stable image from dockerhub.
* mount subfolders in the unzipped folder to the image and copy their contents.
* create a `run` command.

After that is done, check that you can see snakemake help by running `./run snakemake --help`. 
If you want to inspect the contents of the midiaID container, tap `./run /bin/bash`.

If you want to use the experimental pipeline, exchange `stable` for `experimental` in all steps above.
We recommend doing that in a separate folder to avoid overwriting previously created configs.


# Folder structure:

* `configs`

Here we keep all the pipeline configuration files.
Installing pipeline will fill it with the right content.

* `credentials`

Here you can optionally keep AWS and ssh credentials that the pipeline `midia_fetch` module can use to automate pulling down data.

* `fastas`

Here we keep fasta files used in the pipeline. Some can be automatically pulled down from our [website](https://bioputer.mimuw.edu.pl/~matteo/fastas).

* `manual`

Folder with pipeline-specific manual.

* `midia_dev`

Folder used for docker-based pipeline development.

* `outputs`

Folder containing final pipeline outputs.

* `P`, `partial`, `tmp`

Folders with temporary pipeline outputs.

* `snakemake`

Folder with `snakemake` internals, internally corresponding to `.snakemake`.

* `spectra`

Folder where to put the raw data.



# Running a pipeline

To learn how to run a pipeline, run:

`./run snakemake outputs/base/intro`

That will run a test pipeline.
In general, you will be running the pipeline as 
`./run snakemake outputs/<pipeline_name>/<pipeline_config>/<other_pipeline_arguments>`
but run `outputs/base/intro` first for a pipeline-specific introduction.


# Regression

To run regression test suite:

1. (if you haven't done it already or the image is old): run `./install.sh`. WARNING: this will likely delete contents of `configs`: make sure you saved those.
2. Run `./run_regression.sh`.

Note that warnings such as `WARN[0000] Found orphan containers ...` should not impact the working of the pipeline.
Those appear when you have pulled more than one image from our dockerhub (perhaps an update). 
Make sure that you are using the right image by checking its hash with `docker image ls`.
Note that nobody really knows how to maintain docker images so you are in a very good club, i.e. with us in it too.

That will spin up a midiaID container with awscli tools.
You will be asked to provide your AWS secrets.
Do it: it will most likely not be sent out to CIA.
Then the normal regression suite will start.
Before it fails (hopefully not), all of the data pulled from AWS that were downloaded will persist in the spectra folder.
For it is mounted on the host.
If you will need to repeat, that data will be already there, but you will need to put your secrets again.

Best wishes,

Your system administrator.


# Licensing

Licences of the pipeline are pipeline specific and to be found after pipeline installation in folder LICENSES.
