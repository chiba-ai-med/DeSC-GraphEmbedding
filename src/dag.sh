# DAG graph
mkdir -p plot
snakemake --rulegraph | dot -Tpng > plot/dag.png
