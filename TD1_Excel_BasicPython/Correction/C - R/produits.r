#charger la librairie (préalablement installée)
library(xlsx)

#charger le fichier
m <- read.xlsx(file="Produits.xlsx",header=T,sheetIndex=1)

#si utilisation de readxl
# library(readxl)
# m <- read_excel("Produits.xlsx",sheet=1,col_names=T)

#afficher un résumé
print(summary(m))

#énumérer les colonnes à afficher
colonnes <- c("Nom","Categorie","Origine","Prix")

#1.lister ces colonnes pour Catégorie = Boissons
print(m[m$Categorie=="Boissons",colonnes])

#2.lister pour Catégorie = Boissons et Prix > 100
print(m[m$Categorie=="Boissons" & m$Prix > 100,colonnes])

#3.catégorie = boissons et origine=CEE et prix > 100
print(m[m$Categorie=="Boissons" & m$Prix > 100 & m$Origine == "CEE",colonnes])

#4.catégorie = boissons ou catégorie = condiments
print(m[m$Categorie=="Boissons" | m$Categorie=="Condiments",colonnes])

#5.(catégorie = boissons et origine = CEE) OU (catégorie = condiment)
print(m[(m$Categorie=="Boissons" & m$Origine == "CEE") | (m$Categorie=="Condiments"),colonnes])

#6.(catégorie = viande ET origine = CEE) OU (catégorie = condiment ET origine = extérieur)
print(m[(m$Categorie=="Viandes" & m$Origine == "CEE") | (m$Categorie=="Condiments" & m$Origine == "Exterieur"),colonnes])

#7.prix > 70 et prix <=100
print(m[m$Prix > 70 & m$Prix <= 100,colonnes])

#8.Lister les aliments dont le prix est compris entre 100 FF et 200 FF, et qui sont des " viandes "
print(m[m$Prix >= 100 & m$Prix <= 200 & m$Categorie=="Viandes",colonnes])

#9.Lister les 15 produits les moins chers
print(m[order(m$Prix)[1:15],colonnes])
#ou
print(head(m[order(m$Prix),colonnes],15))

#10.Calculer la moyenne de prix des boissons distribuées à lyon
print(mean(m$Prix[m$Categorie=="Boissons" & m$Ville=="Lyon"]))
#ou bien
print(tapply(X=m$Prix,INDEX=list(m$Categorie,m$Ville),mean)["Boissons","Lyon"])

#11.Quel est le nombre de produits : (catégorie = boissons et prix <100) OU (ville = lyon et stock > 20)
print(nrow(m[(m$Categorie=="Boissons" & m$Prix < 100) | (m$Ville=="Lyon" & m$Stock > 20),]))
