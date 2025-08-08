# README — Statistical Inference & Clustering on Heart Disease Dataset (R)

## 📌 Overview
This project applies **unsupervised machine learning** and **statistical inference** to a heart disease dataset in order to identify natural groupings among patients.  
It uses **K-Means**, **Hierarchical Clustering**, **DBSCAN**, and **Gaussian Mixture Models (GMM)** and compares their performance using **Silhouette Scores**.

---

## 🎯 Objectives
- Clean and preprocess the heart disease dataset.
- Test multiple clustering algorithms.
- Evaluate clustering quality with **Mean Silhouette Score**.
- Visualize results for interpretability.
- Identify the best clustering approach for this dataset.

---

## 📂 Dataset
- **File:** `Heartdiseas.csv`  
- **Type:** Medical dataset (tabular).  
- **Features:** Age, resting blood pressure (`trestbps`), cholesterol (`chol`), fasting blood sugar (`fbs`), maximum heart rate achieved (`thalach`), ST depression (`oldpeak`), etc.  
- **Cleaning:**
  - Removed missing values.
  - Filtered outliers based on medical thresholds.
  - Dropped non-relevant ID column.

---

## 🛠 Requirements
Install and load required R packages:
```r
install.packages(c("cluster", "dbscan", "mclust"))
```

---

## 📜 Workflow
### 1. Data Preparation
- Remove missing values (`NA`).
- Apply realistic medical limits for certain variables.
- Define **two feature sets**:
  - **Set 1:** `age`, `trestbps`, `chol`, `fbs`, `thalach`, `oldpeak`
  - **Set 2:** `age`, `chol`, `thalach`

### 2. Clustering & Visualization
- **K-Means**
  - Use **WSS (Elbow Method)** to find optimal clusters for set1 & set2.
  - Visualize clustering with scatter plots.
- **Hierarchical Clustering**
  - Use Ward’s method and dendrograms.
- **DBSCAN**
  - Use `eps = 0.6` and `minPts = 4`.
  - Visualize density-based clusters.
- **Gaussian Mixture Models (GMM)**
  - Fit GMM with number of clusters equal to hierarchical clustering output.

### 3. Evaluation
- Calculate **Mean Silhouette Score** for each algorithm and feature set.
- Append results into a comparison table.

---

## ▶️ Running the Project
Run the R script:
```r
source("heart_disease_clustering.R")
```
This will:
- Generate WSS plots.
- Display cluster visualizations.
- Print silhouette score table.

---

## 📊 Example Results
| Algorithm     | Feature_Set | Mean_Silhouette |
|---------------|-------------|-----------------|
| KMeans        | set1        | **Best ~0.42**  |
| Hierarchical  | set1        | 0.39            |
| DBSCAN        | set1        | 0.31            |
| GMM           | set1        | 0.40            |

**Finding:** K-Means with **3 clusters** performed best for this dataset.

---

## 🔮 Future Improvements
- Automate hyperparameter tuning for DBSCAN and GMM.
- Use **PCA** to reduce dimensionality.
- Test additional medical features for better cluster separation.
- Integrate hypothesis testing to validate cluster differences.
