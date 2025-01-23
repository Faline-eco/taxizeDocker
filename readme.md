# Taxize Common Name Resolver Docker

taxize allows users to search over many taxonomic data sources for species names (scientific and common).

This docker image is based on the taxize package allowing to resolve common species names.

## Build

```
docker build -t taxize-api .
```

## Run

```
docker run -p 8000:8000 taxize-api
```

You can provide optional API keys as envrionment variables: 
- TROPICOS_KEY
- IUCN_REDLIST_KEY
- ENTREZ_KEY: Get [here](https://account.ncbi.nlm.nih.gov/settings/)

e.g.
```
docker run -p 8000:8000 -e ENTREZ_KEY=my_awesome_entrez_key taxize-api
```

## Use

POST request to http://localhost:8000/com2sci

With JSON body:
```
{
  "common_names": ["polar bear", "blue whale", "african elephant"],
  "db": "ncbi"
}
```

db: [Data source, one of "ncbi" (default), "itis", "tropicos", "eol", or "worms". If using ncbi, we recommend getting an API key](https://rdrr.io/cran/taxize/man/comm2sci.html)

Should result in:
```
{
    "polar bear": [
        "Ursus maritimus"
    ],
    "blue whale": [
        "Balaenoptera musculus"
    ],
    "african elephant": [
        "Loxodonta"
    ]
}
```