spark_dependencies <- function(config,...){
  sparkapi::spark_dependency(
    package = c("JMailloH:kNN_IS:3.0")
  )
}

.onLoad <- function(libname, pkgname) {
  sparkapi::register_extension(pkgname)
}
