from terrasnek.api import TFC
from jproperties import Properties
import csv
import string

configs = Properties()

substitutions = None

with open('configuration.properties', 'rb') as config_file:
    configs.load(config_file)

    TFC_TOKEN = configs.get("TFC_TOKEN").data
    TFC_URL = configs.get("TFC_URL").data
    TFC_ORG = configs.get("TFC_ORG").data
    VARSET_NAME = configs.get("VARSET_NAME").data
    substitutions = {k: v.data for k, v in configs.items()}


if __name__ == "__main__":
    api = TFC(TFC_TOKEN, url=TFC_URL, verify=True)
    api.set_org(TFC_ORG)

    var_set = None
    var_sets = api.var_sets.list_for_org().get("data")
    for v in var_sets:
        if v['attributes']['name'] == VARSET_NAME:
            var_set = v

    if var_set is None:
        exit("Varset not found by name: " + VARSET_NAME)

    continue_import = input("Importing data into variable set: " + VARSET_NAME + ". Continue? (yes/[no]): ")

    if continue_import != "yes":
        exit("Aborted")

    with open('./variables-data.csv', newline='', encoding='utf-8-sig') as csvFile:
        csvReader = csv.reader(csvFile, delimiter=',', quotechar='"')
        next(csvReader)  # skip the header row
        for row in csvReader:
            # print(', '.join(row))

            create_variable_payload = {
                "data": {
                    "type": "vars",
                    "attributes": {
                        "key": '{}'.format(row[0]),
                        "value": '{}'.format(string.Template(row[4]).safe_substitute(substitutions).replace('\'', '\\\'')),
                        "description": '{}'.format(row[1].replace('\'', '\\\'')),
                        "sensitive": (row[2] == "yes") if "true" else "false",
                        "category": "terraform",
                        "hcl": (row[3] == "yes") if "true" else "false"
                    }
                }
            }
            varSetId = var_set.get("id")
            print(create_variable_payload)
            api.var_sets.add_var_to_varset(varSetId, create_variable_payload)
