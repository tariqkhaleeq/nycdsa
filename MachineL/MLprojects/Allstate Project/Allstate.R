### playing with Allstate data
library(dummy)
library(glmnet)
train<-read.csv("~/nycdsa/MachineL/MLprojects/Allstate Project/train.csv")
test<-read.csv("~/nycdsa/MachineL/MLprojects/Allstate Project/test.csv")
 
#Feature engineering of train and test data.
#use dummy to 
cata.train<-train[,2:117]
cont.train<-train[,118:132] # keep in mind the test set is 131
dt<-dummy(cata.train)
newdata<-cbind(dt,cont.train)

cata.test<-test[,2:117]
cont.test<-test[,118:131]
dt.test<-dummy(cata.test)
newdata.test<-cbind(dt.test,cont.test)

### REGRESSION

## multiple regression

cont.train.lm<-lm(loss~.,train[,c(-1,-90,-93,-97,-100,-104,-107,-110,-111,-112,-114,-117)])
# Most values were coerced into NAs. This is very weird.
# There are errors p values that are very signifcant. P<0.01
#Residual standard error: 1998.538 on 187352 degrees of freedom
#Multiple R-squared:  0.5288334,	Adjusted R-squared:  0.5264066 
#F-statistic: 217.9091 on 965 and 187352 DF,  p-value: < 0.00000000000000022204

model.lm<-predict(cont.train.lm, test[,c(-1,-90,-93,-97,-100,-104,-107,-110,-111,-112,-114,-117)])
#MSE?

model.data<-data.frame(id=test$id,loss=model.lm, stringsAsFactors=FALSE)

write.csv(model.data,"~/allstate-linearmodel.csv",row.names=FALSE, quote=FALSE)
# Kaggle says the model shoul have 125546 rows -> when I predict the model, the length of the 
# model.lm turns to 188318

# No nas in model.lm

# Lasso
grid = 10^seq(5, -2, length = 100)
x= model.matrix(~., train[,-1])[,-1]
y= train$loss
lasso.train<-glmnet(x,y, alpha =0,family = "gaussian")
foo<-predict(lasso.train,newx=x.test)
#also need the best CV lambda
cv.lasso.train = cv.glmnet(x,y, alpha=1, family = "gaussian",type.measure="mse" )
best.lambda = cv.lasso.train$lambda.min

x.test=model.matrix(~.,test[,-1])[,-1]

final.model<-predict(cv.lasso.train, s=cv.lasso.train$lambda.1se, newx=x.test)

#elastic net

#https://stats.stackexchange.com/questions/72251/an-example-lasso-regression-using-glmnet-for-binary-outcome
#fit.elnet <- glmnet(x.train, y.train, family="gaussian", alpha=.5)
#http://www4.stat.ncsu.edu/~post/josh/LASSO_Ridge_Elastic_Net_-_Examples.html <-*****


# PCA
library(psych)
# need dummified version of the data
pc.train<-principal(newdata, nfactors =2, rotate ="none")
#`Error in cor(r, use = "pairwise") : 'x' must be numeric``

# XGboost
library(xgboost)

