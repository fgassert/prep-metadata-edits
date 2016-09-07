import json
import sys

reqfields = [
      "citation",
      "dataDownload",
      "description",
      "license",
      "organization",
      "service",
      "short-description",
      "subtitle",
      "source",
]

def check_metadata(fjson):
    blob = json.load(open(fjson))
    title = ''
    issues = []

    try:
        if isinstance(blob, dict) and blob.has_key('attributes'):
            attrs = blob['attributes']
            if attrs.has_key('title'):
                title = attrs['title']
            for key in reqfields:
                if not attrs.has_key(key) or attrs[key] == '' or attrs[key] is None:
                    issues.append("Missing field: " + key)
                else:
                    v = attrs[key]
                    if key == 'dataDownload' and (len(v)<10 or v[:4] != "http"):
                        issues.append("Invalid dataDownload url: {}".format(v))
        else:
            issues.append('Missing or malformed metadata attributes')
    except Exception as e:
        issues.append('Missing or malformed metadata attributes')
        issues.append(str(e))

    if len(issues) > 0:
        print ''
        print fjson
        print title
        print '\n'.join(issues)

if __name__ == "__main__":
    if len(sys.argv) > 1:
        check_metadata(sys.argv[1])
    else:
        print "usage: python {} <metadata-attributes.json>".format(sys.argv[0])
