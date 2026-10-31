# Releasing a new version of dplace-cldf on d-place.org

```shell
git clone --branch v3.3.0 --depth 1 https://github.com/d-place/dplace-cldf
git clone --branch v5.3 --depth 1 https://github.com/glottolog/glottolog
git clone https://github.com/D-PLACE/dplace2
cd dplace2
pip install -e .[test]
```

Recreate the database:
```shell
clld initdb development.ini --cldf ../dplace-cldf/cldf/StructureDataset-metadata.json --glottolog ../glottolog
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
pg_dump -xO --compress gzip:9 dplace2 > dplace2.sql.gz
```

