# Load necessary libraries
library(cluster)
library(dbscan)
library(mclust)

# Load and clean the dataset
heart_data <- read.csv("Heartdiseas.csv", na.strings = "")
heart_data <- na.omit(heart_data)
heart_data <- heart_data[
  heart_data$trestbps >= 90 & heart_data$trestbps <= 200 &
    heart_data$chol >= 100 & heart_data$chol <= 400 &
    heart_data$thalach >= 60 & heart_data$thalach <= 220 &
    heart_data$oldpeak >= 0 & heart_data$oldpeak <= 6, ]
heart_data<-heart_data[,-1]
View(heart_data)

# Define multiple feature sets
feature_sets <- list(
  set1 = c("age", "trestbps", "chol", "fbs", "thalach", "oldpeak"),
  set2 = c("age", "chol", "thalach")
)

# Initialize a results data frame
results <- data.frame(
  Algorithm = character(),
  Feature_Set = character(),
  Mean_Silhouette = numeric()
)

# Iterate through feature sets
for (set_name in names(feature_sets)) {
  features <- feature_sets[[set_name]]
  heart_numeric <- heart_data[, features]
  
  # Check the structure of the numeric data
  print(paste("Feature Set:", set_name))
  print(summary(heart_numeric))
  
  
  # Handle any missing values or constants by removing them
  if (any(is.na(heart_numeric))) {
    heart_numeric <- na.omit(heart_numeric)
  }
  
  # K-Means Clustering
  wss <- numeric(16)
  for (i in 1:16) {
    wss[i] <- sum(kmeans(heart_numeric, centers = i, nstart = 10)$tot.withinss)
  }
  plot(1:16, wss, type = 'b', xlab = 'Number of Clusters', ylab = 'Within-Group Sum of Squares',
       main = paste("WSS Plot for", set_name))
  
  optimal_clusters <- 3  # Set manually based on WSS plot
  kc <- kmeans(heart_numeric, centers = optimal_clusters, nstart = 10)
  
  # Visualize K-Means clustering results
  plot(heart_numeric$age, heart_numeric$thalach, col = kc$cluster, pch = 19,
       xlab = "Age", ylab = "Max Heart Rate",
       main = paste("K-Means Clustering for", set_name))
  points(kc$centers[, c("age", "thalach")], col = 1:optimal_clusters, pch = 8, cex = 2)
  
  # Silhouette Score for K-Means
  if (length(unique(kc$cluster)) > 1) {
    silhouette_kmeans <- silhouette(kc$cluster, dist(heart_numeric))
    mean_silhouette_kmeans <- mean(silhouette_kmeans[, 3])
  } else {
    mean_silhouette_kmeans <- NA
  }
  
  # Hierarchical Clustering
  dist_matrix <- dist(heart_numeric, method = "euclidean")
  hclust_result <- hclust(dist_matrix, method = "ward.D2")
  plot(hclust_result, main = paste("Hierarchical Clustering for", set_name), xlab = "", sub = "", cex = 0.9)
  
  num_clusters_hierarchical <- 3
  cluster_assignments_hierarchical <- cutree(hclust_result, k = num_clusters_hierarchical)
  
  # Silhouette Score for Hierarchical Clustering
  if (length(unique(cluster_assignments_hierarchical)) > 1) {
    silhouette_hierarchical <- silhouette(cluster_assignments_hierarchical, dist(heart_numeric))
    mean_silhouette_hierarchical <- mean(silhouette_hierarchical[, 3])
  } else {
    mean_silhouette_hierarchical <- NA
  }
  
  # DBSCAN Clustering
  eps_value <- 0.6
  minPts_value <- 4
  dbscan_result <- dbscan(heart_numeric, eps = eps_value, minPts = minPts_value)
  
  # Visualize DBSCAN clustering results
  plot(heart_numeric$age, heart_numeric$trestbps, col = dbscan_result$cluster + 1, pch = 19,
       xlab = "Age", ylab = "Resting Blood Pressure",
       main = paste("DBSCAN Clustering for", set_name))
  
  # Silhouette Score for DBSCAN
  if (length(unique(dbscan_result$cluster)) > 1) {
    silhouette_dbscan <- silhouette(dbscan_result$cluster, dist(heart_numeric))
    mean_silhouette_dbscan <- mean(silhouette_dbscan[, 3])
  } else {
    mean_silhouette_dbscan <- NA
  }
  
  # GMM Clustering
  gmm_result <- Mclust(heart_numeric, G = num_clusters_hierarchical)
  
  # Visualize GMM clustering results
  plot(heart_numeric$age, heart_numeric$trestbps, col = gmm_result$classification, pch = 19,
       xlab = "Age", ylab = "Resting Blood Pressure",
       main = paste("GMM Clustering for", set_name))
  
  # Silhouette Score for GMM
  if (length(unique(gmm_result$classification)) > 1) {
    silhouette_gmm <- silhouette(gmm_result$classification, dist(heart_numeric))
    mean_silhouette_gmm <- mean(silhouette_gmm[, 3])
  } else {
    mean_silhouette_gmm <- NA
  }
  
  # Append results for this feature set
  results <- rbind(
    results,
    data.frame(Algorithm = "KMeans", Feature_Set = set_name, Mean_Silhouette = mean_silhouette_kmeans),
    data.frame(Algorithm = "Hierarchical", Feature_Set = set_name, Mean_Silhouette = mean_silhouette_hierarchical),
    data.frame(Algorithm = "DBSCAN", Feature_Set = set_name, Mean_Silhouette = mean_silhouette_dbscan),
    data.frame(Algorithm = "GMM", Feature_Set = set_name, Mean_Silhouette = mean_silhouette_gmm)
  )
}

# Display silhouette results for all feature sets
print(results)


