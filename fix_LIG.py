## covert file pdbqt from docking_vina to .mol 2 for input CHARMM-GUI 

from pymol import cmd 
import os 
## how run it ? pymol -cq fix_LIG.py 
ligand = "siact_2_L19__input10__variant4_out_ligand_1.pdbqt" ## change 
receptor = "1j3u_pro.pdbqt" ## change 

cmd.load(ligand)
cmd.load(receptor)
cmd.select('het')
cmd.alter('sele', 'chain=\"L\"') # \ is for escape 
cmd.h_add('chain L')
cmd.delete('sele')

#; Generate inputs to Charmm-gui

lig_name = "lig.mol2"
prot_name = "complex.pdb"

cmd.save(lig_name, selection="chain L")
cmd.save(prot_name, selection="all")

## fix name into files 
os.system('sed \'s/UNL/LIG/g\' complex.pdb > complex_L19_variant2.pdb') #change
os.system('sed \'s/UNL1/LIG/g\' lig.mol2 > tmp.mol2')
os.system('sed \'s/UNL/LIG/g\' tmp.mol2 > tmp1.mol2')
os.system('sed \'3 s/CH.*/LIG/g\' tmp1.mol2 > L19_variant2.mol2') #change
os.system('rm tmp*.mol2')