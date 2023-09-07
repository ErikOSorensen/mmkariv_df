# Preparing data (assembling, applying metadata) for "The Development Gap in Economic Rationality of Future Elites"

- Alexander W. Cappelen
- Shachar Kariv
- Erik Ø. Sørensen (contact person for questions about the data)
- Bertil Tungodden



## Input data files

These files are included in this preparation package.

| Input file | Description |
| --- | --- |
| `raw_data/iqfasit.csv` | Correct answers to each of the iq matrix questions. |
| `raw_data/iqmatrices.csv` | Submitted answers to iq matrix questions (in sessions with working internet). |
| `raw_data/noincentivequestions.csv` | Submitted answers to survey (in sessions with working internet). |
| `raw_data/050112_S9.dta` | Incentivized responses (decisions under uncertainty). Includes some testing data. |
| `raw_data/data_tanzania_26JUNI.xlsx` | Non-incentivized responses from session without working internet (punched by hand). |
| `raw_data/jonasiq.csv` | IQ responses from session without working internet (punched by hand). |
| `raw_data/jonasbig5.csv` | Big-5 responses from session without working internet (punched by hand). |
| `raw_data/jonasothers.csv` | Other responses from session without working internet (punched by hand). |
| `processed/birthplaces_categorized.csv` | Birthplace was a free-form input. This file maps freeform response to official region. |
| `processed/studysubjects_categorized.csv` | Study subject was a free-form input. This file maps freeform responses to a small set of categories. |

## Output files

These files are created by the scripts supplied, and are not themselves included
in this release. Instead, the output files are available, with documentation,
at Harvard Dataverse (https://XXX/).


| Output file | Description
| --- | --- |
| `data/background.dta` | Demographics and responses to non-incentivized questions, calculated Big-5 and IQ scores. |
| `data/big5items.dta`  | Responses to each of the items in the Big-5 questionnaire. |
| `data/decisions.dta`  | Each decision from of each of the participants. |
| `data/iqmatrices.dta` | Each response to a matrix progression question from each of the participants. |
| `data/tanzaniasurvey.dta` | Responses to a Tanzania-only post-experiment survey (cannot be linked to rest of experiment). |
| `data/calculated_RP_measures.dta`| Pre-calculated Revealed Preference measures following Pollison et al.|

Some intermediate outputs are saved in the  `processed/` directory, but these
are not part of the canonical output.

## Running script with AEA docker container

This command runs all the programs and saves the output in `data/`.
With the localization of Stata license on my computers, this is the
correct volume mounting to let the AEA Stata container access the license.

```sh
docker run --rm -ti -v /usr/local/stata17/stata.lic:/usr/local/stata/stata.lic \
    -v ${PWD}:/code --entrypoint stata-se dataeditors/stata17:2022-11-15 \
    -b do scripts/all_data_reads.do
```

Note that it is necessary to set an `entrypoint` if you don't have an Stata-MP license,
which is the default Stata binary for the AEA image.
This file is run by the shell script `main.sh`.

Note that running `stata -b do all_data_reads.do` from the command line
*should* do the same thing, but in a slightly less controlled manner.
