import tabulate
from nyuctf.dataset import CTFDataset

ds = CTFDataset("test_dataset.json")
categories = ["crypto", "forensics", "pwn", "rev", "misc", "web"]
years = list(range(2017, 2024))
headers = ["year"] + categories + categories + ["total"]

table = []

for year in years:
    row = []
    for ev in ["CSAW-Quals", "CSAW-Finals"]:
            for cat in categories:
                    row.append(len(list(ds.filter(year=str(year),category=cat,event=ev))))
    row.append(sum(row))
    row.insert(0, year)
    table.append(row[:])

totals = list(map(sum, zip(*table)))
totals[0] = "Total"
table.append(totals[:])
print(tabulate.tabulate(table, tablefmt="latex", headers=headers))
