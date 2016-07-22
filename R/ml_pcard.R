
#' ml_pcard An R wrapper for the PCARD Spark Package that performs Random Discretization and PCA, then joins the results and trains an ensemble of decision trees.
#'
#' @param x - a tbl_spark object
#' @param response  - name of the column containing group labels
#' @param features - features to use to predict group membership
#' @param num.trees - number of decision trees to use ensemble
#' @param max.bins  - number of bins in discretization 
#'
#' @return A Spark model object that can be used in predict or sdf_predict
#' @export


ml_pcard <- function(x,
                   response,
                   features = dplyr::tbl_vars(x),
                   num.trees = 10,
                   max.bins = 5){

  df <- spark_dataframe(x)
  sc <- spark_connection(df)

  num.trees <- sparklyr:::ensure_scalar_integer(num.trees)
  max.bins <- sparklyr:::ensure_scalar_integer(max.bins)



  df <- sparklyr:::prepare_response_features_intercept(df, response, features, NULL)
  envir <- new.env(parent = emptyenv())
  tdf <- sparklyr:::ml_prepare_dataframe(df, features, response, envir = envir)

  
  pcard <- sc %>% invoke_new("org.apache.spark.ml.classification.PCARDClassifier")  

  model <- pcard %>% 
    invoke("setTrees", num.trees) %>%
    invoke("setCuts", max.bins) %>% 
    invoke("setLabelCol", envir$response) %>% 
    invoke("setFeaturesCol", envir$features)
  
  fit <- model %>% 
    invoke("fit", tdf)

  sparklyr:::ml_model("pcard", fit,
           features = features,
           response = response,
           model.parameters = as.list(envir)
  )
  
}
