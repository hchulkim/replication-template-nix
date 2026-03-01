# Understanding Section 1.3, the MVP Estimation, and the R Code

## Part 1: What Does "Integrate Out an Empirical Distribution" Mean?

### The Setup You're Familiar With: Type-I Extreme Value (Logit)

In a standard discrete choice model (McFadden 1974), profit from choosing alternative $j$ is:

$$\pi_i(j) = \bar{\pi}_i(j) + \varepsilon_i(j)$$

where $\bar{\pi}_i(j)$ is deterministic ("observed") profit and $\varepsilon_i(j)$ is the unobserved shock. When you assume $\varepsilon_i(j) \sim$ i.i.d. Type-I Extreme Value (Gumbel), you get the **closed-form logit probability**:

$$\Pr(j \mid \text{alternatives}) = \frac{\exp(\bar{\pi}_i(j))}{\sum_k \exp(\bar{\pi}_i(k))}$$

This is beautiful because you **never need to see $\varepsilon_i(j)$**. The distributional assumption on $\varepsilon$ gives you an analytical formula. The CDF of Gumbel does all the work in closed form.

### What Section 1.3 Is Proposing Instead

Section 1.3 says something fundamentally different. Let's re-read the key passage. The profit equation is:

$$\pi_i(m, t \mid c) = \underbrace{A_{ic}(t)(p_{mc} - \tau_{mc}) - f_{mc} - f_{ct}}_{\bar{\pi}_i(\cdot)} - \varepsilon_i(m, t \mid c)$$

Notice: $\varepsilon_i(m,t|c)$ is a **market-technology-specific idiosyncratic fixed cost**. The paper says these costs "can be arbitrarily distributed by market and technology choice." This is the key: **they are NOT assuming Type-I Extreme Value for $\varepsilon$ in this nest.**

Instead, the paper says: "When entry decisions are perfectly observable at the farm-level (as in BICOS), we simply integrate out an empirical distribution of these $\varepsilon_i(m|c,t)$."

### What Does This Mean Concretely?

**Step 1: You observe every farm's choice.** The BICOS dataset tells you, for each farm $i$, exactly which $(m, t)$ combination was chosen — e.g., "Farm 4327 is an exporter with a pond." This is what "perfectly observable at the farm level" means.

**Step 2: You can compute deterministic profits $\bar{\pi}_i(m,t|c)$ for every alternative.** Using data on:
- Yields $A_{ic}(t)$ (from FAO potential yield rasters, rainfed vs. irrigated)
- Prices $p_{mc}$ (domestic price from SNIIM, export price from US terminals)
- Variable costs $\tau_{mc}$ (distance to domestic market or packer)
- Fixed costs $f_{mc}, f_{ct}$ (parameters to estimate)

you can compute the deterministic component of profit for all four alternatives {Domestic-Rainfed, Domestic-Pond, Export-Rainfed, Export-Pond} for every farm.

**Step 3: You can back out the $\varepsilon$ that rationalizes each farm's choice.**

Here's the key insight. If farm $i$ chose $(m^*, t^*)$ over all other $(m, t)$, then it must be that:

$$\bar{\pi}_i(m^*, t^*) - \varepsilon_i(m^*, t^*) \geq \bar{\pi}_i(m, t) - \varepsilon_i(m, t) \quad \forall (m,t)$$

Rearranging for any specific comparison, say Export vs. Domestic (fixing technology):

$$\varepsilon_i(X) - \varepsilon_i(D) \leq \bar{\pi}_i(X) - \bar{\pi}_i(D)$$

So the **difference in unobserved fixed costs** is bounded by the **difference in observable deterministic profits**. In the simplest case (binary choice between export and domestic, conditional on technology), if you're willing to normalize $\varepsilon_i(D) = 0$, then:

- If farm $i$ **exports**: $\varepsilon_i(X) \leq \bar{\pi}_i(X) - \bar{\pi}_i(D)$
- If farm $i$ **doesn't export**: $\varepsilon_i(X) > \bar{\pi}_i(X) - \bar{\pi}_i(D)$

### The "Empirical Distribution" Part

Rather than assuming $\varepsilon \sim$ Gumbel (which gives you logit), the paper says: **look at the actual distribution of $\bar{\pi}_i(X) - \bar{\pi}_i(D)$ across all farms in the data, crossed with their actual choices.** This cross-sectional variation identifies the distribution of $\varepsilon$.

Think of it this way:

- Farm A is close to a packer (low $\tau_{Xc}$), has high yields, and still **doesn't export**. We infer $\varepsilon_i(X)$ must be **very high** for this farm — it has an idiosyncratically large export fixed cost.
- Farm B is far from a packer (high $\tau_{Xc}$), has low yields, but **does export**. We infer $\varepsilon_i(X)$ must be **very low** for this farm.

As the paper says: "consider a farm in the BICOS data which is very cheap to export from due to high proximity to export-approved suppliers but still does not export. We infer that this land has an idiosyncratically high draw of the cost of exporting."

The "empirical distribution" is literally the histogram of these implied $\varepsilon$ draws across all farms. You're letting the data tell you what the distribution of unobserved costs looks like, rather than imposing a Gumbel (or normal, or any other parametric) distribution.

### How Is Dispersion Identified?

The dispersion (variance) of $\varepsilon$ is identified by the "noisiness" of the relationship between observables and choices:

- If **all** farms near packers export and **all** farms far from packers don't: $\varepsilon$ has very low variance. Observable deterministic profits perfectly predict choices.
- If the relationship is "noisy" — many close-to-packer farms don't export, and many far-from-packer farms do export: $\varepsilon$ has high variance. Unobserved heterogeneity in fixed costs is substantial.

This is exactly what the paper means by "dispersion in these fixed costs are then identified by the relative profitability of land for domestic use and for export use."

### The Parametric Fallback (Lognormal / Nonparametric)

The paper then notes: "With empirically integrated fixed costs, we can adopt a parametric assumption of lognormal costs $\varepsilon_i$ to ensure positive entry costs, or integrate a nonparametric distribution as in Bajari Benkard Levin."

This means:
1. **Option A (Lognormal):** Fit a lognormal distribution to the empirical distribution of implied $\varepsilon$'s. This ensures $\varepsilon > 0$ (costs are positive). You'd use this fitted distribution in counterfactuals.
2. **Option B (BBL-style nonparametric):** Don't impose any parametric form at all. Just use the empirical CDF directly, as in the Bajari, Benkard, and Levin (2007) approach to dynamic games. When you need to simulate counterfactuals, you resample from the observed distribution of $\varepsilon$.

### Comparison: Logit vs. Empirical Integration

| Feature | Logit (T1EV on $\varepsilon$) | Empirical Integration |
|---------|------------------------------|----------------------|
| Distributional assumption | $\varepsilon \sim$ Gumbel | None (or flexible parametric) |
| Choice probability | Closed form: $\frac{e^{\bar\pi_j}}{\sum_k e^{\bar\pi_k}}$ | Computed from empirical CDF of profit gaps |
| What you need | Only aggregate shares or choice data | Farm-level observability of ALL choices |
| IIA property | Yes (potentially restrictive) | No (flexible substitution) |
| Counterfactuals | Easy (just change $\bar\pi$ and recompute logit) | Requires resampling or parametric approximation |
| When to use | When farm-level data is limited | When you observe every farm's decision |

---

## Part 2: The MVP Estimation (MLE and GMM) — Full Derivation

### Important Caveat: The MVP Actually Uses Logit!

Here is where the connection between Parts 1 and 2 becomes clear. The **theoretical model** in Section 1.3 describes the general, nonparametric approach of "integrating out" $\varepsilon$. But the **MVP estimation** in Section 2 actually uses a **standard logit** for practical implementation as a first pass.

Look at Section 2 carefully. It says: "the MVP constructs a simple four-choice logit for the grid of technology and market choices: {HD, LD, HX, LX}."

So the MVP is saying: for now, as a minimum viable product, let's assume $\varepsilon_i(m,t|c)$ IS Type-I Extreme Value. Later, the full model can relax this and use the empirical integration approach described in Section 1.3.

This is a very common workflow in structural empirical IO: start with logit (fast, closed-form, easy to debug), then later move to a more flexible model (random coefficients, empirical distribution, etc.).

### The Four-Choice Multinomial Logit

The four alternatives for a farm that has already entered avocado production are:

$$j \in \{(D,L), (D,H), (X,L), (X,H)\}$$

which correspond to:
- **DL**: Domestic, Rainfed (Low technology)
- **DH**: Domestic, Pond (High technology)
- **XL**: Export, Rainfed
- **XH**: Export, Pond

### Profit Specification

From the paper's equation (5), adapted for the MVP:

$$\bar{\pi}_i(m, t \mid \text{avo}) = \gamma \cdot \left[ (p_{m,\text{avo}} - \gamma_\tau \cdot \tau_{m,\text{avo}}) \cdot A_{i,\text{avo}}(t) - f_{m,\text{avo}} - f_{\text{avo},t} \right]$$

where:
- $\gamma$ = profit scaling parameter (converts USD profit to "utils"; equivalently, $1/\gamma$ is the scale of the $\varepsilon$ distribution)
- $\gamma_\tau$ = transport cost per ton-km
- $p_{m,\text{avo}}$ = price in market $m$ (domestic SNIIM price or US terminal price)
- $\tau_{m,\text{avo}}$ = distance to relevant wholesaler (SNIIM for domestic, packer for export)
- $A_{i,\text{avo}}(t)$ = yield (rainfed or irrigated, from FAO)
- $f_{m,\text{avo}}$ = market-specific fixed cost (export cost; domestic normalized to 0)
- $f_{\text{avo},t}$ = technology-specific fixed cost (pond cost)

Writing out all four deterministic utilities explicitly:

$$V_i^{DL} = \gamma \cdot \left[ p_D \cdot y_i^L - \gamma_\tau \cdot d_i^{\text{SNIIM}} \cdot y_i^L \right]$$

$$V_i^{DH} = \gamma \cdot \left[ p_D \cdot y_i^H - \gamma_\tau \cdot d_i^{\text{SNIIM}} \cdot y_i^H - f_H \right]$$

$$V_i^{XL} = \gamma \cdot \left[ p_X \cdot y_i^L - \gamma_\tau \cdot d_i^{\text{packer}} \cdot y_i^L - f_X \right]$$

$$V_i^{XH} = \gamma \cdot \left[ p_X \cdot y_i^H - \gamma_\tau \cdot d_i^{\text{packer}} \cdot y_i^H - f_X - f_H \right]$$

where:
- $y_i^L$ = potential rainfed yield for farm $i$
- $y_i^H$ = potential irrigated yield for farm $i$
- $d_i^{\text{SNIIM}}$ = distance to nearest SNIIM market
- $d_i^{\text{packer}}$ = distance to nearest packer

### Multinomial Logit Probabilities

Under the Type-I Extreme Value assumption on $\varepsilon$, the choice probability for alternative $j$ is:

$$P_i(j) = \frac{\exp(V_i^j)}{\sum_{k \in \{DL, DH, XL, XH\}} \exp(V_i^k)}$$

### MLE: Maximum Likelihood Estimation

**The likelihood function.** Let $y_i^j \in \{0, 1\}$ be an indicator for whether farm $i$ chose alternative $j$. The log-likelihood is:

$$\ell(\theta) = \sum_{i=1}^{N} \sum_{j \in \{DL,DH,XL,XH\}} y_i^j \cdot \ln P_i(j; \theta)$$

where $\theta = (\gamma, \gamma_\tau, f_X, f_H)$ (and potentially municipality-year fixed effects in $f_X$).

**First-order conditions (score equations).** Setting $\frac{\partial \ell}{\partial \theta_k} = 0$:

$$\frac{\partial \ell}{\partial \theta_k} = \sum_{i=1}^{N} \sum_{j} y_i^j \cdot \frac{\partial \ln P_i(j)}{\partial \theta_k} = 0$$

For the multinomial logit, the score has a very clean form. Using the fact that:

$$\frac{\partial \ln P_i(j)}{\partial \theta_k} = \frac{\partial V_i^j}{\partial \theta_k} - \sum_m P_i(m) \frac{\partial V_i^m}{\partial \theta_k}$$

the score equation becomes:

$$\sum_{i=1}^{N} \sum_j \left( y_i^j - P_i(j) \right) \cdot \frac{\partial V_i^j}{\partial \theta_k} = 0$$

This has an incredibly intuitive interpretation: at the optimum, the **residual** $(y_i^j - P_i(j))$ is orthogonal to the "instruments" $\frac{\partial V_i^j}{\partial \theta_k}$. This is a **moment condition** — which is exactly why the paper says "The estimation method amounts to maximum likelihood if one believes that these variables are all exogenous. However, I estimate a GMM on the score function."

### The Parameters in Detail

The model has 5 free parameters (matching the R code):

| Parameter | Symbol | Role |
|-----------|--------|------|
| `x[1]` = `beta_dist_sniim` | $\gamma_\tau^D$ | Transport cost to domestic market ($/ton-km) |
| `x[2]` = `beta_dist_packer` | $\gamma_\tau^X$ | Transport cost to packer ($/ton-km) |
| `x[3]` = `beta_yield` | $\gamma$ | Profit scaling (utils per $1000) |
| `x[4]` = `beta_export_cost` | $f_X$ | Export fixed cost ($/ha) |
| `x[5]` = `beta_export_fixed_cost` | $f_H$ | Pond fixed cost ($/ha) |

**Note on the role of $\gamma$.** In a standard logit, the scale of utility is not separately identified from the variance of $\varepsilon$. Recall that if $\varepsilon \sim \text{Gumbel}(0, \mu)$, the probability is:

$$P_i(j) = \frac{\exp(V_i^j / \mu)}{\sum_k \exp(V_i^k / \mu)}$$

So $\gamma$ in this model is effectively $1/\mu$, the inverse of the scale parameter of the error distribution. A larger $\gamma$ means less noise in decisions (choices are more deterministic). A smaller $\gamma$ means more randomness.

### GMM: Generalized Method of Moments

**Why GMM?** The paper says the score-based estimation "amounts to maximum likelihood if one believes that these variables are all exogenous." But what if, say, distance to packers is endogenous (packers locate near productive farms)? Then MLE is inconsistent. GMM allows you to replace the score instruments with valid instruments.

**Moment conditions.** The GMM moment conditions are exactly the MLE first-order conditions rewritten as population moment restrictions:

$$E\left[\mathbf{g}_i(\theta)\right] = E\left[\sum_j (y_i^j - P_i(j;\theta)) \cdot \mathbf{z}_i^j\right] = 0$$

where $\mathbf{z}_i^j$ is a vector of instruments. Under MLE (exogeneity), $\mathbf{z}_i^j = \frac{\partial V_i^j}{\partial \theta}$. Under GMM with IVs, you'd replace $\mathbf{z}_i^j$ with excluded instruments.

**The GMM objective.** Form the sample analog of the moments:

$$\hat{\mathbf{g}}(\theta) = \frac{1}{N} \sum_{i=1}^{N} \mathbf{g}_i(\theta)$$

The GMM estimator minimizes:

$$Q(\theta) = \hat{\mathbf{g}}(\theta)' \cdot W \cdot \hat{\mathbf{g}}(\theta)$$

where $W$ is a positive definite weighting matrix.

**Two-step efficient GMM:**

1. **Step 1:** Set $W = I$ (identity matrix). Solve $\hat{\theta}^{(1)} = \arg\min_\theta \hat{\mathbf{g}}(\theta)' I \hat{\mathbf{g}}(\theta)$.

2. **Compute optimal weighting matrix:** At $\hat{\theta}^{(1)}$, compute:
$$\hat{\Omega} = \frac{1}{N} \sum_{i=1}^{N} \mathbf{g}_i(\hat{\theta}^{(1)}) \mathbf{g}_i(\hat{\theta}^{(1)})'$$
Then set $W^* = \hat{\Omega}^{-1}$.

3. **Step 2:** Solve $\hat{\theta}^{(2)} = \arg\min_\theta \hat{\mathbf{g}}(\theta)' W^* \hat{\mathbf{g}}(\theta)$.

This two-step procedure yields the **efficient GMM estimator**, which achieves the semiparametric efficiency bound among all GMM estimators using these moment conditions.

### Reparameterization for GMM

The R code introduces a reparameterization for the GMM. Instead of estimating $(\gamma_\tau^D, \gamma_\tau^X, \gamma, f_X, f_H)$, it estimates:

$$\alpha_1 = \gamma \cdot \gamma_\tau^D, \quad \alpha_2 = \gamma \cdot \gamma_\tau^X, \quad \alpha_3 = \gamma, \quad \alpha_4 = \gamma \cdot f_X, \quad \alpha_5 = \gamma \cdot f_H$$

**Why?** Because in the utility function, $\gamma$ multiplies everything:

$$V_i^{XH} = \gamma \left[ p_X y_i^H - \gamma_\tau^X d_i^{\text{packer}} y_i^H - f_X - f_H \right]$$
$$= \alpha_3 \cdot p_X \cdot y_i^H - \alpha_2 \cdot d_i^{\text{packer}} \cdot y_i^H - \alpha_4 - \alpha_5$$

In this reparameterized form, the utility is **linear in $\alpha$**, which makes the GMM moments better behaved (the Jacobian is better conditioned). The original parameterization has $\gamma$ interacting multiplicatively with all other parameters, creating a near-singular Jacobian.

To recover dollar-denominated costs:

$$\gamma_\tau^D = \alpha_1 / \alpha_3, \quad \gamma_\tau^X = \alpha_2 / \alpha_3, \quad f_X = \alpha_4 / \alpha_3, \quad f_H = \alpha_5 / \alpha_3$$

### The Five Moment Conditions Explicitly

The five moment conditions $g_1, \ldots, g_5$ correspond to the derivative of utility with respect to each $\alpha_k$, interacted with residuals:

**Moment 1** (identifies $\alpha_1$: domestic transport cost):
$$g_1 = \frac{1}{N} \sum_i \left[ (y_i^{DL} - P_i^{DL}) \cdot (-d_i^{\text{SNIIM}} y_i^L) + (y_i^{DH} - P_i^{DH}) \cdot (-d_i^{\text{SNIIM}} y_i^H) \right]$$

This says: the residual for domestic choices should be uncorrelated with the domestic distance×yield instrument.

**Moment 2** (identifies $\alpha_2$: export transport cost):
$$g_2 = \frac{1}{N} \sum_i \left[ (y_i^{XL} - P_i^{XL}) \cdot (-d_i^{\text{packer}} y_i^L) + (y_i^{XH} - P_i^{XH}) \cdot (-d_i^{\text{packer}} y_i^H) \right]$$

**Moment 3** (identifies $\alpha_3$: profit scaling):
$$g_3 = \frac{1}{N} \sum_i \sum_j (y_i^j - P_i^j) \cdot (p_m \cdot y_i^t)$$

This uses price×yield across all alternatives.

**Moment 4** (identifies $\alpha_4$: export fixed cost):
$$g_4 = \frac{1}{N} \sum_i \left[ (y_i^{XL} - P_i^{XL}) \cdot (-1) + (y_i^{XH} - P_i^{XH}) \cdot (-1) \right]$$

This is just: "the share of exporters in data minus predicted share of exporters should be zero." It pins down the level of the export fixed cost.

**Moment 5** (identifies $\alpha_5$: pond fixed cost):
$$g_5 = \frac{1}{N} \sum_i \left[ (y_i^{DH} - P_i^{DH}) \cdot (-1) + (y_i^{XH} - P_i^{XH}) \cdot (-1) \right]$$

Similarly: "the share of pond adopters minus predicted share should be zero."

---

## Part 3: How the R Code Implements This

### 3.1 The MLE Function (Lines 2–52)

The function `mle(x, input_data)` implements the **negative log-likelihood** for the original parameterization with 5 parameters.

**Step A: Compute deterministic utilities (lines 12–17).**

```r
pi_domestic_rain = x[3] * (price_dom * yield_rain - x[1] * dist_sniim * yield_rain)
pi_domestic_pond = x[3] * (price_dom * yield_irr  - x[1] * dist_sniim * yield_irr - x[5])
pi_export_rain   = x[3] * (price_exp * yield_rain - x[2] * dist_packer * yield_rain - x[4])
pi_export_pond   = x[3] * (price_exp * yield_irr  - x[2] * dist_packer * yield_irr - x[4] - x[5])
```

This directly implements:

$$V_i^{DL} = \gamma [(p_D - \gamma_\tau^D d_i^S) y_i^L]$$
$$V_i^{DH} = \gamma [(p_D - \gamma_\tau^D d_i^S) y_i^H - f_H]$$
$$V_i^{XL} = \gamma [(p_X - \gamma_\tau^X d_i^P) y_i^L - f_X]$$
$$V_i^{XH} = \gamma [(p_X - \gamma_\tau^X d_i^P) y_i^H - f_X - f_H]$$

**Step B: Log-sum-exp trick for numerical stability (lines 21–27).**

Computing $\ln\left(\sum_j e^{V_j}\right)$ naively causes overflow when $V_j$ is large. The trick is:

$$\ln\left(\sum_j e^{V_j}\right) = V_{\max} + \ln\left(\sum_j e^{V_j - V_{\max}}\right)$$

where $V_{\max} = \max_j V_j$. Now $e^{V_j - V_{\max}} \leq 1$, so no overflow.

**Step C: Log-probabilities (lines 28–33).**

$$\ln P_i(j) = V_i^j - \underbrace{\left[V_{\max} + \ln\sum_k e^{V_k - V_{\max}}\right]}_{\text{log-sum-exp}}$$

This is just $\ln \frac{e^{V_j}}{\sum_k e^{V_k}} = V_j - \ln(\sum_k e^{V_k})$.

**Step D: Log-likelihood (lines 35–41).**

$$\ell = \sum_i \left[ y_i^{XH} \cdot \ln P_i^{XH} + y_i^{DH} \cdot \ln P_i^{DH} + y_i^{XL} \cdot \ln P_i^{XL} + y_i^{DL} \cdot \ln P_i^{DL} \right]$$

The code uses `farm_type == 'Pond, Exporter'` etc. as the $y_i^j$ indicators.

**Step E: Return negative log-likelihood (line 51)** because `optim` minimizes by default.

### 3.2 Optimization (Lines 76–89)

```r
optim(par = initial_values, fn = mle, method = "L-BFGS-B",
      lower = ..., upper = ..., hessian = TRUE)
```

- **L-BFGS-B**: A quasi-Newton method that supports box constraints. It approximates the Hessian using gradient information (BFGS = Broyden–Fletcher–Goldfarb–Shanno), with limited memory (the "L").
- **Bounds**: Transport costs > 0, profit scale $\gamma \in [0.1, 10]$, fixed costs > 0.
- **`hessian = TRUE`**: Numerically computes the Hessian at the optimum, which can be used for standard errors via $\text{Var}(\hat\theta) \approx (-H)^{-1}$ where $H$ is the Hessian of the log-likelihood.

### 3.3 The GMM Implementation (Lines 228–647)

**Step A: Reparameterize (lines 228–241).**

The code switches to $\alpha$ parameters so that utility is linear in parameters:

```r
V_domestic_rain = alpha[3]*price*yield_rain - alpha[1]*dist_sniim*yield_rain
V_export_pond   = alpha[3]*price*yield_irr  - alpha[2]*dist_packer*yield_irr - alpha[4] - alpha[5]
```

**Step B: Compute residuals (lines 260–274).**

$$e_i^j = y_i^j - P_i(j; \alpha)$$

These are the "generalized residuals" of the multinomial logit.

**Step C: Form moment conditions (lines 289–326).**

Each moment is $g_k = \frac{1}{N}\sum_i \sum_j e_i^j \cdot z_i^{jk}$ where $z_i^{jk} = \partial V_i^j / \partial \alpha_k$.

For example, Moment 1:

```r
g1 = mean(resid_domestic_rain * (-dist_sniim * yield_rain) +
          resid_domestic_pond * (-dist_sniim * yield_irr))
```

This implements $g_1 = \frac{1}{N}\sum_i [e_i^{DL} \cdot (-d_i^S y_i^L) + e_i^{DH} \cdot (-d_i^S y_i^H)]$ since $\frac{\partial V^{DL}}{\partial \alpha_1} = -d_i^S y_i^L$ and the export alternatives have $\frac{\partial V^{XL}}{\partial \alpha_1} = 0$.

**Step D: GMM objective (lines 332–347).**

$$Q(\alpha) = \hat{\mathbf{g}}(\alpha)' W \hat{\mathbf{g}}(\alpha)$$

```r
obj = t(g) %*% wt_matrix %*% g
```

**Step E: Two-step GMM.**

1. **First step** (line 384): $W = I_5$, get $\hat\alpha^{(1)}$.
2. **Optimal weighting** (line 470): $\hat\Omega = \frac{1}{N} G'G$ where $G$ is the $N \times 5$ matrix of individual moment contributions $g_i(\hat\alpha^{(1)})$. Then $W^* = \hat\Omega^{-1}$.
3. **Second step** (line 489): Minimize $Q(\alpha)$ with $W^*$.

**Step F: Recovery (lines 521–535).** Convert back to dollars:

```r
transport_domestic_usd = alpha[1] / alpha[3] * 1000
export_cost_usd        = alpha[4] / alpha[3] * 1000
```

### 3.4 Diagnostics in the Code

- **Jacobian condition number** (lines 602–625): Checks whether the moments are well-identified. A high condition number means near-collinearity among moments (bad). The reparameterization should improve this.
- **Gradient at solution** (lines 630–648): Should be near zero if the optimizer converged.
- **Share comparison** (lines 552–597): Compares actual vs. predicted shares — a basic goodness-of-fit check.

---

## Summary: How Everything Connects

1. **Section 1.3 (Theory)** describes the ideal: when you observe every farm's choice, you don't need to assume Gumbel errors. You can let the data reveal the distribution of unobserved costs by looking at which farms with favorable observables still make "surprising" choices. The $\varepsilon$'s are backed out from revealed preference inequalities, and their empirical distribution is used directly.

2. **Section 2 (MVP)** says: as a first practical step, let's use the logit (which assumes Gumbel $\varepsilon$) because it gives a clean closed-form likelihood. The score equations of this logit are also valid moment conditions for GMM, which allows for future IV extensions if some variables are endogenous.

3. **The R code** implements both:
   - **MLE**: Directly maximizes the logit log-likelihood in the original parameterization.
   - **GMM**: Re-derives the score conditions as moment conditions in a reparameterized form ($\alpha$), then uses two-step efficient GMM.

The key takeaway: the logit in the MVP is a **computational convenience** for the starting point. The theoretical framework in Section 1.3 is more general and will eventually replace the Gumbel assumption with empirical distributions or flexible parametric (lognormal) distributions. But both approaches share the same core data — you're using the cross-sectional variation in "who exports despite low observable profitability of exporting" to identify the distribution of unobserved fixed costs.
