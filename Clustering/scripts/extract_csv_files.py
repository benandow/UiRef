import csv
import sys

def createCSVDict(filename):
    val_dict = []
    with open(filename, 'rb') as csvfile:
        for row in csv.reader(csvfile, delimiter=','):
            for r in row[1:]:
                r = r.strip()
                if len(r) > 0 and r not in val_dict:
                    val_dict.append(r)
    return val_dict

def genCSV(filename, val_dict):
    res = []
    with open(filename, 'rb') as csvfile:
        csv_data = csv.reader(csvfile, delimiter=',')
        for row in csv_data:
            row_vals = [ r.strip() for r in row[1:] if len(r) > 0]
            print row[0]
            vals = [row[0]]
            for v in val_dict:
                vals.append(v if v in row_vals else 'N_%s' % (v,))
            res.append(vals)
    return res

def writeCSV(matrix, output_filename):
    with open(output_filename, 'wb') as out_file:
        for m in matrix:
            writer = csv.writer(out_file, delimiter=',', quotechar='|', quoting=csv.QUOTE_MINIMAL)
            writer.writerow(m)

if __name__ == "__main__":
    val_dict = createCSVDict(sys.argv[1])    
    matrix = genCSV(sys.argv[1], val_dict)
    writeCSV(matrix, 'FV_%s' % (sys.argv[1],))

