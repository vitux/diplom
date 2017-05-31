import json
import os
import time

from flask import Flask, render_template, send_from_directory

app = Flask(__name__)

path = r'/place/vcf_dir'
resistance_path = r'/place/resistance.json'


def get_med_resistance():
    res = json.load(open(resistance_path))
    result = {}
    for k, v in res.items():
        for v_i in v:
            result[(v_i[0], v_i[1][0], v_i[1][1])] = k

    return result


MED_RESISTANCE = get_med_resistance()


def calc_resistance(inp_data):
    result = []
    for item in inp_data[1:]:
        curr = tuple([int(item[1])] + item[3: 5])
        if curr in MED_RESISTANCE:
            result.append(MED_RESISTANCE[curr])

    return result


@app.route('/')
def hello_world():
    all_files = os.listdir(path)
    return render_template('index.html', files=all_files)


@app.route('/process_file/<filename>')
def process_file(filename):
    data = open('{}/{}'.format(path, filename)).readlines()
    data = map(lambda x: x.split('\t'), data)[42:]
    resistance_items = ', '.join(calc_resistance(data))
    return render_template('any_data.html', data=data, resistance_items=resistance_items)


@app.route('/download_file/<filename>')
def download_file(filename):
    return send_from_directory(path, filename)


if __name__ == '__main__':
    app.run(host='0.0.0.0')
