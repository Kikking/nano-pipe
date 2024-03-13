# -*- coding: utf-8 -*-
"""
Created on Thu Feb 29 10:48:24 2024

@author: User
"""

import gffutils

filename = "D:/refData/filtered_fin.gtf"
oldfile = "D:/refData/lrgasp_gencode_v38_sirvs.gtf"
db = gffutils.create_db(filename,
"D:/refData/filtered_fin.db",
keep_order=True,
force=  True, 
disable_infer_genes=False, disable_infer_transcripts=False,
sort_attribute_values=True,
#id_spec={"gene": "gene_id", " transcript": " transcript_id", "exon":"exon_number"},
merge_strategy = "error")



list(db.all_features())
for i in db.features_of_type("exon"):
    print(i) 
    
for i in db.children("ENSG00000142611"):
    print(i)