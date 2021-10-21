import csv
import sys

def make_rules(args):
    # A special '*' rule is the index of a total column, for checking
    rules = []
    for arg in args:
        name, columns = arg.split('=')
        columns = [int(n) - 1 for n in columns.split('+')]
        rules.append((name, columns))
    return rules

def make_columns(rownum, row, rules):
    if rownum == 0:
        result = ['code']
        columns_seen = set()
        for name, columns in rules:
            long_name = name
            if name == "*":
                long_name = "* (column used for checking total)"
            sys.stderr.write('{}:\n'.format(long_name))
            for col in columns:
                columns_seen.add(col)
                sys.stderr.write('    ({}) {}\n'.format(col + 1, row[col]))
        sys.stderr.write('Unused columns:\n')
        for i, col_name in enumerate(row):
            if i == 0: continue
            if i not in columns_seen:
                sys.stderr.write('    ({}) {}\n'.format(i + 1, col_name))

        result.extend([name for name, _ in rules if name != "*"])
    else:
        expected_total = None
        result = [row[0]]
        total = 0
        for name, columns in rules:
            val = sum(int(row[c]) for c in columns)
            if name == "*":
                expected_total = val
            else:
                total += val
                result.append(val)
        if expected_total is not None:
            assert expected_total == total
    return result

rules = make_rules(sys.argv[1:])

csvwriter = csv.writer(sys.stdout)
csvreader = csv.reader(sys.stdin)

for i, row in enumerate(csvreader):
    csvwriter.writerow(make_columns(i, row, rules))

