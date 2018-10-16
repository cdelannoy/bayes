# Comparison of BayesTree and bartMachine (and bcf??)
# Steps from bartMachine paper https://cran.r-project.org/web/packages/bartMachine/vignettes/bartMachine.pdf

# Libraries
library(bartMachine)
library(BayesTree)
library(tidyverse)
library(rpart)

# Set-up
data("automobile", package = "bartMachine")
automobile <- na.omit(automobile)
y <- automobile$log_price
X <- automobile
X$log_price <- NULL


# bartMachine
bm_start.time <- Sys.time()
bart_machine <- bartMachine(X, y, num_trees = 200)
bm_end.time <- Sys.time()
bm_time.taken <- bm_end.time - bm_start.time

# bayesTree
bt_start.time <- Sys.time()
bayes_tree <- bart(X, y, ntree = 200, ndpost = 1000, nskip = 250)
bt_end.time <- Sys.time()
bt_time.taken <- bt_end.time - bt_start.time

# Plotting time difference between both models
ggplot(data = NULL) +
  geom_line(aes(x = 0:bm_time.taken, y = 2), cex = 2, color = "red") +
  geom_line(aes(x = 0:bt_time.taken, y = 1), cex = 2, color = "blue") +
  scale_y_discrete(name = "", limits = c(0, 1, 2, 3), labels = c("1" = "bayesTree", "2" = "bartMachine")) +
  scale_x_continuous(name = "Running time of program (s)") +
  ggtitle("Comparison of running time of two packages \n (200 trees, 1000 draws, 250 burn-in")

# Plotting predicted vs actual for both models

bayestree_predict <- data.frame(yhat = bayes_tree$yhat.train.mean, y = bayes_tree$y) %>% 
  mutate(Package = "BayesTree")

bartMachine_predict <- data.frame(yhat = bart_machine$y_hat_train, y= bart_machine$y) %>% 
  mutate(Package = "bartMachine")

predict_compare <- bind_rows(bayestree_predict, bartMachine_predict) %>% 
  mutate_at(vars(Package), as.factor)
  
ggplot(data = predict_compare, aes(y = yhat, x = y, color = Package)) +
  geom_point() +
  geom_smooth(se = FALSE, method = "loess") +
  geom_abline() +
  ylab("Fitted values") +
  xlab("Actual values") +
  ggtitle("Fitted vs Actual values for BayesTree and bartMachine")

# R-squared for both models
sse_bt <- sum((bayes_tree$y - bayes_tree$yhat.train.mean)^2)
sst_bt <- sum((bayes_tree$y - mean(bayes_tree$y))^2)
r_sq_bt <- 1 - sse_bt/sst_bt

sse_bm <- sum((bart_machine$y - bart_machine$y_hat_train)^2)
sst_bm <- sum((bart_machine$y - mean(bart_machine$y))^2)
r_sq_bm <- 1 - sse_bm/sst_bm

cat("R Squared BayesTree:", r_sq_bt, "\n R Squared BartMachine:", r_sq_bm)

# Building regression tree to examine posterior distribution
automobile_bt <- data.frame(automobile, yhat = bayes_tree$yhat.train.mean) %>% 
  select(-log_price)
bt_tree_fit <- rpart(yhat ~ ., data = automobile_bt)
par(mar = rep(0.2, 4))
plot(bt_tree_fit, uniform = TRUE, margin = 0.1, main = "Tree from BayesTree model")
text(bt_tree_fit, all = FALSE, use.n = TRUE)

automobile_bm <- data.frame(automobile, yhat = bart_machine$y_hat_train) %>% 
  select(-log_price)
bm_tree_fit <- rpart(yhat ~ ., data = automobile_bm)
par(mar = rep(0.2, 4))
plot(bm_tree_fit, uniform = TRUE, margin = 0.1, main = "Tree from bartMachine model")
text(bm_tree_fit, all = FALSE, use.n = TRUE)
