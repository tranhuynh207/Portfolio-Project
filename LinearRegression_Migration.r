rm(list = ls())
#Survey Methods Project Work
#Data on Migration
#Source OECD

#Variables
#Y=Nbr of Work Migrant
#X1=Average Annual Wage 
#X2=Poverty Rate Working Pop
#X3=Unemployement Rate Foreign
#X4=Working Pop
#X5=Income Inequality (GINI)

#Read the dataset

setwd("/Users/Admin/Project_Work/Migration/Data")

ItMig<-read.csv("Dataset_Mig1.csv", header=T, sep=",")
ItMig

#Descriptive Statiistics
dim(ItMig)
str(ItMig)
summary(ItMig)
plot(Work_Migrt_Nbr~Year,data=ItMig)

# X variables correlation with Y
plot(Work_Migrt_Nbr~Av_An_Wage_Euro + Pov_Rt_WP + Unemp_Rt + Wking_Pop + Income_Ineq, data = ItMig)
Corr1<-cor(ItMig$Work_Migrt_Nbr,ItMig$Av_An_Wage_Euro)
Corr2<-cor(ItMig$Work_Migrt_Nbr,ItMig$Pov_Rt_WP)
Corr3<-cor(ItMig$Work_Migrt_Nbr,ItMig$Unemp_Rt)
Corr4<-cor(ItMig$Work_Migrt_Nbr,ItMig$Wking_Pop)
Corr5<-cor(ItMig$Work_Migrt_Nbr,ItMig$Income_Ineq)

#Simple Linear Regression Model
MigLM<-lm(Work_Migrt_Nbr~Av_An_Wage_Euro + Unemp_Rt + Income_Ineq, data = ItMig)
MigLM
summary(MigLM)

#Evaluating the model validity
par(mfrow=c(2,2))
plot(MigLM)
par(mfrow=c(1,1))


#Results
#"Average Annual Wage in Euro" and "Income Inequality"  affect significantly the number of work migrant in Italy. 
#"Poverty rate", "Working pop" and "Unemployement rate" have no significant effect on the number of migrant to Italy. 
