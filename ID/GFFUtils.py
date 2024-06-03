# -*- coding: utf-8 -*-
"""
Created on Thu Feb 29 10:48:24 2024

@author: User
"""

import gffutils

filename = "E:/refData/current/gencode45_novel.gtf"
oldfile = "D:/refData/lrgasp_gencode_v38_sirvs.gtf"
db = gffutils.create_db(filename,
"E:/refData/current/gencode45_novel.db",
keep_order=True,
force=  True, 
disable_infer_genes=True, disable_infer_transcripts=True,
sort_attribute_values=True,
#id_spec={"gene": "gene_id", " transcript": " transcript_id", "exon":"exon_number"},
merge_strategy = "error")



list(db.all_features())
for i in db.features_of_type("exon"):
    print(i) 
    
for i in db.children("ENSG00000142611"):
    print(i)
    

def gene_to_gtf(feature):
    fields = [
        feature.seqid,
        feature.source,
        feature.featuretype,
        feature.start,
        feature.end,
        feature.score,
        feature.strand,
        feature.frame
    ]
    # Convert attributes to GTF format
    attributes = ' '.join(f'{key} "{value}";' for key, value in feature.attributes.items())
    # Return the GTF line
    return '\t'.join(map(str, fields)) + '\t' + attributes + '\n'

def gffutils_db_to_gtf(db_file, output_file):
    # Connect to the GFFutils database
    db = gffutils.FeatureDB(db_file)

    # Open the output GTF file for writing
    with open(output_file, 'w') as out_gtf:
        # Iterate over genes
        for gene in db.features_of_type('gene'):
            # Write gene feature
            out_gtf.write(gene_to_gtf(gene))
            # Iterate over transcripts of the gene
            for transcript in db.children(gene, featuretype='transcript', order_by='start'):
                # Write transcript feature
                out_gtf.write(gene_to_gtf(transcript))
                # Iterate over exons of the transcript
                for exon in db.children(transcript, featuretype='exon', order_by='start'):
                    # Write exon feature
                    out_gtf.write(gene_to_gtf(exon))



# Example usage:
gffutils_db_to_gtf('E:/refData/filtered_fin.db', 'E:/refData/output_test1.gtf')