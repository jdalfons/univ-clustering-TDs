#vider la mémoire
rm(list=ls())

#1. charger la librairie (préalablement installée)
library(xlsx)

#2. changer de répertoire courant (mettez le votre !)
#setwd("...")

#/!\charger le fichier --> TROP LENT
#m <- read.xlsx(file="Census.xlsx",header=T,sheetIndex=1)

#2.b charger au format texte - attention aux options !!!
m <- read.table("census.txt",header=T,sep="\t")

#3. nombre de variables et de lignes
print(ncol(m))
print(nrow(m))

#4. afficher un résumé
print(summary(m))

#5. proportions
#des sex = homme
print(table(m$sex)["Male"]/nrow(m))
#des classes = more
print(table(m$classe)["more"]/nrow(m))

#6. barplot
barplot(table(m$marital_status))
barplot(table(m$relationship))

#7. diagramme à secteurs
pie(table(m$marital_status))
pie(table(m$relationship))

#8. croisement classe et sex
mcs <- table(m$classe,m$sex)
print(mcs)

#proportion des more
print(sum(mcs["more",])/sum(mcs))

#proportion des more chez les hommes
print(sum(mcs["more","Male"])/sum(mcs[,"Male"]))

#proportion des more chez les femmes
print(sum(mcs["more","Female"])/sum(mcs[,"Female"]))

#9. khi-2 classe vs. sex
kcs <- chisq.test(m$classe,m$sex,correct=FALSE)
print(kcs)

#V de Cramer
v <- sqrt(kcs$statistic/(nrow(m)*(min(nrow(mcs),ncol(mcs))-1)))
print(v)

#10. package lsr
library(lsr)
print(cramersV(m$classe,m$sex,correct=FALSE))

#11. relationship vs. marital status
mrm <- table(m$relationship,m$marital_status)
print(mrm)

#pour chaque relationship
print(apply(mrm,1,function(x){levels(m$marital_status)[which.max(x)]}))

#pour chaque marital status
print(apply(mrm,2,function(x){levels(m$relationship)[which.max(x)]}))

#12. moyenne et écart-type de age
mean(m$age)
sd(m$age)

#13. centrer et réduire
cr.age <- scale(m$age)
mean(cr.age)
sd(cr.age)

#14. médiane et quartiles
median(m$age)
quantile(m$age,probs=c(0.25,0.75))

#15. boxplot - de nombreuses valeurs extrêmes (élevées)
boxplot(m$age)

#16. histogramme
hist(m$age)

#17. corrélation âge et hours_per_week => 0.07, pas grand chose
print(cor(m$age,m$hours_per_week))

#on se rend compte qu'il n'y a rien du tout
plot(m$age,m$hours_per_week)

#18. boxplot conditionnel
boxplot(m$age ~ m$relationship,cex.axis=0.75)

#19. moyennes conditionnelles
mcah <- tapply(m$age,m$relationship,mean)
print(mcah)

#20. nombre de personnes travaillant pour le gouvernement
index <- grep("gov",levels(m$workclass))
sum(table(m$workclass)[index])

#21. niveau d'éducation

#comptage pour chaque niveau
comptage.edu <- table(m$education)
print(comptage.edu)

#niveau preschool
print(sum(comptage.edu["Preschool"])/nrow(m))

#11. jusqu'au niveau bachelors

#if faut recenser les niveaux dans l'ordre
niveau <- c("Preschool", "1st-4th", "5th-6th", "7th-8th", "9th", "10th", "11th", "12th", "HS-grad", "Some-college", "Assoc-voc", "Assoc-acdm", "Bachelors", "Masters", "Prof-school", "Doctorate")

print(sum(comptage.edu[niveau[1:13]])/nrow(m))
