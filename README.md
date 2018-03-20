# PREP metadata update scripts

Scripts to download metadata from google docs and post to API

Requires:
- `csvtojson` https://www.npmjs.com/package/csvtojson
- `jq` https://stedolan.github.io/jq/download/
- `colordiff` https://www.colordiff.org

# Post new metadata

### 1. Install required libraies, and get your RW API KEY at https://ui.resourcewatch.org/ .

```
sudo npm i -g csvtojson
sudo apt-get install -y jq colordiff
```

You might have to add the node scripts directory to your path.

```
export PATH=$PATH:$(npm bin -g)
```

### 2. Download or update your copy of this repository.

```
git clone https://github.com/fgassert/prep-metadata-edits.git
cd prep-metadata-edits
git pull
```

### 3. Fetch metadata from Google docs and update NEX-GDDP datasets with layer info.

```
./fetch_from_google_docs.sh
```

You can inspect the saved metadata in `jsons/{id}.json` directory. They should follow a format similar to the following.

```json
{
  "info": {
    "wri_rw_id": "prep_0101",
    "technical_title": "Data from the Third National Climate Assessment",
    "published_date": "2014",
    "function": "Projected change in number of days per year with maximum temperatures above 90°F (A2)",
    "language": "English",
    "geographic_coverage": "United States",
    "date_of_content": "2041-2070",
    "data_type": "Raster",
    "spatial_resolution": "1/8th degree",
    "license": "U.S. Government Work",
    "license_link": "https://www.usa.gov/government-works",
    "organization-long": "North Carolina Institute for Climate Studies (CICS-NC), National Climate Assessment (NCA) Technical Support Unit (TSU)",
    "learn_more_link": "https://www.cicsnc.org/about/tsu/nca3-data",
  },
  "name": "U.S. Projected Change in Number of Days over 90º - Higher Emissions (2041-2070)",
  "source": "CICS-NC",
  "description": "...",
  "language": "en",
  "citation": "Melillo, Jerry M., Terese (T.C.) Richmond, and Gary W. Yohe, Eds., 2014: Climate Change Impacts in the United States: The Third National Climate Assessment. U.S. Global Change Research Program, 841 pp. doi:10.7930/J0Z31WJ2.",
  "application": "prep"
}
```

### 4. _[Optional]_ Check differences in new metadata.

```
./diff_metadata.sh
```

Note: Since the patch command only updates lines that are included in the json payload, lines that `diff` shows as being removed will not actually be removed unless overwritten.

### 5. Update and/or post new metadata using your API key.

```
./update_metadata.sh [RW_API_KEY] --post | bash
./update_metadata.sh [RW_API_KEY] | bash
```

The script will read all files from the `jsons` directory and attempt to update the corresponding dataset metadata. Using the `--post` option will create new metadata objects for the datasets that do not currently have metadata, otherwise only existing metadata will be updated.

### Revert edits

The update and diff scripts will save a copy of the current metadata from the API. Overwrite the `jsons` folder with the `api_jsons` folder and run the update script again to revert to this version.

```
mv -f api_jsons jsons
./update_metadata.sh [RW_API_KEY] | bash
```
