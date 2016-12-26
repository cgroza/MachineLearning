library(class)                          # k nearest neighbours
library(nnet)                           # neural networks
library(e1071)                          # support vectorm machine
library(C50)
library(devtools)

## Fetch plot function for the nnet neural network
source_url('https://gist.githubusercontent.com/fawda123/7471137/raw/466c1474d0a505ff044412703516c34f1a4684a5/nnet_plot_update.r')

normalize = function(x)
{
  return (x - min(x)) / (max(x) - min(x))
}


## K NEAREST NEIGHBOURS FOR CLASSIFING CELLS BETWEEN MALIGNANT AND NON-MALIGNANT

# load data set and remove irrelevant "id" column
dataSet = read.csv("breast-cancer-wisconsin.data")
dataSet = dataSet[-1]
dataSet$Class = as.factor(dataSet$Class)
dataSet["BareNuclei"]  = lapply(dataSet["BareNuclei"], as.integer)
#create training and testing subsets
trainingSize = 0.2 * nrow(dataSet)
sampledTrainingRows = sample(nrow(dataSet), trainingSize)
training = dataSet[sampledTrainingRows,]
# testing excludes the training set
testing = dataSet[-sampledTrainingRows,]

## K nearest neighbours
# normalize data
trainingN = as.data.frame(lapply(training[, -10], normalize))
testingN = as.data.frame(lapply(testing[, -10], normalize))
# must exclude the labels (malignant or benign cells) before training.
knnModel = knn(trainingN, testingN, training$Class, k = 21)

# check for errors
table(testing$Class, knnModel)
## OUTPUT
##    knnModel
##       2   4
##   2 356   8
##   4  17 179
## 25 mistakes out of 560 data points. 0.9553571 accuracy.

png("knnModel.png", width = 700, height = 700)
plot(knnModel)
dev.off()

## SUPPORT VECTOR MACHINE

# train the model on the training data
svmModel = svm(Class~., training)
# run prediction on testing data that has no Class column
prediction = predict(svmModel, testing[,-10])
table(testing$Class, prediction)

png("svnModel.png", width = 700, height = 700)
plot(Class~UniformityCellShape, svmModel, data = training)
dev.off()
## OUTPUT
##    prediction
##       2   4
##   2 348  16
##   4  10 186
## 26 Mistakes out 560. 0.9535714 accuracy. Roughly the same as K nearest neighbours.


## NEURAL NETWORK CLASSIFICATION WITH ONE HIDDEN LAYER
## make a neural netwowrk with one hidden layer consisting of 10 neurons.
mapLevels = function(x)
{
  if(x > 0) 4
  else 2
}
trainingN["Class"] = training$Class     # add Class to normalized training set
nnModel <- nnet(Class~., data=training, size = 20, linear.output = FALSE, maxit = 100000)
prediction = predict(nnModel, testingN[-10])
## map output of neural network back to levels (2 and 4)
prediction = sapply(prediction, mapLevels)
table(testing$Class, prediction)

## OUTPUT
##  prediction
##     2   4
## 2 349  17
## 4  16 178
## 0.9410714 accuracy. Slightly worse than the other two models.

png("nnModel.png", width = 1000, height = 800)
plot(nnModel)
dev.off()

## DECISION TREE ALGORITHM

c50Model = C5.0(training[-10], training$Class, trials = 20)
prediction = predict(c50Model, testing[-10])
table(testing$Class, prediction)
## OUTPUT
##     2   4
## 2 357  14
## 4   9 180
## 0.9678571 accuracy. Best model so far.

## It seems that cell shape, thickness and size are major predictors.
## UniformityCellShape <= 2: 2 (80/1)
## UniformityCellShape > 2:
## :...ClumpThickness > 4: 4 (49/2)
##     ClumpThickness <= 4:
##     :...UniformityCellSize <= 5: 2 (6)
##         UniformityCellSize > 5: 4 (4)

png("c50Model.png", width = 700, height = 700)
plot(c50Model)
dev.off()
