import sys
import os
import subprocess


project_path = sys.path[0]
project_name = os.path.basename(project_path)


#
# Generate .sof file
#

subprocess.run(["quartus_map", project_name], check=True)
subprocess.run(["quartus_fit", project_name], check=True)
subprocess.run(["quartus_asm", project_name], check=True)


#
# Generate .cdf file
#

cdf_contents = f"""/* Quartus II 64-Bit Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition */
JedecChain;
  FileRevision(JESD32A);
  DefaultMfr(6E);

  P ActionCode(Cfg)
    Device PartName(EP2C5T144) Path("{project_path}/") File("{project_name}.sof") MfrSpec(OpMask(1));

ChainEnd;

AlteraBegin;
  ChainType(JTAG);
AlteraEnd;
"""

cdf_path = f'{project_name}.cdf'

with open(cdf_path, 'w') as ofile:
    ofile.write(cdf_contents)

#
# Generate .svf file
#
subprocess.run([
    'quartus_cpf',
    '-c',
    '-q', '25MHz', '-g', '3.3', '-n', 'p',
    cdf_path,
    f'{project_name}.svf'
    ], check=True)

#
# Cleanup
#

