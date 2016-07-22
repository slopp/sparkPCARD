
#' ml_knn
#'
#' @param x - a tbl_spark object
#' @param response  - name of the column containing group labels
#' @param features - features to use to predict group membership
#' @param k - number of neighbours used in classification
#'
#' @return
#' @export
#'
#'

ml_knn <- function(x,
                   response,
                   features = dplyr::tbl_vars(x),
                   k = 10){

  df <- spark_dataframe(x)
  sc <- spark_connection(df)

  k <- sparklyr:::ensure_scalar_integer(k)



  df <- sparklyr:::prepare_response_features_intercept(df, response, features, NULL)
  envir <- new.env(parent = emptyenv())
  tdf <- sparklyr:::ml_prepare_dataframe(df, features, response, envir = envir)

  knn <- sc %>%
    #invoke_new("org.apache.spark.ml.classification.KNNClassifier")
     invoke_new("org.apache.spark.ml.classification.kNN_IS.kNN_ISClassifier")

  model <- knn %>%
    invoke("setK", k) %>%
    invoke("setFeaturesCol", envir$features) %>%
    invoke("setLabelCol", envir$response)

  fit <- model %>%
     invoke("fit", tdf)

  sparklyr:::ml_model("knn", fit,
           features = features,
           response = response,
           model.parameters = as.list(envir)
  )
}
