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
* pull the stable image from dockerhub
* mount subfolders in the unzipped folder to the image and copy their contents. After that is done, check that you can see snakemake help by running `./run snakemake --help`. 
* create a `run_stable` command.

If you want to inspect the contents of the midiaID container, tap `./run_stable /bin/bash`.

If you want to use the experimental pipeline, exchange `stable` for `experimental` in all steps above.


# Running a pipeline

1. TODO: move that to the pipeline. Each pipeline should come with its own README with usage instructions.


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
