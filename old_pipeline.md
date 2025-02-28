2. a dataset to be analyzed obtained using the midiaPASEF acquisition method

This dataset should contain measurements of both unfragmented peptides fragments. The
datasets must follow a naming convention “<UPPER CASE LETTER><some numbers>.d”,
e.g. `G8027.d` or `Z3232323.d`. Please rename your folders for the analysis.
       
3. a dataset with the same window scheme but obtained without fragmentation, so called calibration set.
       
It allows us to estimate the real positions of quadrupole selection windows. For that reason exactly the same window scheme must be used, and the sample should be such as to produce a lot of peptides to make it simpler to estimate correct positions of quadrupole selection windows for every window group and (second tims trap) scan. Observe that also that dataset must respect the naming conventioned mentioned above, e.g. `G8045.d` or `Z3232325.d`.

4. a fasta file with protein sequences you judge could be contained in the dataset mentioned in 1.

For example, these could be proteins corresponding to homo sapiens, wheat, and so on, typically downloadable from UNIPROT DB. In our group, we typically append a list of typical contaminants. By default, SAGE search is performed so that SAGE automatically reverses the sequences for FDR calculations, so the provided sequences should not contain reversed sequences if you have decided not to modify SAGE settings. 
In our group we have automated the download of fastas and appending of contaminants in a script available on github (https://github.com/MatteoLacki/tenzer_fastas).

5. optionally, to modify the configuration files.


Note that warnings such as `WARN[0000] Found orphan containers ...` should not impact the working of the pipeline.
Those appear when you have pulled more than one image from our dockerhub (perhaps an update). 
Make sure that you are using the right image by checking its hash with `docker image ls`.
Note that nobody really knows how to maintain docker images so you are in a very good club, i.e. with us in it too.

# Structure and running the pipeline.

The pipeline is file-system based, using a collection of folders to store configuration files,
scripts, rules on using the scripts, and data. In case of using docker distribution, most of that
folder structure is hidden from the user’s eye (unless he decides to enter the docker
environment in the interactive mode). In both cases, the user should know that structure to
understand how to configure her pipelines, provide inputs, and define requested outputs.

After installing the pipeline, you need to:

1. Copy your data into the spectra folder. 
   
   Do remember about the naming convention “<UPPER CASE LETTER><some numbers>.d”, e.g. `G8027.d` or `Z3232323.d`. Each of those data folder must contain files analysis.tdf and analysis.tdf_bin. Other files are currently neglected by the pipeline.
   
2. Copy you fasta file used to analyze the dataset in the `fastas` folder.
   
3. Adjust configuration files found in the configs folder.

Entry level users are suggested to use the pipeline rule collecting the various results of the pipeline instead of directly calling different partial results rules. The configuration of that rule are available in `configs/outputs`. To call that rule using configuration file `configs/outputs/all.toml`, the user needs to run:

./run snakemake -call outputs/all/G8027/G8045

If you create a new output configuration file, adjust the path above for its new name. Users can copy and trim `configs/outputs/all.toml` to obtain a subset of targets, or include more intermediate results.
All such configs start with:

```python
# configs/outputs/all.toml
parametrization_path = "dataset/calibration"

[final_locations]
analysis_tdf_sha256 = "checksums/dataset_analysis_tdf.sha256"
analysis_tdf_bin_sha256 = "checksums/dataset_analysis_tdf_bin.sha256"
calibration_analysis_tdf_sha256 = "checksums/calibration_analysis_tdf.sha256"
calibration_analysis_tdf_bin_sha256 = "checksums/calibration_analysis_tdf_bin.sha256"

raw_data_marginal_plots_folder = "QC/dataset"
raw_calibration_marginal_plots_folder = "QC/calibration"

fasta_sha256 = "checksums/first.fasta.sha256"
second_gen_fasta_sha256 = "checksums/second.fasta.sha256"
...
```

The parametrization path entry dictates how to interpret the part of the path after the name of
the script, e.g. in case `snakemake -call outputs/all/G8027/G8045`, Snakemake will know
that G8027 and G8045 corresponds to `dataset` and `calibration` wildcards respectively.
Section [final_locations] says which path template should end up where in the requested
folder. For example, the sha256 check-sum should be ultimately stored under

```
outputs/all/G8027/G8045/checksums/dataset_analysis_tdf.sha256
```

The calculation of checksums is done to assure files were not modified during internet transfers or were not object of other possible modifications.
Finally, section [fixed_wildcards] specifies which default values of wildcards will be used to instantiate the path templates,
turning them into a proper path. 
This section might look like:

```toml
[fixed_wildcards]
ms2_comparisons_config="default"
clusterer_1="tims"
clusterer_2="tims"
clusterer_1_version="1fd37e91592"
clusterer_2_version="1fd37e91592"
clusterer_1_config="default"
clusterer_2_config="default"
cluster_stats_1="fast"
cluster_stats_2="fast"
cluster_stats_1_config="default"
cluster_stats_2_config="default"
cluster_stats_histograms_config="default"
rough_matches_algo="prtree"
rough_matches_config="narrow"
mgf_config="default"
sage_version="95c2993"
sage_config_1="p12f15nd"
sage_config_2="p12f15nd"
fasta="3"
sage_remapping_config="default"
mz_recalibration_config="xgboost"
fdr_filter="default"
second_gen_ppm_settings="c2_c98"
fasta2gen="3"
ml_edges_config="default"
edge_kilograms_config="negative_edges"
edge_refinement_config="baseEdgeStats^positiveEllipse^maxRank=12_depleted"
ms2rescore_config="default"
ms2rescore_version="v3.0.0-b5"
```

This section specifies which config files or rule wildcards to use while executing the pipeline.
For example, `sage_version="95c2993"` is short for saying: while using rule `search_with_SAGE` (or any inheriting rule), use sage at version `95c2993`, corresponding to one of the MIT licensed Bruker forks of the official SAGE.

It is possible to write customized scripts in order to make it simpler to explore the space of possibilities.
For instance, if the user wanted to test multiple SAGE settings, to be run with SAGE version `95c2993` used by default, she would need to prepare in advance several configuration jsons files, say `test1.json`, `test2.json`, ..., `test20.json`, put them
all under `configs/search/sage/95c2993`, create a copy of the `all.toml` settings, say
`configs/outputs/testsage.toml`. In that file, she would need to modify the parametrization path
to make sage configurations into a variable, for example

```
parametrization_path = “dataset/calibration/sage_config_1/sage_config_2”
```

Then, she would not need to provide all of the configs in that file, but could specify them in
the command line:

```
snakemake –call outputs/testsage/G8027/G8045/test{1..20}/test{1..20}
```

That would run all of 400 possible sage combinations for first and second generation SAGE,
as bash would unwind the short expression `test{1..20}/test{1..20}` to`test1/test1,test2/test1,...,test20/test20`. 
It is relatively straightforward to provide paths directly using any modern text editor.


Depending on what exactly would the user like to get copied into the output folder, the user
would have to remove or add possible targets into [final_locations] section. That of course
leads to question, what can she ask for? All of the possible targets are collected by name in
the `workflow/rules/path_templates.smk` file, in the make_path_templates function. An example
of the top of the list of this file is provided below. We collect the possible Snakemake targets
this way in order not to need to remember how to construct them. The user can choose from
any of the entries collected in the PT simple namespace. For example, putting
`PT.analysis_tdf_sha256` entry corresponds to the sha 256 hash number calculated for the
dataset’s analysis.tdf sqlite3 database with the meta information on the sample. If the user
wanted to have that number, she would need to insert an entry `analysis_tdf_sha256 = “
checksums/analysis_tdf.sha256”`` into her pipeline configuration file, as shown above (or under
a different path: “checksums/analysis_tdf.sha256” is just the suggested final location and
name of the file and the user can modify it for example to simply the collection of results across
multiple lines of the pipeline).