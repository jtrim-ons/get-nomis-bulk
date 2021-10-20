import csv
import sys

def make_rules(args):
    rules = []
    for arg in args:
        name, columns = arg.split('=')
        columns = [int(n) - 1 for n in columns.split('+')]
        rules.append((name, columns))
    return rules

def make_columns(rownum, row, rules):
    if rownum == 0:
        result = ['code']
        result.extend([name for name, _ in rules])
    else:
        result = [row[0]]
        for name, columns in rules:
            result.append(sum(int(row[c]) for c in columns))
    return result

rules = make_rules(sys.argv[1:])

csvwriter = csv.writer(sys.stdout)
csvreader = csv.reader(sys.stdin)

for i, row in enumerate(csvreader):
    csvwriter.writerow(make_columns(i, row, rules))

