import os
import sys

from subprocess import Popen, PIPE


def exec_command(command, print_result=False):
    p = Popen(command, shell=True, stderr=PIPE, stdout=PIPE)
    result = p.communicate()
    if print_result:
        for item in result:
            print item


def main():
    exec_command('cp {} reference.fasta'.format(sys.argv[1]))
    for filename in ['make_reference.sh', 'sra2bai.sh', 'bai2vcf.sh', 'vcf2snpeff.sh', 'pilon-1.21.jar', 'reference.fasta']:
        exec_command('cp /home/vitux/galaxy/galaxy/tools/mytool/{} .'.format(filename))
    exec_command('./make_reference.sh')
    with open('IDfile.txt', 'w') as idf:
        idf.write('\n'.join(sys.argv[2].split()))
    exec_command('./sra2bai.sh')
    exec_command('bash bai2vcf.sh')
    exec_command('bash vcf2snpeff.sh')
    result_path = '/etc/galaxy/SampleGenome_merge_{}.var.ann.vcf'.format(int(time.time()))
    exec_command('cp SampleGenome_merge.var.ann.vcf {}'.format(result_path))
    with open(sys.argv[3], 'w') as out_file:
        out_file.write('To process file continue to http://localhost:5000/process_file/{}'.format(result_path.split('/')[-1]))

