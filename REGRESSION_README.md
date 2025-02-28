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
