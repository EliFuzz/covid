# COVID-19

## Description
Bash script for fetching data from Worldometers website regarding COVID-19 or SARS-COV-2 

## Usage

1. Execute script:
```bash
Usage: bash z.sh <yesterday|today>

Example:
    ./z.sh yesterday
    ./z.sh today
```
2. Script will generate JSON file in the same folder

## Crontab Settings:
1. Run every hour:
```bash
0 * * * * bash /path-to/z.sh
```

## Data source

- [https://worldometers.info/coronavirus/](https://worldometers.info/coronavirus/)
