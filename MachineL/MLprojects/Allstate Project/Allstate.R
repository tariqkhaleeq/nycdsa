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
x= model.matrix(loss~., train[,-1])[,-1]
y= train$loss

train.index=sample(1:nrow(x), nrow(x)/2)
test.index=(-train.index)
y.test=y[test.index]

lasso.train<-glmnet(x[train.index,],y[train.index], alpha =1,family = "gaussian")
lasso.mod<-predict(lasso.train,newx=x[test.index,],s=20)
MSE.lasso = mean((lasso.mod - y.test)^2)
lasso.coef<-predict(lasso.train, type = "coefficients", s=20)

#also need the best CV lambda

#cv.lasso.train = cv.glmnet(x[train.index,],y[train.index], alpha=1, family = "gaussian",type.measure="mse" )
#best.lambda = cv.lasso.train$lambda.min
#final.model<-predict(cv.lasso.train, s=cv.lasso.train$lambda.1se, newx=x[test.index,])

# Ridge
ridge.train<-glmnet(x[train.index,],y[train.index], alpha =0,lambda=grid)
plot(ridge.train$lambda)
ridge.mod<-predict(ridge.train,newx=x[test.index,],s=10)
MSE.ridge = mean((ridge.mod - y.test)^2)

#ridge.train<-cv.glmnet(x[train.index,],y[train.index], alpha =0)
#best.lambda.r = ridge.train$lambda.min
#ridge.mod<-predict(ridge.train,newx=x[test.index,],s=best.lambda.r)
#MSE.ridge = mean((ridge.mod - y.test)^2)

#elastic net
enet.train<-glmnet(x[train.index,],y[train.index], alpha =0.5,lambda=grid)
best.lambda.e = enet.train$lambda.min
enet.mod<-predict(enet.train, newx=x[test.index,], s=10)
MSE.enet = mean((enet.mod - y.test)^2)

#https://stats.stackexchange.com/questions/72251/an-example-lasso-regression-using-glmnet-for-binary-outcome
#fit.elnet <- glmnet(x.train, y.train, family="gaussian", alpha=.5)
#http://www4.stat.ncsu.edu/~post/josh/LASSO_Ridge_Elastic_Net_-_Examples.html <-*****

############################
############################
fit.lasso <- glmnet(x[train.index,],y[train.index], family="gaussian", alpha=1)
fit.ridge <- glmnet(x[train.index,],y[train.index], family="gaussian", alpha=0)
fit.elnet <- glmnet(x[train.index,],y[train.index], family="gaussian", alpha=.5)

fit.lasso.cv <- cv.glmnet(x[train.index,],y[train.index], type.measure="mse", alpha=1, 
                          family="gaussian")
fit.ridge.cv <- cv.glmnet(x[train.index,],y[train.index], type.measure="mse", alpha=0,
                          family="gaussian")
fit.elnet.cv <- cv.glmnet(x[train.index,],y[train.index], type.measure="mse", alpha=.5,
                          family="gaussian")

par(mfrow=c(3,2))
plot(fit.lasso, xvar="lambda")
plot(fit.lasso.cv, main="LASSO")

plot(fit.ridge, xvar="lambda")
plot(fit.ridge.cv, main="Ridge")

plot(fit.elnet, xvar="lambda")
plot(fit.elnet.cv, main="Elastic")

yhat0<-predict(fit.ridge.cv, s = fit.ridge.cv$lambda.1se, newx=x[test.index,])
yhat0.5<-predict(fit.elnet.cv, s = fit.elnet.cv$lambda.1se, newx=x[test.index,])
yhat1<-predict(fit.lasso.cv, s = fit.lasso.cv$lambda.1se, newx=x[test.index,])

mean0<-mean((y.test-yhat0)^2)
mean0.5<-mean((y.test-yhat0.5)^2)
mean1<-mean((y.test-yhat1)^2)
############################
############################

#test train and test test
# see what is the difference between the two models in terms of MSE.



###########################
###########################
###########################
# PCA
library(psych)
# need dummified version of the data
#train.dummy<-dummy(train)
# Problem seems to be with factors. Thats why it gave that error that x should be numeric.
# newdata_float<-as.integer(unlist(newdata))
fa.parallel(as.matrix(newdata_float), fa="pc",n.iter=100)
pc.train<-principal(train.dummy, nfactors =2, rotate ="none")
#`Error in cor(r, use = "pairwise") : 'x' must be numeric``

# XGboost
library(xgboost)

n <- 100    # Number of observations
p <- 50     # Number of predictors included in model
CovMatrix <- outer(1:p, 1:p, function(x,y) {.7^abs(x-y)})
foox <- mvrnorm(n, rep(0,p), CovMatrix)
fooy <- 10 * apply(foox[, 1:2], 1, sum) + 
  5 * apply(foox[, 3:4], 1, sum) +
  apply(foox[, 5:14], 1, sum) +
  rnorm(n)

