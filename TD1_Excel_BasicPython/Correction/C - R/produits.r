#charger la librairie (pr�alablement install�e)
library(xlsx)

#charger le fichier
m <- read.xlsx(file="Produits.xlsx",header=T,sheetIndex=1)

#si utilisation de readxl
# library(readxl)
# m <- read_excel("Produits.xlsx",sheet=1,col_names=T)

#afficher un r�sum�
print(summary(m))

#�num�rer les colonnes � afficher
colonnes <- c("Nom","Categorie","Origine","Prix")

#1.lister ces colonnes pour Cat�gorie = Boissons
print(m[m$Categorie=="Boissons",colonnes])

#2.lister pour Cat�gorie = Boissons et Prix > 100
print(m[m$Categorie=="Boissons" & m$Prix > 100,colonnes])

#3.cat�gorie = boissons et origine=CEE et prix > 100
print(m[m$Categorie=="Boissons" & m$Prix > 100 & m$Origine == "CEE",colonnes])

#4.cat�gorie = boissons ou cat�gorie = condiments
print(m[m$Categorie=="Boissons" | m$Categorie=="Condiments",colonnes])

#5.(cat�gorie = boissons et origine = CEE) OU (cat�gorie = condiment)
print(m[(m$Categorie=="Boissons" & m$Origine == "CEE") | (m$Categorie=="Condiments"),colonnes])

#6.(cat�gorie = viande ET origine = CEE) OU (cat�gorie = condiment ET origine = ext�rieur)
print(m[(m$Categorie=="Viandes" & m$Origine == "CEE") | (m$Categorie=="Condiments" & m$Origine == "Exterieur"),colonnes])

#7.prix > 70 et prix <=100
print(m[m$Prix > 70 & m$Prix <= 100,colonnes])

#8.Lister les aliments dont le prix est compris entre 100 FF et 200 FF, et qui sont des " viandes "
print(m[m$Prix >= 100 & m$Prix <= 200 & m$Categorie=="Viandes",colonnes])

#9.Lister les 15 produits les moins chers
print(m[order(m$Prix)[1:15],colonnes])
#ou
print(head(m[order(m$Prix),colonnes],15))

#10.Calculer la moyenne de prix des boissons distribu�es � lyon
print(mean(m$Prix[m$Categorie=="Boissons" & m$Ville=="Lyon"]))
#ou bien
print(tapply(X=m$Prix,INDEX=list(m$Categorie,m$Ville),mean)["Boissons","Lyon"])

#11.Quel est le nombre de produits : (cat�gorie = boissons et prix <100) OU (ville = lyon et stock > 20)
print(nrow(m[(m$Categorie=="Boissons" & m$Prix < 100) | (m$Ville=="Lyon" & m$Stock > 20),]))
