# Goal
This repository illustrates my attempts to train various machine learning
algorithms on the famous wisconsin breast cancer data set. Successful fitted models
with +90% accuracy include:
+ K Nearest Neighbours
+ Support Vector Machines
+ Single Layer Neural Network (surprisingly the least accurate)
+ C5.0 Decision Tree

## K Nearest Neighbours
| Matches |     2 |   4 |
|     --- | ----- | --- |
|       2 |   356 |   8 |
|       4 |    17 | 179 |

25 mistakes out of 560 data points. 0.9553571 accuracy.

![Distribution of diagnostics in training set.](./knnModel.png)
## Support Vector Machine

| Matches |   2 |   4 |
|     --- | --- |  -- |
|       2 | 348 |  16 |
|       4 |  10 | 186 |

26 Mistakes out 560. 0.9535714 accuracy. Roughly the same as K nearest neighbours.

Note that this graph only shows the division as a function of only 1 factor. In
reality, the division is an n-dimensional hyperplane.

![Diagnostic vs Cell Shape Uniformity](./svnModel.png)

## Neural Network
| Matches |   2 |     4 |
|     --- | --- | ----- |
|       2 | 349 |    17 |
|       4 |  16 |   178 |

0.9410714 accuracy. Slightly worse than the other two models.

![Topology of Neural Network](./nnModel.png)

## C5.0 Decision Tree

| Matches |   2 |   4 |
|     --- | --- | --- |
|       2 | 357 |  14 |
|       4 |   9 | 180 |
0.9678571 accuracy. Best model so far.

![Decision Tree Graph](./c50Model.png)
## Author
Cristian Groza
