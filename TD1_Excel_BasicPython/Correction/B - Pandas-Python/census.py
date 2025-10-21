# -*- coding: utf-8 -*-

#modification du dossier par défaut
import os
os.chdir('C:/Universite/Seances/Seances-2022-2023/M1 INFO - Clustering/TD_1/TD_1_B')

#importation du fichier
import pandas
df = pandas.read_excel("census.xlsx")

#information
print(df.info())

#10 premières lignes
print(df.head(10))

#description des non-numériques
print(df.describe(include=['object']))

#description des numériques
print(df.describe(exclude=['object']))

#proportions selon le sexe
print(df['sex'].value_counts()/df.shape[0])
#ou bien
print(df['sex'].value_counts(normalize=True))

#proportion selon la classe
print(df['classe'].value_counts()/df.shape[0])

#barplot de marital_status
df['marital_status'].value_counts().plot.bar()

#idem pour relationship
df['relationship'].value_counts().plot.bar()

#pie de marital_status
df['marital_status'].value_counts().plot.pie()

#idem pour relationship
df['relationship'].value_counts().plot.pie()

#proportion des more parmi les hommes et les femmes
print(pandas.crosstab(index=df['classe'],columns=df['sex'],normalize='columns'))

#relationship vs. marital_status
m = pandas.crosstab(index=df['marital_status'],columns=df['relationship'])
print(m)

#chercher l'ID de la ligne correspondant au maximum
#dans chaque colonne
#axis = 0
index = m.idxmax(axis=0)
print(index)

#calcul du Khi-2
from scipy.stats import chi2_contingency
khi2,_,_,_ = chi2_contingency(m)
print(khi2)

#calcul du V de Cramer
import math
v = math.sqrt(khi2/(df.shape[0]*(min(m.shape)-1)))
print(v)

#moyenne de l'âge
print(df.age.mean())

#ecart-type
print(df.age.std())

#variable centrée et réduite
z = (df.age - df.age.mean())/df.age.std()

#vérifications
print(z.mean())
print(z.std())

#premier et troisième quartile
print(df.age.quantile([0.25,0.75]))

#boxplot
df.boxplot(column="age")

#histogramme de l'âge
df.hist(column='age')

#corrélation entre age et hours per week
print(df.age.corr(df.hours_per_week))

#graphique nuage de points
df.plot.scatter(x='age',y='hours_per_week')

#boxplot age selon relationship
df.boxplot(column="age",by="relationship")

#moyennes conditionnelles
yb_k = df.pivot_table(index=['relationship'],values=['age'],aggfunc=pandas.Series.mean) 
print(yb_k)

#librairie Numpy
import numpy

#SCT
yb = df.age.mean()
SCT = numpy.sum((df.age.values-yb)**2)
print(SCT)

#effectifs
n_k = df.pivot_table(index=['relationship'],values=['age'],aggfunc=pandas.Series.count)
print(n_k)

#SCE
SCE = numpy.sum(n_k.values[:,0]*(yb_k.values[:,0] - yb)**2)
print(SCE)

#rapport de corrélation
print("Carré du rapport de correlation = ", SCE/SCT)

#recodage du niveau d'instruction
instruction = df.education.isin(["Bachelors","Masters", "Prof-school", "Doctorate"]).astype('int')
print(instruction.value_counts())

#croisement avec classe
m2 = pandas.crosstab(instruction,df['classe'],normalize='index')
print(m2)

#age moyen des personnes instruites
mEduPlus = df.loc[instruction==1,'age'].mean()
print(mEduPlus)

#chez les autres
mEduMoins = df.loc[instruction==0,'age'].mean()
print(mEduMoins)

#fonction pour test de comparaison de moyennes
from scipy.stats import ttest_ind

#test - hyp. de variances égales
print(ttest_ind(df.loc[instruction==1,'age'].values,df.loc[instruction==0,'age'].values,equal_var = True))
