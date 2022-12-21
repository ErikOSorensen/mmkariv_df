# Preparing data for "The Development Gap in Economic Rationality of Future Elites"

- Alexander W. Cappelen
- Shachar Kariv
- Erik Ø. Sørensen (contact person for questions about the data
- Bertil Tungodden




## Running script with AEA docker container

This command runs a test script and writes a log file.

```sh
docker run --rm -ti -v /usr/local/stata17/stata.lic:/usr/local/stata/stata.lic \
    -v ${PWD}:/code --entrypoint stata-se  dataeditors/stata17:2022-11-15 \
    -b do test.do
```

Some modifications are necessary in the do-file to ensure that the directories work right
and are with respect to the top level.

