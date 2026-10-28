# Releasing a new version of dplace-cldf on d-place.org

```shell
git clone --branch v3.3.0 --depth 1 https://github.com/d-place/dplace-cldf
git clone https://github.com/d-place/dplace2
cd dplace2
pip install -e .[test]
```

Recreate the database:
```shell
clld initdb development.ini --cldf ../dplace-cldf/cldf/StructureDataset-metadata.json --glottolog ../../glottolog/glottolog --glottolog-version v5.2
```

```shell
pytest
```

Store the tested requirements:
```shell
pip freeze > requirements.txt
```

Store a db dump:
```shell
pg_dump -xO dplace2 > dplace2.sql
zip dplace2.sql.zip dplace2.sql
rm dplace2.sql
```

