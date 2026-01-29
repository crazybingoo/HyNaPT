# HyNaPT

This repository provides a **reproducible MATLAB framework** for analyzing **dynamic epileptic brain networks** using **hypergraph theory, probabilistic state transitions, and multi-scale node vulnerability analysis**.

The pipeline integrates **signal processing**, **hypergraph construction**, **node-level biomarkers**, **transition probability modeling**, and **dynamic clustering**, enabling systematic investigation of **seizure propagation mechanisms** across time.

---

## 1. Overview

This project proposes **HyNaPT (Hypergraph-based Neural Activity Propagation and Transition)**, a framework that:

* Constructs **time-resolved hypergraphs** from multichannel neural signals
* Quantifies **node vulnerability and functional roles**
* Builds **directed transition probability matrices** between brain regions
* Analyzes **dynamic propagation paths and modular organization**
* Supports **pre-ictal / ictal / post-ictal comparative analysis**

The framework is designed for **epilepsy research**, but can be adapted to other multivariate neural systems.

---

## 2. Key Features

* **Hypergraph modeling** of high-order neural interactions
* **Multi-feature node characterization**, including:

  * Hyperdegree
  * PLV-based connectivity
  * Shortest hypergraph paths
  * High-frequency oscillation (HFO) power
  * Signal amplitude statistics
  * Phase–Amplitude Coupling (PAC)
  * Clinical zone priors (EZ / PZ / NIZ)
* **Gaussian kernel similarity** for node-state affinity
* **Four-case transition modeling**:

  1. Same hyperedge
  2. Adjacent hyperedges
  3. Indirect hyperedge paths
  4. No direct hypergraph connection
* **Time-resolved Markov transition matrices**
* **Dynamic clustering and co-clustering statistics**
* **Visualization of propagation paths and node fragility**

---

## 3. Project Structure

```text
HyNaPT/
├── data/
│   └── example_Gamma.mat          % Preprocessed neural signals
│
├── src/
│   ├── hypergraph/
│   │   ├── gain_hyperEdges.m
│   │   ├── d_u.m
│   │   ├── hypergraph_avg_shortest_path.m
│   │   ├── hypergraph_efficiency.m
│   │   └── computeRefinedConnectivity.m
│   │
│   ├── signal_features/
│   │   ├── get_plvMatrix.m
│   │   ├── compute_PAC.m
│   │   └── compute_HFO_PSD.m
│   │
│   ├── similarity/
│   │   └── GK_Similarity.m
│   │
│   ├── transition/
│   │   ├── find_node_pair_connections.m
│   │   ├── compute_hyperedge_weight.m
│   │   ├── compute_hyperedge_adj_weight.m
│   │   └── build_transition_matrix.m
│   │
│   ├── clustering/
│   │   ├── spectral_kmeans_clustering.m
│   │   └── mapLabels.m
│   │
│   └── utils/
│       ├── z_score_normalization.m
│       └── min_max_normalization.m
│
├── experiments/
│   ├── run_pipeline.m
│   ├── analyze_Qij_dynamics.m
│   ├── node_vulnerability_analysis.m
│   └── dynamic_clustering_analysis.m
│
├── figures/
│   └── (generated results)
│
└── README.md
```

---

## 4. Data Format

### Input Signal

* `X1`:

  * Size: **[N_channels × T_samples]**
  * Sampling rate: **1024 Hz**
  * Sliding window: **3 seconds**, step size **1 second**

Example:

```matlab
load('example_Gamma.mat');
size(X1)  % [18 × T]
```

---

## 5. Core Pipeline

### Step 1: Hypergraph Construction

```matlab
all_hyperEdges = gain_hyperEdges(datanew);
```

Hyperedges represent **high-order synchronous interactions** between channels.

---

### Step 2: Node Feature Extraction

For each time window:

* Hyperdegree
* Mean PLV
* Hypergraph shortest path
* HFO power
* Signal amplitude (mean / max)
* Phase–Amplitude Coupling (PAC)
* Clinical prior weights (EZ / PZ / NIZ)

All features are **z-scored and min–max normalized**.

---

### Step 3: Node Similarity Matrix

Gaussian kernel similarity:

```matlab
f_uv = GK_Similarity(node_feature_matrix);
```

---

### Step 4: Transition Probability Matrix Construction

Each node pair `(u, v)` is assigned a transition probability based on:

1. **Same hyperedge**
2. **Adjacent hyperedges**
3. **Indirect hyperedge paths**
4. **No hypergraph connection**

Final output:

```matlab
P_all{t}  % Directed transition probability matrix
```

---

### Step 5: Time-Resolved Transition Integration

```matlab
Q_ij{t} = (P_all{t} + P_all{t+1}) / 2;
Q_ij{t}(diag_indices) = 0;
Q_ij{t} = Q_ij{t} ./ sum(Q_ij{t}, 2);
```

---

### Step 6: Dynamic Node Vulnerability Metrics

For each time window:

* **Diffusion-driven entropy**
* **Sensitivity (incoming probability mass)**
* **Betweenness centrality (weighted directed graph)**

---

### Step 7: Dynamic Clustering

* PCA-based embedding of transition matrices
* KMeans clustering
* Temporal label alignment
* Co-clustering statistics for node groups (2–8 nodes)

---

## 6. Reproducibility

To reproduce the main experiment:

```matlab
cd experiments
run_pipeline
```

All results are deterministic given the same input data and random seed.

---

## 7. Visualization Outputs

* Time-resolved heatmaps of node entropy, sensitivity, and betweenness
* Transition path simulations
* Dynamic clustering scatter plots
* Co-clustering frequency bar charts
* Seizure-stage comparative statistics

---

## 8. Dependencies

* MATLAB R2020a or later
* Signal Processing Toolbox
* Statistics and Machine Learning Toolbox
* Graph and Network Algorithms Toolbox

---

## 9. Citation

If you use this code, please cite:

```text
[Author Names]. 
Hypergraph-based Neural Activity Propagation and Transition Modeling 
for Epileptic Brain Networks.
```

(Manuscript in preparation)

---

## Requirements

- MATLAB R2021b (tested with R2021a/b; any recent version should work)
- Signal Processing Toolbox (for `hilbert`)
---

