# Pacotes ------------------------------------------------------------------

library(tidymodels)
library(ISLR)
library(tidyverse)
library(modeldata)
library(pROC)
library(vip)
library(glmnet)
library(gt)

# Bases de dados ----------------------------------------------------------

data("credit_data")
help(credit_data)
glimpse(credit_data) # German Risk

credit_test %>% count(Status)

# Base de treino e teste --------------------------------------------------

set.seed(1)
credit_initial_split <- initial_split(credit_data, strata = "Status", prop = 0.7)

credit_train <- training(credit_initial_split)
credit_test  <- testing(credit_initial_split)

# Exploratória ------------------------------------------------------------

skimr::skim(credit_train)
visdat::vis_miss(credit_train)
credit_train %>%
  select(where(is.numeric)) %>%
  cor(use = "pairwise.complete.obs") %>%
  corrplot::corrplot()

# Data prep ---------------------------------------------------------------

credit_recipe <- recipe(Status ~ ., data = credit_train) %>%
  step_normalize(all_numeric_predictors()) %>%
  step_novel(all_nominal_predictors()) %>%
  
  step_indicate_na(Income, Assets, Debt) %>%
  step_impute_linear(Income, Assets, Debt, impute_with = imp_vars(Expenses)) %>%
  
  #step_impute_mode(all_nominal_predictors()) %>%
  step_unknown(all_nominal_predictors()) %>%
  
  step_zv(all_predictors()) %>%
  step_poly(all_numeric_predictors(), -starts_with("na_ind"), degree = 9) %>%
  
  step_dummy(all_nominal_predictors())


glimpse(bake(prep(credit_recipe), new_data = NULL))
#visdat::vis_miss(bake(prep(credit_recipe), new_data = NULL))

# Modelo  -----------------------------------------------------------------

credit_lr_model <- logistic_reg(penalty = tune(), mixture = 1) %>%
  set_mode("classification") %>%
  set_engine("glmnet")

# Workflow ----------------------------------------------------------------

credit_wf <- workflow() %>%
  add_model(credit_lr_model) %>%
  add_recipe(credit_recipe)


# Cross-Validation e Grid --------------------------------------------------------

credit_folds <- vfold_cv(credit_train, v = 5, strata = "Status")

grid <- grid_regular(
  penalty(range = c(-4, -1)),
  levels = 20
)

# Tune --------------------------------------------------------------------


credit_lr_tune_grid <- tune_grid(
  credit_wf,
  resamples = credit_folds,
  grid = grid,
  metrics = metric_set(
    mn_log_loss, #binary cross entropy
    accuracy,
    roc_auc,
    kap # KAPPA
    # precision,
    # recall,
    # f_meas,
  )
)

autoplot(credit_lr_tune_grid)

# minha versão do autoplot()
collect_metrics(credit_lr_tune_grid)

collect_metrics(credit_lr_tune_grid) %>%
  ggplot(aes(x = penalty, y = mean)) +
  geom_point() +
  geom_ribbon(aes(ymin = mean - std_err, ymax = mean + std_err), alpha = 0.1) +
  facet_wrap(~.metric, ncol = 2, scales = "free_y") +
  scale_x_log10()

show_best(credit_lr_tune_grid, metric = "roc_auc")


# Desempenho do modelo final ----------------------------------------------

credit_lr_best_params <- select_best(credit_lr_tune_grid, "roc_auc")
credit_wf <- credit_wf %>% finalize_workflow(credit_lr_best_params)

credit_lr_tune_grid %>%
  collect_metrics() %>%
  filter(penalty == credit_lr_best_params$penalty)

credit_lr_last_fit <- last_fit(
  credit_wf,
  credit_initial_split
)

collect_metrics(credit_lr_last_fit)

# Variáveis importantes
credit_lr_last_fit_model <- credit_lr_last_fit$.workflow[[1]]$fit$fit
coef(credit_lr_last_fit_model$fit, s = credit_lr_best_params$penalty)
vip(credit_lr_last_fit_model)


# Guardar tudo ------------------------------------------------------------

write_rds(credit_lr_last_fit, "credit_lr_last_fit.rds")
write_rds(credit_lr_model, "credit_lr_model.rds")

collect_metrics(credit_lr_last_fit)

credit_test_preds <- collect_predictions(credit_lr_last_fit)

# roc
credit_roc_curve <- credit_test_preds %>% roc_curve(Status, .pred_bad)
autoplot(credit_roc_curve)

# confusion matrix
credit_test_preds %>%
  mutate(
    Status_class = factor(if_else(.pred_bad > 0.5, "bad", "good"))
  ) %>%
  conf_mat(Status, Status_class)

summary(conf_mat(credit_test_preds, Status, .pred_class)) %>%
  dplyr::select(-.estimator) %>%
  gt() %>% 
  fmt_number(columns = 2, decimals = 4)


# gráficos extras!

# risco por faixa de score
credit_test_preds %>%
  mutate(
    score =  factor(ntile(.pred_bad, 10))
  ) %>%
  count(score, Status) %>%
  ggplot(aes(x = score, y = n, fill = Status)) +
  geom_col(position = "fill") +
  geom_label(aes(label = n), position = "fill") +
  coord_flip()

# gráfico sobre os da classe "bad"
# percentis = 20
# credit_test_preds %>%
#   mutate(
#     score = factor(ntile(.pred_bad, percentis))
#   ) %>%
#   filter(Status == "bad") %>%
#   group_by(score, .drop = FALSE) %>%
#   summarise(
#     n = n(),
#     media = mean(.pred_bad)
#   ) %>%
#   mutate(p = n/sum(n)) %>%
#   ggplot(aes(x = p, y = score)) +
#   geom_col() +
#   geom_label(aes(label = scales::percent(p))) +
#   geom_vline(xintercept = 1/percentis, colour = "red", linetype = "dashed", size = 1)


# Modelo final ------------------------------------------------------------

credit_final_lr_model <- credit_wf %>% fit(credit_data)

predict(credit_final_lr_model, credit_test, type = "prob")

saveRDS(credit_final_lr_model, "modelo_final.rds")

