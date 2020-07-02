# #hdbscan
# library(dbscan)
#
# library("dbscan")
# data("moons")
# plot(moons, pch=20)
# cl <- hdbscan(moons, minPts = 5)
# cl
# plot(moons, col=cl$cluster+1, pch=20)
# cl$hc
# plot(cl$hc, main="HDBSCAN* Hierarchy")
#
# library(dendextend)
# dend <- as.dendrogram(cl$hc)
# labels_colors(dend)
# colors_to_use <- colors_to_use[order.dendrogram(dend)]
# colors_to_use
# dend <- color_labels(dend, k = 3)
# plot(dend)
#
# cl <- hdbscan(moons, minPts = 5)
# check <- rep(F, nrow(moons)-1)
# core_dist <- kNNdist(moons, k=5-1)[,5-1]
#
# ## cutree doesn't distinguish noise as 0, so we make a new method to do it manually
# cut_tree <- function(hcl, eps, core_dist){
#   cuts <- unname(cutree(hcl, h=eps))
#   cuts[which(core_dist > eps)] <- 0 # Use core distance to distinguish noise
#   cuts
# }
#
# eps_values <- sort(cl$hc$height, decreasing = T)+.Machine$double.eps ## Machine eps for consistency between cuts
# for (i in 1:length(eps_values)) {
#   cut_cl <- cut_tree(cl$hc, eps_values[i], core_dist)
#   dbscan_cl <- dbscan(moons, eps = eps_values[i], minPts = 5, borderPoints = F) # DBSCAN* doesn't include border points
#
#   ## Use run length encoding as an ID-independent way to check ordering
#   check[i] <- (all.equal(rle(cut_cl)$lengths, rle(dbscan_cl$cluster)$lengths) == "TRUE")
# }
# print(all(check == T))
