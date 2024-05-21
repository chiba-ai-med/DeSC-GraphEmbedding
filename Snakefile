from snakemake.utils import min_version

#################################
# Setting
#################################
# Minimum Version of Snakemake
min_version("8.10.8")

SIZES = ['small', 'medium', 'large']
DEEPWALK_DIMS = ['2', '16', '32', '64', '128']
METHODS = ['lem', 'lev', 'evd',
	'smtf', 'smtf_kl', 'smtf_is',
	'lem_umap', 'lev_umap', 'evd_umap',
	'smtf_umap', 'smtf_kl_umap', 'smtf_is_umap']

container: 'docker://koki/desc_graphembedding:20240516'

rule all:
	input:
		expand('plot/{size}/density.png', size=SIZES),
		expand('plot/{size}/degree.png', size=SIZES),
		expand('plot/{size}/diagonal.png', size=SIZES),
		expand('plot/{size}/degree_vs_diagonal.png', size=SIZES),
		expand('plot/{size}/degree_diagonal_high.png', size=SIZES),
		expand('plot/{size}/degree_diagonal_low.png', size=SIZES),
		expand('plot/{size}/power_law.png', size=SIZES),
		expand('plot/{size}/heatmap_clustering.png', size=SIZES), # Heavy
		expand('plot/{size}/heatmap_degree.png', size=SIZES),
		expand('plot/{size}/igraph.png', size=SIZES),
		expand('plot/{size}/igraph_degree.png', size=SIZES),
		expand('plot/{size}/{method}_recerror.png',
			size=SIZES, method=METHODS),
		expand('plot/{size}/{method}_relchange.png',
			size=SIZES, method=METHODS),
		expand('plot/{size}/pair/{method}/pair.png',
			size=SIZES, method=METHODS),
		expand('plot/{size}/pair/{method}/pair_degree.png',
			size=SIZES, method=METHODS),
		expand('plot/{size}/{method}.png',
			method=METHODS, size=SIZES),
		expand('plot/{size}/{method}_degree.png',
			method=METHODS, size=SIZES),
		'plot/small/deepwalk.png',
		'plot/small/deepwalk_degree.png',
		expand('plot/small/deepwalk_umap/{dim}.png',
			dim=DEEPWALK_DIMS),
		expand('plot/small/deepwalk_umap/{dim}_degree.png',
			dim=DEEPWALK_DIMS),
		expand('plot/small/pair_islabel/{method}/pair.png',
			method=METHODS),
		expand('plot/small/pair_islabel/{method}/pair_degree.png',
			method=METHODS),
		'plot/legend.png'

rule filter_adjmatrix:
	input:
		'data/{size}/adjmatrix.txt'
	output:
		'data/{size}/adjmatrix_filtered.txt'
	resources:
		mem_gb=500
	benchmark:
		'benchmarks/filter_adjmatrix_{size}.txt'
	log:
		'logs/filter_adjmatrix_{size}.log'
	shell:
		'src/filter_adjmatrix.sh {input} {output} >& {log}'

rule plot_heatmap_degree:
	input:
		'data/{size}/adjmatrix_filtered.txt',
		'data/{size}/degree.txt'
	output:
		'plot/{size}/heatmap_degree.png'
	resources:
		mem_gb=500
	benchmark:
		'benchmarks/plot_heatmap_degree_{size}.txt'
	log:
		'logs/plot_heatmap_degree_{size}.log'
	shell:
		'src/plot_heatmap_degree.sh {input} {output} >& {log}'

rule plot_heatmap_clustering:
	input:
		'data/{size}/adjmatrix_filtered.txt'
	output:
		'plot/{size}/heatmap_clustering.png'
	resources:
		mem_gb=500
	benchmark:
		'benchmarks/plot_heatmap_clustering_{size}.txt'
	log:
		'logs/plot_heatmap_clustering_{size}.log'
	shell:
		'src/plot_heatmap_clustering.sh {input} {output} >& {log}'

rule plot_density:
	input:
		'data/{size}/adjmatrix_filtered.txt'
	output:
		'plot/{size}/density.png'
	resources:
		mem_gb=500
	benchmark:
		'benchmarks/plot_density_{size}.txt'
	log:
		'logs/plot_density_{size}.log'
	shell:
		'src/plot_density.sh {input} {output} >& {log}'

rule degree:
	input:
		'data/{size}/adjmatrix_filtered.txt'
	output:
		'data/{size}/degree.txt'
	resources:
		mem_gb=500
	benchmark:
		'benchmarks/degree_{size}.txt'
	log:
		'logs/degree_{size}.log'
	shell:
		'src/degree.sh {input} {output} >& {log}'

rule plot_degree:
	input:
		'data/{size}/adjmatrix_filtered.txt',
		'data/{size}/degree.txt'
	output:
		'plot/{size}/degree.png'
	resources:
		mem_gb=500
	benchmark:
		'benchmarks/plot_degree_{size}.txt'
	log:
		'logs/plot_degree_{size}.log'
	shell:
		'src/plot_degree.sh {input} {output} >& {log}'

rule diagonal:
	input:
		'data/{size}/adjmatrix_filtered.txt'
	output:
		'data/{size}/diagonal.txt'
	resources:
		mem_gb=500
	benchmark:
		'benchmarks/diagonal_{size}.txt'
	log:
		'logs/diagonal_{size}.log'
	shell:
		'src/diagonal.sh {input} {output} >& {log}'

rule plot_diagonal:
	input:
		'data/{size}/adjmatrix_filtered.txt',
		'data/{size}/diagonal.txt'
	output:
		'plot/{size}/diagonal.png'
	resources:
		mem_gb=500
	benchmark:
		'benchmarks/plot_diagonal_{size}.txt'
	log:
		'logs/plot_diagonal_{size}.log'
	shell:
		'src/plot_diagonal.sh {input} {output} >& {log}'

rule degree_diagonal:
	input:
		'data/{size}/degree.txt',
		'data/{size}/diagonal.txt'
	output:
		'data/{size}/degree_diagonal.txt'
	resources:
		mem_gb=500
	benchmark:
		'benchmarks/degree_diagonal_{size}.txt'
	log:
		'logs/degree_diagonal_{size}.log'
	shell:
		'src/degree_diagonal.sh {input} {output} >& {log}'

rule plot_degree_diagonal:
	input:
		'data/{size}/degree.txt',
		'data/{size}/diagonal.txt',
		'data/{size}/igraph.RData'
	output:
		'plot/{size}/degree_vs_diagonal.png',
		'plot/{size}/degree_diagonal_high.png',
		'plot/{size}/degree_diagonal_low.png'
	resources:
		mem_gb=500
	benchmark:
		'benchmarks/plot_degree_diagonal_{size}.txt'
	log:
		'logs/plot_degree_diagonal_{size}.log'
	shell:
		'src/plot_degree_diagonal.sh {input} {output} >& {log}'

rule plot_power_law:
	input:
		'data/{size}/degree.txt'
	output:
		'plot/{size}/power_law.png'
	resources:
		mem_gb=500
	benchmark:
		'benchmarks/plot_power_law_{size}.txt'
	log:
		'logs/plot_power_law_{size}.log'
	shell:
		'src/plot_power_law.sh {input} {output} >& {log}'

rule igraph:
	input:
		'data/{size}/adjmatrix_filtered.txt'
	output:
		'data/{size}/igraph.RData'
	resources:
		mem_gb=500
	benchmark:
		'benchmarks/igraph_{size}.txt'
	log:
		'logs/igraph_{size}.log'
	shell:
		'src/igraph.sh {input} {output} >& {log}'

rule plot_igraph:
	input:
		'data/{size}/igraph.RData',
		'data/{size}/degree.txt'
	output:
		'plot/{size}/igraph.png',
		'plot/{size}/igraph_degree.png'
	resources:
		mem_gb=500
	benchmark:
		'benchmarks/plot_igraph_{size}.txt'
	log:
		'logs/plot_igraph_{size}.log'
	shell:
		'src/plot_igraph.sh {input} {output} >& {log}'

rule dimred:
	input:
		'data/{size}/adjmatrix_filtered.txt'
	output:
		'output/{size}/{method}.RData',
		'output/{size}/{method}.txt'
	resources:
		mem_gb=500
	benchmark:
		'benchmarks/dimred_{size}_{method}.txt'
	log:
		'logs/dimred_{size}_{method}.log'
	shell:
		'src/{wildcards.method}.sh {input} {output} >& {log}'

rule plot_dimred:
	input:
		'output/{size}/{method}.txt',
		'data/{size}/igraph.RData',
		'data/{size}/degree.txt'
	output:
		'plot/{size}/{method}.png',
		'plot/{size}/{method}_degree.png'
	resources:
		mem_gb=500
	wildcard_constraints:
		method='|'.join([re.escape(x) for x in METHODS])
	benchmark:
		'benchmarks/plot_dimred_{size}_{method}.txt'
	log:
		'logs/plot_dimred_{size}_{method}.log'
	shell:
		'src/plot_dimred.sh {input} {output} >& {log}'

rule plot_pair_dimred:
	input:
		'output/{size}/{method}.RData',
		'data/{size}/igraph.RData',
		'data/{size}/degree.txt'
	output:
		'plot/{size}/pair/{method}/pair.png',
		'plot/{size}/pair/{method}/pair_degree.png'
	resources:
		mem_gb=500
	wildcard_constraints:
		method='|'.join([re.escape(x) for x in METHODS])
	benchmark:
		'benchmarks/plot_pair_dimred_{size}_{method}.txt'
	log:
		'logs/plot_pair_dimred_{size}_{method}.log'
	shell:
		'src/plot_pair_dimred.sh {input} {output} >& {log}'

rule plot_dimred_recerror:
	input:
		'output/{size}/{method}.RData',
	output:
		'plot/{size}/{method}_recerror.png'
	resources:
		mem_gb=500
	benchmark:
		'benchmarks/plot_dimred_recerror_{size}_{method}.txt'
	log:
		'logs/plot_dimred_recerror_{size}_{method}.log'
	shell:
		'src/plot_dimred_recerror.sh {input} {output} >& {log}'

rule plot_dimred_relchange:
	input:
		'output/{size}/{method}.RData',
	output:
		'plot/{size}/{method}_relchange.png'
	resources:
		mem_gb=500
	benchmark:
		'benchmarks/plot_dimred_relchange_{size}_{method}.txt'
	log:
		'logs/plot_dimred_relchange_{size}_{method}.log'
	shell:
		'src/plot_dimred_relchange.sh {input} {output} >& {log}'

rule adj2edgelist:
	input:
		'data/small/adjmatrix.txt'
	output:
		'data/small/edgelist.txt'
	resources:
		mem_gb=500
	benchmark:
		'benchmarks/adj2edgelist.txt'
	log:
		'logs/adj2edgelist.log'
	shell:
		'src/adj2edgelist.sh {input} {output} >& {log}'

rule deepwalk:
	input:
		'data/small/edgelist.txt'
	output:
		'output/small/deepwalk/{dim}.txt'
	resources:
		mem_gb=500
	benchmark:
		'benchmarks/deepwalk_{dim}.txt'
	log:
		'logs/deepwalk_{dim}.log'
	shell:
		'src/deepwalk.sh {wildcards.dim} {input} {output} >& {log}'

rule deepwalk_umap:
	input:
		'output/small/deepwalk/{dim}.txt'
	output:
		'output/small/deepwalk_umap/{dim}.txt'
	resources:
		mem_gb=500
	benchmark:
		'benchmarks/deepwalk_umap_{dim}.txt'
	log:
		'logs/deepwalk_umap_{dim}.log'
	shell:
		'src/umap.sh {input} {output} >& {log}'

rule plot_deepwalk:
	input:
		'output/small/deepwalk/2.txt',
		'data/small/igraph.RData',
		'data/small/degree.txt'
	output:
		'plot/small/deepwalk.png',
		'plot/small/deepwalk_degree.png'
	resources:
		mem_gb=500
	benchmark:
		'benchmarks/plot_deepwalk.txt'
	log:
		'logs/plot_deepwalk.log'
	shell:
		'src/plot_deepwalk.sh {input} {output} >& {log}'

rule plot_deepwalk_umap:
	input:
		'output/small/deepwalk_umap/{dim}.txt',
		'data/small/igraph.RData',
		'data/small/degree.txt'
	output:
		'plot/small/deepwalk_umap/{dim}.png',
		'plot/small/deepwalk_umap/{dim}_degree.png'
	resources:
		mem_gb=500
	benchmark:
		'benchmarks/plot_deepwalk_umap_{dim}.txt'
	log:
		'logs/plot_deepwalk_umap_{dim}.log'
	shell:
		'src/plot_dimred.sh {input} {output} >& {log}'

rule islabel:
	input:
		'output/small/smtf_is_umap.RData',
		'output/small/smtf_is_umap.txt'
	output:
		'output/small/islabel.txt'
	resources:
		mem_gb=500
	benchmark:
		'benchmarks/islabel.txt'
	log:
		'logs/islabel.log'
	shell:
		'src/islabel.sh {input} {output} >& {log}'

rule plot_islabel_pair_dimred:
	input:
		'output/small/{method}.RData',
		'data/small/igraph.RData',
		'output/small/islabel.txt'
	output:
		'plot/small/pair_islabel/{method}/pair.png',
		'plot/small/pair_islabel/{method}/pair_degree.png'
	resources:
		mem_gb=500
	wildcard_constraints:
		method='|'.join([re.escape(x) for x in METHODS])
	benchmark:
		'benchmarks/plot_islabel_pair_dimred_small_{method}.txt'
	log:
		'logs/plot_islabel_pair_dimred_small_{method}.log'
	shell:
		'src/plot_pair_dimred.sh {input} {output} >& {log}'

rule plot_legend:
	output:
		'plot/legend.png'
	resources:
		mem_gb=500
	benchmark:
		'benchmarks/plot_legend.txt'
	log:
		'logs/plot_legend.log'
	shell:
		'src/plot_legend.sh {output} >& {log}'
