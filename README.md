# Metadata updates

### Scripts:

Requires JQ https://stedolan.github.io/jq/download/

`fetch_from_api.sh` -> fetches current metadata attributes from API to `./jsons`. Overwrites any current content.

`fetch_from_google_docs.sh` -> fetches metadata attributes from Google docs to `./jsons`. Overwrites any current content. (Requires csv2json https://www.npmjs.com/package/csv2json)

`to_csv.sh` -> dumps metadata in `./jsons` to `metadata.csv`.

`checkissues.sh` -> checks for missing metadata attributes in `./jsons`.

`generate_patch_commands.sh <auth>` -> generates curl commands for patching metadata in `./json`. Pipe to bash to run patch commands `./generate_patch_commands.sh "Bearer TOKEN" | bash`.
