#Author: Suryateja Chalapati

#Importing required libraries
rm(list=ls())
library(rio)
library(moments)
library(dplyr)
library(MASS)

#Setting the working directory and importing the dataset
setwd("C:/Users/surya/Downloads")

df = import("Crime Data.xlsx", sheet = "Sheet1")
colnames(df)=tolower(make.names(colnames(df)))
attach(df)

#Setting seed and data sampling
set.seed(36991670)
data_sample = data.frame(df[sample(1:nrow(df), 12, replace = FALSE),])
data_sample <- data_sample %>% rename(crimes = reported.crimes.per.million, funding=police.funding.dols.per.resident) 
attach(data_sample)

#Analysis_1
cor(data_sample$funding,data_sample$crimes)

#Analysis_2
#Scatter plot
plot(funding, crimes, main="Scatterplot of Crimes & Funding",
     xlab="Funding", ylab="Crimes", pch=19, xlim=c(0,100),ylim=c(300,2000)) 

#Analysis_3
#Simple Regression
lin_reg=lm(crimes~funding,data=data_sample)
summary(data_sample$crimes)
summary(lin_reg)
confint(lin_reg)

plot(data_sample$funding,data_sample$crimes,
     pch=19,main="Funding based on the crimes per 100,000",xlim=c(0,100),ylim=c(300,2000),xlab="Funding",ylab="Crimes")
abline(lin_reg,col="red",lwd=3)

#Linearity
plot(data_sample$crimes,lin_reg$fitted.values,pch=19,main="Police Actual v. Fitted Values")
abline(0,1,col="red",lwd=3)

#Independence
plot(lin_reg$fitted.values,rstandard(lin_reg),pch=19,main="The residuals and deviation")

#Normality
qqnorm(lin_reg$residuals,pch=19,main="Normality Plot")
qqline(lin_reg$residuals,col="red",lwd=3)

#Equality of Variances
plot(lin_reg$fitted.values,lin_reg$residuals,pch=19,main="Linear Residuals")
abline(0,0,col="red",lwd=3)

#Price prediction using Regression Equation
predi=data.frame(funding = 41)
predict(lin_reg, predi, interval = "prediction")


#model_equation(lin_reg, digits = 3, trim = TRUE)
cor(data_sample$crimes,lin_reg$fitted.values)
