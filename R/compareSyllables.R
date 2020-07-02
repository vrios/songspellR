# compareSyllables <- function(x,y) {
#' compares two sylables, returning the dtw distance
#' receives two selection tables and compares
library(seewave)
library(tuneR)
library(magrittr)
library(purrr)
library(dtw)
source("R/pad.to.compare.R")
source("R/findSyllables.R")
source("R/waveCutter.R")

library(songspellR)
songs = findSyllables(plotSyllables  = T,dir(here::here("inst/extdata"), full.names = TRUE,include.dirs = T), samplingRate = 44100)
syls = waveCutter(songs, write.specs = F)
syls <- syls$waves[1:33]
syls2 <- lapply(syls, readWave)
envs <- lapply(syls2, env, msmooth = c(50, 0), plot = FALSE)


### from http://dtw.r-forge.r-project.org/
dtwOmitNA <- function(x, y) {
  a <- na.omit(x)
  b <- na.omit(y)
  return(dtw::dtw(a, b, distance.only = TRUE, open.end = TRUE)$normalizedDistance)
}
## create a new entry in the registry with two aliases
pr_DB$set_entry(FUN = dtwOmitNA, names = c("dtwOmitNA"))
# d<-dist(k, method = "dtwOmitNA")

k <- pad.to.compare(envs)
# k[5,]==syl5.env
d <- dist(k, method = "dtwOmitNA")
min(d)
plot(d)
cc <- hclust(d, method = "ward.D2")
plot(cc)
library(dbscan)
res <- optics(d, minPts = 3)
res <- extractXi(res, xi = 0.05)
res = extractDBSCAN(res, eps_cl = res$eps)
res
plot(res)
res
res.dendo=as.dendrogram(res)
plot(res.dendo)
plot(res.dendo)

res2=hdbscan(d, minPts = 2)
hc=res2$hc
clus=res2$cluster
clus
syls3=data.frame("syllable"=syls,"cluster"=clus, id = 1:length(syls))


plot(res2 )
plot(hc,hang = -1)
hcd <- as.dendrogram(hc)
# Default plot
nodePar <- list(lab.cex = 0.6, pch = c(NA, 19),
                cex = 0.7, col =list(col=syls3$cluster))
x11();plot(hcd, type = "rectangle", nodePar=nodePar,horiz = TRUE)


library("ape")
install.packages('dendextend')
library(dendextend)
res2$cluster
plot(as.phylo(res2$hc))
clust.cut=cutree(hc, max(res2$cluster ))
x11();plot(as.phylo(hc), tip.color = clust.cut)

clustered= data.frame(1:33,res2$cluster)
dend <- as.dendrogram(hc)
library(ggplot2)
ggd1 <- as.ggdend(dend)
ggplot(ggd1)



library("dbscan")
data("moons")
plot(moons, pch=20)
cl <- hdbscan(moons, minPts = 5)
cl
plot(cl,show_flat = T)
data("DS3")
plot(DS3, pch=20, cex=0.25)
cl2 <- hdbscan(DS3, minPts = 25)
cl2
plot(DS3, col=cl2$cluster+1,
     pch=ifelse(cl2$cluster == 0, 8, 1), # Mark noise as star
     cex=ifelse(cl2$cluster == 0, 0.5, 0.75), # Decrease size of noise
     xlab=NA, ylab=NA)
colors <- sapply(1:length(cl2$cluster),
                 function(i) adjustcolor(palette()[(cl2$cluster+1)[i]], alpha.f = cl2$membership_prob[i]))
points(DS3, col=colors, pch=20)
plot(cl2, scale = 3, gradient = c("purple", "orange", "red"), show_flat = T)

plot(DS3, col=cl2$cluster+1,
     pch=ifelse(cl2$cluster == 0, 8, 1), # Mark noise as star
     cex=ifelse(cl2$cluster == 0, 0.5, 0.75), # Decrease size of noise
     xlab=NA, ylab=NA)
colors <- sapply(1:length(cl2$cluster),
                 function(i) adjustcolor(palette()[(cl2$cluster+1)[i]], alpha.f = cl2$membership_prob[i]))
points(DS3, col=colors, pch=20)
