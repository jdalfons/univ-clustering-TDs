# -*- coding: utf-8 -*-

#modification du dossier par défaut
import os
os.chdir('C:/Universite/Seances/Seances-2022-2023/M1 INFO - Clustering/TD_1/TD_1_B')
#importation du fichier
import pandas
df = pandas.read_excel("produits.xlsx")
#information
print(df.info())
#10 premières lignes
print(df.head(10))
#liste des colonnes
colonnes = ['Nom','Categorie','Origine','Prix']
#1. Boissons
print(df.loc[df.Categorie=='Boissons',colonnes])
#ou bien
print(df.loc[df['Categorie']=='Boissons',colonnes])
#2. Boissons et prix > 100
print(df.loc[(df.Categorie=='Boissons') & (df.Prix > 100),colonnes])
#3. Catégorie = boissons et origine=CEE et prix > 100
print(df.loc[(df.Categorie=='Boissons') & (df.Prix > 100) & (df.Origine=='CEE'),colonnes])
#4. catégorie = boissons ou catégorie = condiments
print(df.loc[df.Categorie.isin(['Boissons','Condiments']),colonnes])
#5.(catégorie = boissons et origine = CEE) OU (catégorie = condiment)
print(df.loc[((df.Categorie=='Boissons') & (df.Origine=='CEE')) | ((df.Categorie=='Condiments')),colonnes])
#6.(catégorie = viande ET origine = CEE) OU (catégorie = condiment ET origine = extérieur)
print(df.loc[((df.Categorie=='Viandes') & (df.Origine=='CEE')) | ((df.Categorie=='Condiments') & (df.Origine=='Exterieur')),colonnes])
#7.prix > 70 et prix <=100
print(df.loc[(df.Prix > 70) & (df.Prix <= 100),colonnes])
#8.Lister les aliments dont le prix est compris entre 100 FF et 200 FF, et qui sont des « viandes »
print(df.loc[(df.Prix >= 100) & (df.Prix <= 200) & (df.Categorie == 'Viandes'),colonnes])
#9.Lister les 15 produits les moins chers 
print(df[colonnes].sort_values(by='Prix').head(15))
#10.Calculer la moyenne de prix des boissons distribuées à Lyon 
print(pandas.pivot_table(df,values=['Prix'],index=['Ville','Categorie'],aggfunc=pandas.Series.mean))
#pour n'afficher que Lyon et Boissons
print(pandas.pivot_table(df,values=['Prix'],index=['Ville','Categorie'],aggfunc=pandas.Series.mean).loc['Lyon','Boissons'])
#autre approche avec groupby + get_group
g = df.groupby(['Ville','Categorie'])
g.get_group(('Lyon','Boissons'))['Prix'].mean()
#11.Quels sont les 5 produits les moins chers vendus à Lyon ?
print(df.loc[df.Ville=='Lyon',colonnes].sort_values(by='Prix').head(5))
