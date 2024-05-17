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
		expand('plot/{size}/degree.png', size=SIZES),
		expand('plot/{size}/power_law.png', size=SIZES),
		expand('plot/{size}/heatmap.png', size=SIZES),
		expand('plot/{size}/heatmap_clustering.png', size=SIZES),
		expand('plot/{size}/heatmap_degree.png', size=SIZES),
		expand('plot/{size}/density.png', size=SIZES),
		expand('plot/{size}/igraph.png', size=SIZES),
		expand('plot/{size}/igraph_degree.png', size=SIZES),
		expand('plot/{size}/{method}_pair.png',
			size=SIZES, method=METHODS),
		expand('plot/{size}/{method}_pair_degree.png',
			method=METHODS, size=SIZES),
		expand('plot/{size}/{method}.png',
			method=METHODS, size=SIZES),
		expand('plot/{size}/{method}_degree.png',
			method=METHODS, size=SIZES),
		'plot/small/deepwalk.png',
		'plot/small/deepwalk_degree.png',
		expand('plot/small/deepwalk_umap/{dim}.png',
			dim=DEEPWALK_DIMS),
		expand('plot/small/deepwalk_umap/{dim}_degree.png',
			dim=DEEPWALK_DIMS)

rule plot_heatmap:
	input:
		'data/{size}/adjmatrix.txt'
	output:
		'plot/{size}/heatmap.png'
	benchmark:
		'benchmarks/plot_heatmap_{size}.txt'
	log:
		'logs/plot_heatmap_{size}.log'
	shell:
		'src/plot_heatmap.sh {input} {output} >& {log}'

rule plot_heatmap_degree:
	input:
		'data/{size}/adjmatrix.txt',
		'data/{size}/degree.txt'
	output:
		'plot/{size}/heatmap_degree.png'
	benchmark:
		'benchmarks/plot_heatmap_degree_{size}.txt'
	log:
		'logs/plot_heatmap_degree_{size}.log'
	shell:
		'src/plot_heatmap_degree.sh {input} {output} >& {log}'

rule plot_heatmap_clustering:
	input:
		'data/{size}/adjmatrix.txt'
	output:
		'plot/{size}/heatmap_clustering.png'
	benchmark:
		'benchmarks/plot_heatmap_clustering_{size}.txt'
	log:
		'logs/plot_heatmap_clustering_{size}.log'
	shell:
		'src/plot_heatmap_clustering.sh {input} {output} >& {log}'

rule plot_density:
	input:
		'data/{size}/adjmatrix.txt'
	output:
		'plot/{size}/density.png'
	benchmark:
		'benchmarks/plot_density_{size}.txt'
	log:
		'logs/plot_density_{size}.log'
	shell:
		'src/plot_density.sh {input} {output} >& {log}'

rule degree:
	input:
		'data/{size}/adjmatrix.txt'
	output:
		'data/{size}/degree.txt'
	benchmark:
		'benchmarks/degree_{size}.txt'
	log:
		'logs/degree_{size}.log'
	shell:
		'src/degree.sh {input} {output} >& {log}'

rule plot_degree:
	input:
		'data/{size}/adjmatrix.txt',
		'data/{size}/degree.txt'
	output:
		'plot/{size}/degree.png'
	benchmark:
		'benchmarks/plot_degree_{size}.txt'
	log:
		'logs/plot_degree_{size}.log'
	shell:
		'src/plot_degree.sh {input} {output} >& {log}'

rule plot_power_law:
	input:
		'data/{size}/degree.txt'
	output:
		'plot/{size}/power_law.png'
	benchmark:
		'benchmarks/plot_power_law_{size}.txt'
	log:
		'logs/plot_power_law_{size}.log'
	shell:
		'src/plot_power_law.sh {input} {output} >& {log}'

rule igraph:
	input:
		'data/{size}/adjmatrix.txt'
	output:
		'data/{size}/igraph.RData'
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
	benchmark:
		'benchmarks/plot_igraph_{size}.txt'
	log:
		'logs/plot_igraph_{size}.log'
	shell:
		'src/plot_igraph.sh {input} {output} >& {log}'

rule dimred:
	input:
		'data/{size}/adjmatrix.txt'
	output:
		'output/{size}/{method}.RData',
		'output/{size}/{method}.txt'
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
		'plot/{size}/{method}_pair.png',
		'plot/{size}/{method}_pair_degree.png'
	wildcard_constraints:
		method='|'.join([re.escape(x) for x in METHODS])
	benchmark:
		'benchmarks/plot_pair_dimred_{size}_{method}.txt'
	log:
		'logs/plot_pair_dimred_{size}_{method}.log'
	shell:
		'src/plot_pair_dimred.sh {input} {output} >& {log}'

rule adj2edgelist:
	input:
		'data/small/adjmatrix.txt'
	output:
		'data/small/edgelist.txt'
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
	benchmark:
		'benchmarks/plot_deepwalk_umap_{dim}.txt'
	log:
		'logs/plot_deepwalk_umap_{dim}.log'
	shell:
		'src/plot_dimred.sh {input} {output} >& {log}'
