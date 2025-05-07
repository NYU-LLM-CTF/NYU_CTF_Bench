import json
import pandas as pd
import argparse

parser = argparse.ArgumentParser("Plot results table of MITRE mapping")
parser.add_argument("--mapping", help="Mapping file", default="test_mapping.json")
parser.add_argument("--solved", help="JSON summary of solved challenges", nargs="+", required=True)
args = parser.parse_args()

with open(args.mapping) as f:
    mapping = json.load(f)
# with open(args.solved) as f:
#     solved = json.load(f)

counts_per_technique = {}
# category_per_technique = {}
for chal, techs in mapping["mapping"].items():
    for tech in techs:
        if tech not in counts_per_technique:
            counts_per_technique[tech] = 0
            # category_per_technique[tech] = set()
        counts_per_technique[tech] += 1
        # cat = chal.split("-")[1]
        # category_per_technique[tech].add(cat)


table = pd.DataFrame(counts_per_technique.items(), columns=["Technique", "Count"])
table.insert(1, "Name", table["Technique"].map(mapping["techniques"]))
table.sort_values(["Count"], ascending=False, inplace=True)
# table["Count Color"] = (table["Count"] * 50 / table["Count"].max()).astype(int)

# modelmax = 0
for summ in args.solved:
    table[summ] = 0
    with open(summ) as f:
        res = json.load(f)
        res = res["results"]
    solved = (c for c, s in res.items() if s)
    for chal in solved:
        for t in mapping["mapping"][chal]:
            table.loc[table["Technique"] == t, summ] += 1
    # modelmax = max(modelmax, table[summ].max())
table.set_index("Technique", inplace=True)
table.loc["Total"] = table.sum()
table.loc["Total", "Name"] = ""
print(table.to_string())

# Assign color
# for model, _ in models:
#     table[model + " Color"] = (table[model] * 50 / modelmax).astype(int)

# print("Num challenges tagged:", sum(1 for c in challenge_labels if len(challenge_labels[c]) > 0))
