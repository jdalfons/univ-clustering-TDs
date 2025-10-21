# -*- coding: utf-8 -*-

#importation
import os
os.chdir("C:/Users/ricco/Desktop/demo")

import pandas
df = pandas.read_csv("export_clus.csv",sep=";")
df.info()

#metrique scikit-learn
from sklearn import metrics

#information mutuelle
metrics.mutual_info_score(df.lbTrue,df.lbClus)

#information mutuelle normalisée
metrics.normalized_mutual_info_score(df.lbTrue,df.lbClus)

#score d'homogénéité
metrics.homogeneity_score(df.lbTrue,df.lbClus)

#score de complétude
metrics.completeness_score(df.lbTrue,df.lbClus)

#v-measure
metrics.v_measure_score(df.lbTrue,df.lbClus,beta=1)
