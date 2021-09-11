# compareSyllables <- function(x,y) {
#' compares two sylables, returning the dtw distance
#' receives two selection tables and compares
library(seewave)
library(tuneR)
library(dtw)
songs = findSyllables(plotSyllables  = T,dir(here::here("inst/extdata"), full.names = TRUE,include.dirs = T), samplingRate = 44100)
syls = waveCutter(songs, write.specs = F)
sylsa=syls
# syls <- syls$wave.files[1:33]
####syls2 <- lapply(syls, readWave)
syls2<-syls$waves[1:33]
envs <- lapply(syls2, env, msmooth = c(50, 0), plot = FALSE)


## create a new entry in the registry with two aliases, to permit use of dtw as a distance metric
pr_DB$set_entry(FUN = dtwOmitNA, names = c("dtwOmitNA"))
# d<-dist(k, method = "dtwOmitNA")

k <- pad.to.compare(envs) # to compare different lengths


d <- dist(k, method = "dtwOmitNA")
min(d)
plot(d)

cc <- hclust(d, method = "ward.D2")
cc.labels= cutree(cc,k=6)
cc.labels
x11();plot(cc)

library(dbscan)

###classify syllables using hdbscan
res2=hdbscan(d, minPts = 3)
hc=res2$hc
clus=res2$cluster
clus

syls3=data.frame("syllable"=sylsa$selections$selec[1:33],"cluster"=clus, id = 1:length(syls))
plotSyllables(syls = sylsa$selections,labels = clus)


