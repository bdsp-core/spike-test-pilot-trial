# Spike Test Pilot Trial — Nascimento 2024

Code and de-identified data accompanying:

> Nascimento FA, Jing J, Traner C, Kong W-Y, Olandoski M, Kapur K,
> Duhaime A-C, Strowd RE, Moeller JJ, Westover MB.
> **A randomized controlled educational pilot trial of interictal
> epileptiform discharge identification for neurology residents.**
> *Epileptic Disord* 2024 Aug; 26(4): 444–459.
> doi: [10.1002/epd2.20229](https://doi.org/10.1002/epd2.20229)

## Study in one paragraph

21 neurology residents were randomized to three arms and tested
pre- and post-intervention on 500 ten-second EEG clips each (50 per
bin × 10 bins: 9 bins = number of Super-8 expert yes-votes, 0–8;
1 bin = normal variants / "spike mimics"). Arms: **Control** (n=8,
no intervention); **Int1** (n=6, one-on-one expert mentorship);
**Int2** (n=7, web-app self-study with AI feedback). Primary
outcomes: sensitivity, false-positive rate, accuracy, calibration,
AUC, and latent-trait parameters (noise σ, bias θ). Int1 AUC rose
0.74 → 0.85 (p<0.05); Int2 0.81 → 0.86; Control unchanged.

## Arm ↔ group code mapping

The MATLAB code uses `G1`/`G2`/`G3`. These map to the paper as:

| Group | Arm | n | Resident IDs |
|---|---|---|---|
| G1 | **Int1** (mentorship) | 6 | R04, R05, R06, R08, R15, R18 |
| G2 | **Int2** (web-app / AI feedback) | 7 | R02, R11, R12, R13, R16, R19, R21 |
| G3 | **Control** | 8 | R01, R03, R07, R09, R10, R14, R17, R20 |

## Repository contents

```
spike-test-pilot-trial/
├── step1_getRealPerformance.m      # per-subject per-session metrics (sen/fpr/acc/cal/auc/bias/noise)
├── step2_fitLatentTraitModel.m     # arm-level latent-trait ROC fit
├── step3_getFigures.m              # drives Figure 2–6 generation
├── Callbacks/
│   ├── fcn_getSenFprAcc.m          # sensitivity / FPR / accuracy (drops the 4-vote bin)
│   ├── fcn_caliParametric.m        # Hosmer–Lemeshow-style calibration index
│   ├── fcn_fitROC.m                # per-rater (θ, σ) ROC fit
│   ├── fcn_fitROCm.m               # arm-level multi-rater ROC fit
│   ├── fcn_latentTraitModel.m      # single-point ROC model (probit)
│   ├── fcn_latentTraitModelm.m     # multi-point ROC model (probit)
│   ├── fcn_getFigure{2..6}_*.m     # figure-specific plotting code
│   ├── Performance_experts.mat     # expert-reviewer reference performance
│   └── fittedROC_experts.mat       # expert-fitted ROC curves (reference)
├── Data-DeIDed/
│   ├── pre-study-test/G{1,2,3}/R{NN}_scores_G{id}.mat
│   └── post-study-test/G{1,2,3}/R{NN}_scores_G{id}.mat
├── Outputs/
│   ├── Performance_G{1,2,3}.mat    # pre-computed metrics per arm
│   └── fittedROC_G{1,2,3}.mat      # pre-computed fitted ROC per arm
└── Figure{2..6}.png                # paper figures
```

### `Data-DeIDed` schema

Each `R{NN}_scores_G{id}.mat` contains three 500×1 vectors covering
the 500 trials of one resident's one session (pre or post):

- `y` (int16) — ground-truth bin label per trial. Values:
  - `-1` = normal-variant stimulus ("spike mimic"; treated as a true
    negative for sensitivity/FPR, see `thr=4` below);
  - `0..8` = number of Super-8 expert yes-votes on the stimulus.
- `y_human` (uint8) — rater's binary response: `1` = called a spike,
  `0` = called not-a-spike.
- `y_ssd` (float64) — continuous SSD (signal saliency) score used
  for supplementary analyses.

Note: `step1_getRealPerformance.m` sets `thr=4`, i.e. it treats
`y>4` as positive and `y<4` as negative when computing
sensitivity/FPR, and **discards the 4-vote bin** from those metrics
(ambiguous cases). AUC is computed across the retained trials with
`maxErr=0.01` per subject; the arm-level fit uses `maxErr=0.10`.

## How to reproduce the paper's figures

Requires MATLAB (tested with R2020a+, Statistics Toolbox).

```matlab
% from repo root:
step1_getRealPerformance     % writes Outputs/Performance_G*.mat
step2_fitLatentTraitModel    % writes Outputs/fittedROC_G*.mat
step3_getFigures             % regenerates Figure{2..6}.png
```

The three scripts run in order. Intermediate `.mat` files checked
into `Outputs/` let you re-run step 3 without re-running 1 and 2.

## Source EEG signals and rater responses (full raw data)

`Data-DeIDed/` ships the per-trial responses needed to reproduce
the statistics in the paper, but **does not include the EEG signals
themselves**. The full dataset — including the 20,521 10-second EEG
clips, the complete scoring matrix from 2,300+ raters (Super-8
experts, Crowd, Bonobo, New-28, SpikeEd residents, SpikeEd experts,
public web-app raters), and patient-level metadata — is published
on bdsp.io as an HDF5 file (`SN1_combined_v2.h5`) plus auxiliary
CSVs.

- **AWS S3 path (restricted-access open data):**
  `s3://bdsp-opendata-restricted/spike-test/`
- **Access credentials:** request through <https://bdsp.io/>. The
  bucket is restricted-access under the dataset's data-use agreement;
  once approved, credentials are issued by the BDSP team.
- **Schema:** documented in the dataset's bdsp.io landing page. Key
  arrays:
  - `/eeg/signals` (N_segments, 1281, 20) at 128 Hz, 10-20 montage + EKG
  - `/segments/file_key` — e.g. `scr5_0042`, `scr-1_0054`, `Bonobo00001_...`
  - `/experts/*` — de-identified rater metadata (affiliation, years
    reading EEG, neurologist/epileptologist flags, study arm/condition)
  - `/scores/matrix` — (segments × raters) int8 responses
    (-1 unscored / 0 no / 1 yes)

### Case-level mapping (bin, case_idx) → filename

The 500-trial test battery draws 50 cases per bin from a master
pool of 13,262 Super-8-labelled SN1 stimuli (bins 0–8) plus 3,293
Fabio benign-variant stimuli (bin -1). Each `Data-DeIDed` `.mat`
file's trial `t` maps to stimulus filename
`scr{y(t)}_{case_idx(t):04d}.csv` in the master bank. The master
per-rater LUTs on S3 (`*_LUT.csv`, 6+5 columns) expose col 0 =
rating bin and col 3 = case_idx, giving the full decoder.

## License

MIT — see [LICENSE](LICENSE).

## Citation

If you use this code or data, please cite both the paper and the
dataset DOI (available from the bdsp.io landing page):

```
@article{Nascimento2024SpikeEd,
  author  = {Nascimento, F. A. and Jing, J. and Traner, C. and Kong, W.-Y.
             and Olandoski, M. and Kapur, K. and Duhaime, A.-C.
             and Strowd, R. E. and Moeller, J. J. and Westover, M. B.},
  title   = {A randomized controlled educational pilot trial of
             interictal epileptiform discharge identification for
             neurology residents},
  journal = {Epileptic Disorders},
  volume  = {26},
  number  = {4},
  pages   = {444--459},
  year    = {2024},
  doi     = {10.1002/epd2.20229},
}
```

## Questions / issues

Open an issue on this repo, or contact the corresponding author
(M. Brandon Westover, <mwestover@mgh.harvard.edu>).
