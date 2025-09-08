[![R-CMD-check](https://github.com/SauMStats/MvGGE/workflows/R-CMD-check/badge.svg)](https://github.com/SauMStats/MvGGE/actions)  
[![License: GPL-3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)  
[![Code Size](https://img.shields.io/github/languages/code-size/SauMStats/MvGGE)](https://github.com/SauMStats/MvGGE)  
[![Last Commit](https://img.shields.io/github/last-commit/SauMStats/MvGGE)](https://github.com/SauMStats/MvGGE/commits/main)

## Overview

**MvGGE** is an R package implementing a multi-phenotype approach for joint testing of main genetic effects and gene-environment (GxE) interactions, as described in the paper ["A Multi-Phenotype Approach to Joint Testing of Main Genetic and Gene-Environment Interaction Effects"](https://doi.org/10.1002/sim.70253) by Saurabh Mishra and Arunabha Majumdar (Statistics in Medicine, 2025).

Gene-environment (GxE) interactions play a crucial role in complex phenotypes, but detection is often limited by weak effect sizes. This package provides a robust framework to enhance statistical power by jointly testing main genetic and GxE effects across multiple related phenotypes, leveraging pleiotropy. It supports:

- **Continuous phenotypes**: Multivariate multiple linear regression (MMLR) with Wilks' Lambda test.
- **Binary or mixed phenotypes**: Generalized estimating equations (GEE) under seemingly unrelated regressions (SUR) with Wald tests.

Key features:
- Unified wrapper function `test_MvGGE()` for automatic phenotype type detection (bivariate support for mixed/binary; multi-phenotype for continuous).
- Simulation tools to generate data under various scenarios (e.g., varying MAF, effect sizes, pleiotropy).
- Demonstrated superior power in simulations and real-world applications (e.g., UK Biobank lipid phenotypes with sleep duration as the environmental factor, identifying novel loci).

This package is ideal for researchers in genetic epidemiology, biostatistics, and related fields analyzing GWAS or similar data.

## Installation

Install the development version from GitHub:

```r
# Install remotes if not already installed
if (!require("remotes")) install.packages("remotes")

remotes::install_github("SauMStats/MvGGE")
```

Load the package:

```r
library(MvGGE)
```

### Dependencies
- R (>= 3.6.0)
- MASS (for multivariate normal simulations)
- stats (base R, for GLM and linear models)

No additional installations are required beyond these.

## Usage

### Quick Start
The core function is `test_MvGGE(Y1, Y2, G, E)`, which automatically detects phenotype types and performs joint test.

```r
# Simulate bivariate data (continuous Y1/Y2, binary Yb1/Yb2)
set.seed(123)
sim_data <- simulate_data(n = 1000, maf = 0.2, f = 0.2, beta_g = c(0.05, 0.05), beta_ge = c(0.2, 0.2))

# Test 1: Bivariate Continuous
result_cont <- test_MvGGE(sim_data$Y1, sim_data$Y2, sim_data$G, sim_data$E)
print(result_cont)

# Test 2: Bivariate Binary
result_bin <- test_MvGGE(sim_data$Yb1, sim_data$Yb2, sim_data$G, sim_data$E)
print(result_bin)

# Test 3: Mixed (Continuous Y1, Binary Yb2)
result_mixed <- test_MvGGE(sim_data$Y1, sim_data$Yb2, sim_data$G, sim_data$E)
print(result_mixed)
```

Output example (for continuous case):
```
$analysis_type
[1] "Continuous Bivariate (MANOVA)"

$results
$results$test_type
[1] "F-statistic (Wilks)"

$results$statistic
[1] 0.85  # Approximate value; varies by data

$results$p_value
[1] 0.012
```

### Simulation Customization
Use `simulate_data()` to generate test data with parameters from Table 1 in the paper (e.g., sample size `n`, MAF `maf`, exposure prevalence `f`, effect sizes `beta_g`, `beta_ge`, correlation `rho`, binary thresholds `tau1`, `tau2`).

```r
# Null model for Type I error rate check
sim_null <- simulate_data(n = 1000, beta_g = c(0, 0), beta_ge = c(0, 0))
```

For multi-phenotype continuous cases, pass a matrix to `compute_joint_continuous()` directly.

### Full Documentation
- Run `?test_MvGGE` for function details.
- View the vignette: `vignette("mvgge-tutorial")` (coming soon).

## Citation
If you use MvGGE in your research, please cite:

Mishra, S., & Majumdar, A. (2025). A Multi-Phenotype Approach to Joint Testing of Main Genetic and Gene-Environment Interaction Effects. *Statistics in Medicine*, 44, e70253. https://doi.org/10.1002/sim.70253

BibTeX entry:
```
@article{mishra2025multi,
  title={A Multi-Phenotype Approach to Joint Testing of Main Genetic and Gene-Environment Interaction Effects},
  author={Mishra, Saurabh and Majumdar, Arunabha},
  journal={Statistics in Medicine},
  volume={44},
  pages={e70253},
  year={2025},
  publisher={Wiley Online Library},
  doi={10.1002/sim.70253}
}
```

## Contributing
Contributions are welcome! Please fork the repository and submit pull requests. For major changes, open an issue first to discuss.

- Report bugs or suggest features via [GitHub Issues](https://github.com/SauMStats/MvGGE/issues).
- Follow the [Code of Conduct](CODE_OF_CONDUCT.md).

## License
This package is licensed under the GPL-3 License. See the [LICENSE](LICENSE) file for details.

## Contact
- Saurabh Mishra: [saurabh.mishra@math.iith.ac.in](mailto:saurabh.mishra@math.iith.ac.in) (maintainer)
- Arunabha Majumdar: [arun.majum@math.iith.ac.in](mailto:arun.majum@math.iith.ac.in)

For questions or collaboration, feel free to reach out or open an issue.