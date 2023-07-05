
# install dependencies
install.packages(c("Rcpp","RcppArmadillo","sp","CircStats","ellipses"))
# install moveHMM
install.packages("moveHMM")
install.packages("rgdal")
install.packages("ggmap")

library(MASS)
library(boot)
library(CircStats)
library(sp)
library(Rcpp)
library(moveHMM)
library(rgdal)
library(ggmap)

#AG004
data <- read.csv("//Users//h1n3z//Desktop//ElephantsDBSCANResearch-main//data//Movebank//moveHMM//AG004.csv")
#data <- prepData(elk_data,type="UTM",coordNames=c("location","Northing"))

head(data)
data <- prepData(data,type="LL",coordNames=c("location.long","location.lat"))


# Elevation
## standardize covariate values
#data$elevation <- (data$elevation-mean(data$elevation))/sd(data$elevation)

#Tempature
## standardize covariate values
data$stationTemp <- (data$stationTemp-mean(data$stationTemp))/sd(data$stationTemp)

## initial parameters for gamma and von Mises distributions
mu0 <- c(0.1,1) # step mean (two parameters: one for each state) 
sigma0 <- c(0.1,1) # step SD
zeromass0 <- c(0.1,0.05) # step zero-mass
stepPar0 <- c(mu0,sigma0,zeromass0)

angleMean0 <- c(pi,0) # angle mean 
kappa0 <- c(1,1) # angle concentration 
anglePar0 <- c(angleMean0,kappa0)

## call to fitting function
#m <- fitHMM(data=data,nbStates=2,stepPar0=stepPar0, anglePar0=anglePar0,formula=~elevation)
#m
#plot(m, plotCI=TRUE)

## call to fitting function with stationTemp
m <- fitHMM(data=data,nbStates=2,stepPar0=stepPar0, anglePar0=anglePar0,formula=~stationTemp)
m
#plot(m, plotCI=TRUE)

head(data)

register_google(key = "")

lldata <- data.frame(ID=data$event.id,x=data$x, y=data$y)
head(lldata)
#plotSat(lldata, zoom=8)


qmap("Etosha National Park, Africa", zoom = 8) +
  geom_path(
    aes(x = x, y = y),  colour = "blue",
    size = 1, alpha = .5,
    data = lldata, lineend = "round") 

