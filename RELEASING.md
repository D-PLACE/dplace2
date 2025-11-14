# Releasing a new version of dplace-cldf on d-place.org

Recreate the database:
```shell
clld initdb development.ini --cldf ../dplace-cldf/cldf/StructureDataset-metadata.json --glottolog ../../glottolog/glottolog --glottolog-version v5.2
```

```shell
pytest
```
