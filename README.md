# Replication template with nix (rix)!

# Overall summary and high-level instructions

This is a README for the replication template made by [Hyoungchul Kim](hchulkim.github.io). This README summarizes and describes how to use this template for reproducible research workflow. For a more detailed instructions on how to use this template (and benefits of using it), consult to my [blog post](https://hchulkim.github.io/posts/reproducible-template/).

If you intend to use my template, make sure you erase all the contents in the README and replace it with your own README. This README is just recommendations for certain research workflow you could follow. Normally, you would write something like [social science replication README template](https://social-science-data-editors.github.io/template_README/). For convenience, I also put my example README template in [Example template](#example-readme-template). They are based on [DCAS](https://datacodestandard.org/) and [AEA DCAS](https://www.aeaweb.org/journals/data/data-code-policy).

# Information on overall replication workflow

## 0. Workflow

When starting research, you should consider logistics between 2 or 3 components:

- Dropbox folder
- local folder
- (optional) Overleaf

### Dropbox folder (data)

This is your folder for hosting data. It is nice to have Dropbox as the folder for your data because data becomes too large to just host it on your local folder.

### local folder (main machine)

This is your main folder for analysis. You should put everything other than data in the local folder.

### (optional) Overleaf

Sometimes this is useful for collaborating and writing papers. But you should do this only if you have premium subscription so you can use the Dropbox syncing feature.

### Coding workflow

0. Set git in local folder.
1. Use symlink to link Dropbox data folder to `input` file in the local folder. This allows you to use data as if you have them in your local folder.
2. Use symlink to link Overleaf `output` folder to `output` file in the local folder. This allows you to access output results in the overleaf (Only if you have premium subscription).
3. Overall flow: Do all the analysis in the local folder and use git to record them. Write reports/papers in the overleaf.

## 1. Requirements

This workflow requires:
- [Bash](https://www.gnu.org/software/bash/) [Free]
- [R](https://www.r-project.org/) [Free]
- [nix/rix](https://docs.ropensci.org/rix/articles/a-getting-started.html)[Free]

Other great languages and softwares may also be used.
- [Julia](https://julialang.org/) [Free]
- [Python](https://www.python.org) [Free] 
- [LaTeX](https://www.latex-project.org) [Free]
- [Stata](https://www.stata.com) [Licensed]
- [Matlab](https://www.mathworks.com/products/matlab) [Licensed]

For now, it is only adapted for Linux or OSX (Apple) environments. But feel free to adapt it to Windows.

#### Dependency management

It is important to set up dependency management for the programming languages we use for replication and reproducibility. I mainly use `rix` R package that leverage `nix` package manager which focuses on reproducible builds. `nix` allows you to create project-specific environments and ensures full reproducibility.

If you want to know more about `rix/nix`, start from here: [https://docs.ropensci.org/rix/index.html](https://docs.ropensci.org/rix/index.html).

**TIP**: After following installation instructions on [https://docs.ropensci.org/rix/index.html](https://docs.ropensci.org/rix/index.html), add this into your `/etc/nix/nix.custom.conf` before installing `cachix` client and configuring `rstats-on-nix` cache:

```
trusted-users = root [NAME OF THE USER FOR YOUR COMPUTER]
```

After that, run this command in the terminal and then do the `chachix` installation and configuration for `rstats-on-nix` cache.

```
sudo systemctl restart nix-daemon
```

This will prevent some warnings from popping up when you use `nix-shell`.

## 2. Folders

##### `src`

- This folder contains all the code that builds data and performs analyses.
- All intermediary data results should be redirected into `input/temp`.
- All final data results should be redirected into `input/proc`.
- All output tables and figures should be redirected into `output/tables` and `output/figures` respectively.
- Keep the names of the code files clear and easy to understand. Try to number them as well.
  
##### `input`

- A folder that contains all the input data.
- Has subfolders `raw`, `temp`, `proc`, which contain raw data, intermediary data, and processed data (ready for analysis).
  
##### `output`

- A folder that contains all the outputs.
- Has subfolders that contain figures and tables.
- `slides` subfolder contains slides for presentation.
- `paper` subfolder contains working paper.

## 3. Leveraging on Github capabilities

- Use GitHub wiki as a document for overall project information, project goals, milestones, and anything that should be permanently documented.
- Use issues as tasks. Link them in the wiki as well. 
- Use branches to ensure your main research workflow is not corrupted. Also modify files via pull requests.

## Things to note for reproducibility

Some sections in this template may need to be updated in the future. I’ll periodically handle the updates, but if any issues arise, please check whether they are related to these sections.

1. `Dockerfile`: You can run the `Dockerfile` to create a container for your project.
2. `.github/workflows/`: You can use GitHub actions to automate your project build process.

For more information on some trials and errors related to the `Dockerfile`, check this [blog post](https://hchulkim.github.io/posts/dockerfile-trial/)

# Example README template

When you are creating your own research project based on this GitHub template, only keep the format below and erase all the contents above. Also erase the [README documentation and checklist section](#readme-documentation-and-checklist) below.

## README documentation and checklist

This part should contain following information:

1. Documentation: A README document is included, containing a Data Availability Statement, listing all software and hardware dependencies and requirements (including the expected run time), and explaining how to reproduce the research results. The README follows the schema provided by the Social Science Data Editors’ template README
2. Data availability statement: A Data Availability Statement is provided with detailed enough information such that an independent researcher can replicate the steps needed to access the original data, including any limitations and the expected monetary and time cost of data access.
3. Location: Data and programs are archived by the authors in the repositories deemed acceptable by the journal.
4. Citation: All data used in the paper are cited.
5. License: A license specifies the terms of use of code and data in the replication package. The license allows for replication by researchers unconnected to the original parties.
6. Omissions: The README clearly indicates any omission of the required parts of the package due to legal requirements or limitations or other approved agreements.

For a more detailed instructions, click this [link](https://aeadataeditor.github.io/aea-de-guidance/preparing-for-data-deposit.html).

- [ ] Data Availability and Provenance Statements
  - [ ] Statement about Rights
  - [ ] License for Data (optional, but recommended)
  - [ ] Details on each Data Source
- [ ] Dataset list
- [ ] Computational requirements
  - [ ] Software Requirements
  - [ ] Controlled Randomness (as necessary)
  - [ ] Memory, Runtime, and Storage Requirements
- [ ] Description of programs/code
  - [ ] License for Code (Optional, but recommended)
- [ ] Instructions to Replicators
  - [ ] Details (as necessary)
- [ ] List of tables and programs
- [ ] References (Optional, but recommended)

## Citation

You can cite our repo using following notation:

```
Hyoungchul Kim (2025). "Replication template with nix" https://github.com/hchulkim/replication-template-nix
```

## Data Availability and Provenance Statements

**IMPORTANT**: Note that this GitHub repo does not provide the `input/` (data) folder due to the large size of the datasets. They are provided [HERE]. While we do not list all the coding packages we use in our analysis (they are listed in our `renv.lock` file), we do list some important packages that were essential components of our analysis for transparency.

| Data.Name  | Data.Files | Location | Provided | Availability statement |
| -- | -- | -- | -- | -- | 
| “UN Comtrade data” | `comtrade_{COUNTRY}_h{0-5}.csv` | `data/comtrade/` | TRUE | Data on international trade flows were downloaded from the United Nations Comtrade Database (UN Comtrade, 2025) using a premium API subscription. We use annual bilateral trade data at the HS 6-digit level from the "Comtrade Bulk Data" service. Data can be accessed through https://comtradeplus.un.org/ (under "Bulk Data Download") or retrieved programmatically using the Comtrade API ([https://comtradeplus.un.org/API](https://comtradeplus.un.org/API)). A copy of the data used in this study is provided as part of this archive. The data are publicly available but require a registered UN Comtrade account for bulk download access. | 
| "GDP deflator values" | [`tradstatistics` R package](https://docs.ropensci.org/tradestatistics/index.html) | No physical files | TRUE (provided as an installed package from the GitHub repository.) | For adjusting UN Comtrade values between different years, we use dataframe `ots_gdp_deflator` from a public R package named `tradestatistics` provided at [https://github.com/ropensci/tradestatistics](https://github.com/ropensci/tradestatistics). In order to preserve the R package dependency, we also compress the GitHub repository in `data/concordance/tradestatistics-master.zip`. |
| "Consumer Price Index for Korea" | `cpi_korea.xlsx` | `data/cpi/` | TRUE | Data on Consumer Price Index (CPI) for Korea was obtained from "CPI survey" by Statistics of Korea which can retrived from [https://www.index.go.kr/unify/idx-info.do?idxCd=4226](https://www.index.go.kr/unify/idx-info.do?idxCd=4226). It was used as a reference for adjusting past nominal wage to 2019 adjusted real wage. A copy of the data used in this study is provided as part of this archive. |
| “Internal migration data of South Korea” | `migration1995.csv` ~ `migration2020.csv` | `data/migration/` | TRUE | Data on internal migration within South Korea were obtained from the Microdata Integrated Service (MDIS) of Statistics Korea (KOSTAT, 2025). We use individual-level data from the Population and Housing Census: Internal Migration Survey. Data can be accessed at [https://mdis.kostat.go.kr](https://mdis.kostat.go.kr) under “마이크로데이터 > 주택/인구총조사 > 인구이동조사” (Microdata > Population/Housing Census > Internal Migration Survey). Although the data are publicly available, access requires creating an account and obtaining approval through the MDIS system. A copy of the data used in this study is included as part of this archive. |
| “Administrative districts (shapefile) of South Korea” | `bnd_sigungu_00_2019_4Q.shp`; `bnd_sigungu_00_2019_4Q.dbf`; `bnd_sigungu_00_2019_4Q.prj`; `bnd_sigungu_00_2019_4Q.shp.xml`; `bnd_sigungu_00_2019_4Q.shx` | `data/region/` | TRUE | Data on administrative districts of South Korea were obtained from [SGIS](https://sgis.kostat.go.kr/view/index) of Statistics Korea (KOSTAT, 2025). The shapefile we use are boundaries set in December 2019. While the data are publicly available from SGIS, access requires creating an account and obtaining approval. A copy of the data used in this study is included in this archive. |
| "Commuting zone of South Korea" | `cz_data.xlsx` | `data/cz/` | TRUE | Data on commuting zones of South Korea were constructed following the methodology of [Lee and Lee (2015), “Delimitation of City-Regions Based on the Method of Travel-to-Working Area and Analyzing Spatial Structure of City-Regions”, The Korea Spatial Planning Review, 84, 165–189.](https://doi.org/10.15793/kspr.2015.84..010) Using commuting flow information and the procedure described in their study, we group 226 administrative districts (si/gun/gu) into 33 commuting zones that approximate local labor markets. While the original commuting flow data are not publicly available, our crosswalk between districts and commuting zones—constructed based on the figures and descriptions in Lee and Lee (2015)—is provided as part of this archive. |
| "Korea’s Census on Establishments" | `est1994.csv`; `est1996.csv`; `est1999.csv`; `est2000.csv`; `est2001.csv`; `est2010.csv`; `est2019.csv` | `data/est/` | TRUE | Data on business establishments in South Korea were obtained from the Census on Establishments via the Microdata Integrated Service (MDIS) of Statistics Korea (KOSTAT, 2025). This annual census covers all establishments with one or more employees (excluding individual agricultural, forestry, and fisheries, and certain public organizations) as of December 31 each year, providing detailed information on establishment name, location, industry classification, employees, annual sales, founding date, and more. Data can be accessed through the MDIS portal at [https://mdis.kostat.go.kr](https://mdis.kostat.go.kr). While the data are publicly available, access requires user registration and login via the MDIS system. A copy of the data used in this study is included in this archive. |
| "Crosswalk for HS codes to ISIC Rev.4 codes" | [concordance R package](https://github.com/insongkim/concordance?tab=readme-ov-file#installation-instructions) | No physical files | TRUE (provided as an installed package from the GitHub repository.) | For crosswalking HS codes in UN Comtrade to ISIC Rev.4 codes, we use public R package named **concordance** provided at [https://github.com/insongkim/concordance?tab=readme-ov-file#installation-instructions](https://github.com/insongkim/concordance?tab=readme-ov-file#installation-instructions). For a detailed crosswalk procedure, check the GitHub repository. In order to preserve the R package dependency, we also compress the GitHub repository in `data/concordance/cconcordance/concordance-master.zip`. **IMPORTANT**: Make sure you install the developer version as conversion from HS to ISIC is provided through the developer version. |
| "Crosswalk for ISIC Rev.4 codes to KSIC10 codes" | `isic4_ksic10.xlsx` | `data/concordance/isic` | TRUE | Industry classification crosswalks between ISIC to KSIC were obtained from the official Korean Standard Industrial Classification (KSIC) system, maintained by Statistics Korea. Specifically, we used the conversion tables available at the KSIC website ([https://kosis.kr/eng/bulletinBoard/qnaView.do?boardIdx=335027](https://kosis.kr/eng/bulletinBoard/qnaView.do?boardIdx=335027)). These files provide official mappings between the ISIC and the KSIC system and are publicly available without login. For computational purposes, we only modified the original file name to an English name after downloading; the content of the data remains unchanged. A copy of the conversion file used in this study is included as part of this archive. | 
| "Crosswalk between KSIC 8, 9, 10 codes" | `ksic9_10.xlsx`; `ksic8_9.xls`; `ksic_old.xls`  | `data/concordance/ksic` | TRUE | Industry classification crosswalks were obtained from the official Korean Standard Industrial Classification (KSIC) system, maintained by Statistics Korea. Specifically, we used the KSIC version conversion tables available at the KSIC website ([https://kssc.kostat.go.kr:8443/ksscNew_web/index.jsp#](https://kssc.kostat.go.kr:8443/ksscNew_web/index.jsp#)). These files provide official mappings between different versions of the KSIC system and are publicly available without login. For computational purposes, we only modified the original file name to an English name after downloading; the content of the data remains unchanged. A copy of the KSIC conversion file used in this study is included as part of this archive. |
| "Crosswalk between *change in administrative districts of South Korea over the years* and between *institutional differences in region codes*" | `region_stat.xlsx`; `region_kosis.xlsx` | `data/concordance/region` | TRUE | Due to (1) changes in administrative district boundaries and (2) differing numeric codes assigned by two institutions in South Korea—Statistics Korea and the Ministry of the Interior and Safety—it is necessary to establish a consistent concordance of districts in the data. We also need to crosswalk region codes provided by different institutions. In order to accomplish this, the authors have created their own crosswalk tables which is based on [https://kssc.kostat.go.kr:8443/ksscNew_web/index.jsp#](https://kssc.kostat.go.kr:8443/ksscNew_web/index.jsp#). `region_stat.xlsx` table crosswalks the changes in administrative district and `region_kosis.xlsx` crosswalks two different region codes provided by two institutions. In the end, an unique code was assigned to each unit of analysis to ensure consistency across the timeline. For more detail on this matter, you can check out the Appendix in the paper. We have also included files related to this crosswalk in this archive. |

## Replication package expected run-time

This replication package's expected run-time is 000.

## Computational requirements

We strongly suggest following the requirements to install and set up the environment to run the analysis.

### Memory, storage and hardware Requirements

The code was last run on a **Intel-based laptop with Linux Ubuntu 22.04.5 LTS (Jammy Jellyfish) with 1TB of total storage and 64GB of RAM**. Information on number of CPUs and cores is posted below: 

- CPU(s):                                22 
- Thread(s) per core:                   2
- Core(s) per socket:                   16
- Socket(s):                            1 

The project takes up around 000GB of storage.

### OS-Specific Considerations

- Linux (Ubuntu, Fedora (asahi linux), etc) is highly recommended; MacOS is supported.
- Windows is not officially supported. Users may encounter issues with file path formats and parallel processing.

### Bash (terminal)

Portions of the code use bash scripting, which may require Linux or Unix-like terminal

### Reproducible environments (system dependencies)

- The project uses the [`rix`]([https://rstudio.github.io/renv/](https://docs.ropensci.org/rix/index.html)) package to manage and isolate package dependencies. Follow the instructions in the link to install and run `nix` and `rix`.

To initialize the environment run this in the terminal:

```bash
# Restore the project environment
nix-build

# Start the project environment nix shell
nix-shell
```

## Description of programs/code

> INSTRUCTIONS: Give a high-level overview of the program files and their purpose. Remove redundant/ obsolete files from the Replication archive.

- Programs in `programs/01_dataprep` will extract and reformat all datasets referenced above. The file `programs/01_dataprep/main.do` will run them all.
- Programs in `programs/02_analysis` generate all tables and figures in the main body of the article. The program `programs/02_analysis/main.do` will run them all. Each program called from `main.do` identifies the table or figure it creates (e.g., `05_table5.do`).  Output files are called appropriate names (`table5.tex`, `figure12.png`) and should be easy to correlate with the manuscript.
- Programs in `programs/03_appendix` will generate all tables and figures  in the online appendix. The program `programs/03_appendix/main-appendix.do` will run them all. 
- Ado files have been stored in `programs/ado` and the `main.do` files set the ADO directories appropriately. 
- The program `programs/00_setup.do` will populate the `programs/ado` directory with updated ado packages, but for purposes of exact reproduction, this is not needed. The file `programs/00_setup.log` identifies the versions as they were last updated.
- The program `programs/config.do` contains parameters used by all programs, including a random seed. Note that the random seed is set once for each of the two sequences (in `02_analysis` and `03_appendix`). If running in any order other than the one outlined below, your results may differ.

## Instructions to Replicators

**IMPORTANT**: Note that this GitHub repo does not provide the `data/` folder due to the large size of the datasets. They are provided [HERE].

Assuming that you've met the "Computational requirements" above, you can use `git clone` to download this repository. After that, install `nix` and `rix`. Then open the terminal and use `nix-build` to restore the project environment. Finally type `nix-shell` in the terminal to open the project environment.

The entire pipeline now can be executed using the **`Makefile`** master script:

```bash
make
```

> 🛠 **Important:** The `Makefile` must be placed in the top-level project directory — parallel to the `code/` and `data/` folders — for the paths to resolve properly.

On Windows, users may need to install [GNU Make](https://www.gnu.org/software/make/) manually. macOS and Linux users typically have it pre-installed.

If preferred, users can run the R scripts manually in sequence by navigating to the `code/` folder. Each script is prefixed with a number (`0-`, `1-`, etc.) that indicates its order of execution. 

**IMPORTANT**: Refrain from running `raw-data-download.R` unless it is absolutely necessary. This script re-downloads raw data from the original source. Hence, this could affect the stability of the current program if there was a significant change in the data format of the original source.

### Details

- `Makefile`: will run the entire pipeline to ensure reproducibility. All the dependencies between the code scripts are written in the file.
- `code/raw-data-download.R`: will download all UN Comtrade raw bulk data from the source using API key. **DO NOT RUN THIS UNLESS IT IS ABSOLUTELY NECESSARY**
- `code/01-concordance-hs-isic.R`: will create a crosswalk table between HS codes and ISIC Rev.4 codes.
- `code/02-concordance-isic-ksic.R`: will create a crosswalk table between ISIC Rev.4 codes and KSIC10 codes.
- `code/03-concordance-ksic-ksic.R`: will create a crosswalk table between KSIC 8, 9, 10 codes.
- `code/04-concordance-est-district.R`: creates consistent district codes for the whole time span of our analysis for establishment data.
- `code/05-concordance-migration-district.R`: creates consistent district codes for the whole time span of our analysis for migration data.
- `code/06-exposure-construction.R`: creates trade shock exposure for our main analysis.
- `code/07-controls-construction.R`: creates control variables used in our main analysis.
- `code/08-baseline-data-build.R`: creates main dataframe used for our analysis.
- `code/9-main-analysis.R`: creates baseline results.
- `code/10-hetero-analysis.R`: creates results for heterogeneous effects section.
- `code/11-robustness-appendix-analysis.R`: creates results for robustness and appendix sections.
- `code/13-descriptive.R`: creates miscellaneous results (descriptive analysis, country map, etc) for our paper.


## List of tables and programs

All table results are in folder `output/tables` and all figure results are in folder `output/figures`.

| Figure/Table #    | Program                  | Line Number | Output file                      | Note                            |
|-------------------|--------------------------|-------------|----------------------------------|---------------------------------|
| Table 1           | `13-descriptive.R`       |             | `tab1.tex`                       |                                 |
| Table 2           | `10-main-analysis.R`     |             | `tab2.tex`                       |                                 |
| Table 3           | 02_analysis/table2and3.do|             | `tab3.tex`                       |                                 |
| Figure 1          | `13-descriptive.R`       |             | `map_district.png`; `map_cz.png` |                                 |
| Figure 2          |                          |             | `fig2.png`                       |                                 |
| Figure 3          | 02_analysis/fig3.do      |             | `fig3.png`                       |                                 |
| Figure 4          | 02_analysis/fig3.do      |             | `fig4.png`                       |                                 |
| Figure 5          | 02_analysis/fig3.do      |             | `fig5.png`                       |                                 |
|                   |                          |             |                                  |                                 |
| Table A.1         | `11-robustness-appendix-analysis.R` |    | `tab_a1.tex`                     |                                 |
| Table A.2         |                          |             | `tab_a2.tex`                     |                                 |
| Table A.3         |                          |             | `tab_a3.tex`                     |                                 |
| Table A.4         |                          |             | `tab_a4.tex`                     |                                 |
| Table A.5         |                          |             | `tab_a5.tex`                     |                                 |
| Table A.6         |                          |             | `tab_a6.tex`                     |                                 |
| Table A.7         |                          |             | `tab_a7.tex`                     |                                 |
| Table A.8         |                          |             | `tab_a8.tex`                     |                                 |
| Table A.9         |                          |             | `tab_a9.tex`                     |                                 |
| Table A.10        |                          |             | `tab_a10.tex`                    |                                 |

## References

Kaihovaara, Antti and Im, Zhen. (2021). Cleaned Blinder Offshorability Index for ISCO-08 and RTI Index from Owen and Johnston for ISCO-88. (Data used in Kaihovaara, A., & Im, Z. (2020). Jobs at risk? Task routineness, offshorability, and attitudes toward immigration. European Political Science Review, 12(3), 327-345.). 10.13140/RG.2.2.14045.95206/1. 

Korea Labor Institute. (2025). Korean Labor and Income Panel Study (KLIPS), Wave 1 - 4. https://www.kli.re.kr

Kyle Butts. (2025). ssaggregate: R package. https://github.com/kylebutts/ssaggregate.

Sewon Lee and Heeyeon Lee (2015), “Delimitation of City-Regions Based on the Method of Travel-to-Working Area and Analyzing Spatial Structure of City-Regions”, The Korea Spatial Planning Review, 84, 165–189. 10.15793/kspr.2015.84..010

Statistics Korea (KOSTAT). (2025). Census on Establishments [Microdata]. Microdata Integrated Service (MDIS). Retrieved from https://mdis.kostat.go.kr.

Statistics Korea (KOSTAT). (2025). Consumer Price Index Survey. Retrieved from https://www.index.go.kr/unify/idx-info.do?idxCd=4226.

Statistics Korea (KOSTAT). (2025). District shapefiles of South Korea. SGIS. Retrieved from https://sgis.kostat.go.kr.

Statistics Korea (KOSTAT). (n.d.). ISIC–KSIC Classification Conversion Table. Retrieved from https://kosis.kr/eng/bulletinBoard/qnaView.do?boardIdx=335027.

Statistics Korea (KOSTAT). (n.d.). KSIC Version Conversion Tables. Retrieved from https://kssc.kostat.go.kr:8443/ksscNew_web/index.jsp#.

Statistics Korea (KOSTAT). (2025). Population and Housing Census. Korean Statistical Information Service (KOSIS) and Microdata Integrated Service (MDIS). Retrieved from https://kosis.kr/index/index.do and https://mdis.kostat.go.kr. 

Steven Liao, In Song Kim, Sayumi Miyano, and Hao Zhang (2020). concordance: Product Concordance. R package version 2.0.0. https://CRAN.R-project.org/package=concordance.

United Nations. (2025). UN Comtrade Database: International Trade Statistics. Retrieved from https://comtradeplus.un.org/.

Vargas M (2025). tradestatistics: Open Trade Statistics API Wrapper and Utility Program. R package version 5.0.0, https://docs.ropensci.org/tradestatistics/.
