#!/usr/bin/env python
import csv
import argparse

def load_t2g(path):
    ret = {}
    with open(path) as t2g:
        for line in t2g:
            values = line.split()
            ret[values[1]] = values[2]
    return ret

def matched_features(features_path, t2g):
    ret = []
    with open(features_path, 'r') as features_file:
        for line in features_file.read().splitlines():
            ret.append([line, t2g[line], 'Gene Expression'])
    return ret

def save_features(features):
    with open('features.tsv', 'w') as features_file:
        writer = csv.writer(features_file, delimiter = '\t')
        writer.writerows(features)

def transpose_matrix(path):
    with open(path, 'r') as matrix, open('matrix.mtx', 'w') as transposed:
        for line in matrix:
            if line[0] == '%':
                transposed.write(line)
                continue

            values = line.split()
            transposed.write("{} {} {}\n".format(values[1], values[0], values[2]))

def rename(path, new_name):
    
    with open(path, 'rb') as original:
        with open(new_name, 'wb') as new_path:
            new_path.write(original.read())




if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Preprocess counts')
    parser.add_argument('--t2g', type=str, help='Path to t2g file', required=True)
    parser.add_argument('--matrix', type=str, help='Path to matrix file', required=True)
    parser.add_argument('--features', type=str, help='Path to matrix file', required=True)
    parser.add_argument('--barcodes', type=str, help='Path to matrix file', required=True)

    args = parser.parse_args()  
    t2g = load_t2g(args.t2g)
    features = matched_features(args.features, t2g)
    save_features(features)
    transpose_matrix(args.matrix)
    rename(args.barcodes, 'barcodes.tsv')
