#vider la mémoire
rm(list=ls())
#importation du fichier
library(readxl)
D <- readxl::read_excel("covertype_100k.xlsx",sheet = "var_actives")
str(D)
#ne sélectionner que les variables (exclure numéro)
X <- D[2:ncol(D)]
summary(X)
#centrer et réduire
Z <- scale(X)
#nouvelles caractéristiques des variables
summary(Z)
#attributs de Z
attributes(Z)
#moyennes des variables originelles
moyennes <- attr(Z,"scaled:center")
moyennes
#écarts-type
ecarttype <- attr(Z,"scaled:scale")
ecarttype
#################
# K-MEANS + CAH #
#################
#k-means en 10 sous-groupes
nb_sous_groupes <- 10
set.seed(0)
km <- kmeans(Z,centers=nb_sous_groupes)
print(km)
#propriétés de l'objet
attributes(km)
#intertie totale
km$totss
#vérification - parce que R utilise la variance (n-1)
#1 parce que les variables ont été réduites => variance = 1
#ncol(Z) = p, nombre de variables
(nrow(Z)-1)*1*ncol(Z)
#ou encore
sum(colSums(Z^2))
#inertie inter-classes
km$betweenss
#part d'inertie expliquée
km$betweenss/km$totss
#effectifs par classe
km$size
#somme
sum(km$size)
#groupe d'appartenance des 10 premiers
head(km$cluster,10)
#vérification
cpt <- table(km$cluster)
cpt
#coordonnées des centres de classes
km$centers
#distance euclidienne entre centres de classes
dc <- dist(km$centers)
dc
#lancer la CAH
cah <- hclust(dc,method="ward.D2",members=km$size)
plot(cah,hang=-1)
#découpage en nb_clusters classes
nb_clusters <- 4
groupes <- cutree(cah,k=nb_clusters)
#que remarque-t-on ici ?
groupes
#comptage des correspondances
table(groupes)
#table de correspondance
table_corresp <- t(sapply(as.integer(names(groupes)),function(cl){v <- rep(0,nb_clusters); v[groupes[cl]] <- 1 ; return(v)}))
table_corresp
#effectifs
cpt_groupes <- apply(table_corresp,2,function(col){sum(col*cpt)})
cpt_groupes
#vérif.
sum(cpt_groupes)
#affecter les groupes finaux aux individus
cluster_final <- groupes[km$cluster]
cluster_final
#comptage encore
table(cluster_final)
#calcul des moyennes conditionnelles sur les var. standardisées
avg_cond <- apply(Z,2,function(x){tapply(x,cluster_final,mean)})
round(avg_cond,3)
#librairie pour graphique radar
library(fmsb)
#graphique radar
radarchart(as.data.frame(avg_cond),plwd=2,plty='solid',maxmin=FALSE,pcol=c('green','blue','red','black'))
#avec la légende
legend(x=-1.74,y=0.5,legend=1:4,col=c('green','blue','red','black'),text.col = 'grey',pch=20)
#################
# KOHONEN + CAH #
#################
#librairie pour les cartes de Kohonen
library(kohonen)
#carte de taille 10x10
set.seed(0)
carte <- kohonen::som(Z,grid=somgrid(10,10,"rectangular"))
#noeuds d'appartenance des individus
head(carte$unit.classif,20)
#effectifs par noeuds
effectifs <- table(carte$unit.classif)
effectifs
#le max.
max(effectifs)
which.max(effectifs)
#le min.
min(effectifs)
which.min(effectifs)
#fonction pour dégradé de bleu
degrade.bleu <- function(n){
  return(rgb(0,0.4,1,alpha=seq(0,1,1/n)))
}
#effectifs dans les noeuds
plot(carte,type="count",palette.name = degrade.bleu)
#codebooks de l'ensemble des noeuds
carte$codes
#pour le code des 2 premiers noeuds
carte$codes[[1]][1:2,]
#interprétation variable X4
plot(carte,type="property",property=carte$codes[[1]][,4],palette.name=degrade.bleu)
#interprétation pour les 10 variables
par(mfrow=c(4,3))
for (j in 1:ncol(Z)){
  plot(carte,type="property",property=carte$codes[[1]][,j],palette.name=degrade.bleu,main=colnames(Z)[j],cex=0.5)
}
par(mfrow=c(1,1))
#distance entre noeuds de la carte de Kohonen
dk <- dist(carte$codes[[1]])
as.matrix(dk)[1:5,1:5] #affichons une partie pour vérifier
#cah de nouveau
cahSom <- hclust(dk,method="ward.D2",members=effectifs)
plot(cahSom,hang=-1)
#découpage en nb_clusters classes again (le même pour le binome k-means + cah)
groupesSom <- cutree(cahSom,k=nb_clusters)
groupesSom
#nb de noeuds pour chaque groupe
table(groupesSom)
#code de couleur
code.couleur <- function(k){
  return(c('green','blue','red','black'))
}
#dessiner les groupes dans le repère
plot(carte,type="property",property=groupesSom,palette.name=code.couleur)
#afficher les noeuds du 2e groupe - les bleus - vérifier la correspondance
names(groupesSom)[groupesSom==2]
#effectifs
effectifsG2 <- effectifs[groupesSom==2]
effectifsG2
#codebooks de ces noeuds
codebooksG2 <- carte$codes[[1]][groupesSom==2,]
codebooksG2
#moyenne pondérée pour X5
sum(effectifsG2*codebooksG2[,"X5"])/sum(effectifsG2)
#pour X4
sum(effectifsG2*codebooksG2[,"X4"])/sum(effectifsG2)
#pour X10
sum(effectifsG2*codebooksG2[,"X10"])/sum(effectifsG2)
#cluster pour les individus
cluster_som <- groupesSom[carte$unit.classif]
table(cluster_som)
#confrontation avec la première approche
table(cluster_final,cluster_som)
