---
title: "R Notebook"
output: html_notebook
---

This is an [R Markdown](http://rmarkdown.rstudio.com) Notebook. When you execute code within the notebook, the results appear beneath the code. 

Try executing this chunk by clicking the *Run* button within the chunk or by placing your cursor inside it and pressing *Ctrl+Shift+Enter*. 

```{r}
plot(cars)
```

Add a new chunk by clicking the *Insert Chunk* button on the toolbar or by pressing *Ctrl+Alt+I*.

When you save the notebook, an HTML file containing the code and output will be saved alongside it (click the *Preview* button or press *Ctrl+Shift+K* to preview the HTML file).

The preview shows you a rendered HTML copy of the contents of the editor. Consequently, unlike *Knit*, *Preview* does not run any R code chunks. Instead, the output of the chunk when it was last run in the editor is displayed.



load("D:/Sanchita/Academics/5th sem/Data Minning/titanic.raw_preprocessed_vertical.rdata")
View(titanic.raw)
titanic.raw

str(titanic.raw)

library(arules)
rules<-apriori(titanic.raw)
inspect(rules)

# rules with rhs containing "Survived" only
rules <- apriori(titanic.raw,
  parameter = list(minlen=2, supp=0.005, conf=0.8),
  appearance = list(rhs=c("Survived=No", "Survived=Yes"),
  default="lhs"),
  control = list(verbose=F))
rules.sorted <- sort(rules, by="lift")
inspect(rules.sorted)


# find redundant rules
subset.matrix <- is.subset(rules.sorted, rules.sorted)
subset.matrix[lower.tri(subset.matrix, diag=T)] <- NA
redundant <- colSums(subset.matrix, na.rm=T) >= 1
which(redundant)

# remove redundant rules
rules.pruned <- rules.sorted[!redundant]
inspect(rules.pruned)

library(arulesViz)
plot(rules)

plot(rules, method="graph",
     control=list(nodeCol="red", edgeCol="blue", type="items"))

plot(rules, method="paracoord", control=list(reorder=TRUE))