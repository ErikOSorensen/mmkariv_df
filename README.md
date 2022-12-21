# Preparing data for "The Development Gap in Economic Rationality of Future Elites"

- Alexander W. Cappelen
- Shachar Kariv
- Erik Ø. Sørensen (contact person for questions about the data
- Bertil Tungodden




## Running script with AEA docker container

This command runs all the programs and saves the output in `data/`.

```sh
docker run --rm -ti -v /usr/local/stata17/stata.lic:/usr/local/stata/stata.lic \
    -v ${PWD}:/code --entrypoint stata-se dataeditors/stata17:2022-11-15 \
    -b do scripts/all_data_reads.do
```

This file is run by the bash-script `main.sh`.

Note that running `stata -b do all_data_reads.do` from the command line
*should* do the same thing, but in a slightly less controlled manner.
