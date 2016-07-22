spark_dependencies <- function(spark_version, scala_version,...){
  sparkapi::spark_dependency(
    packages = c("djgg:PCARD:1.1")
  )
}

.onLoad <- function(libname, pkgname) {
  sparkapi::register_extension(pkgname)
}
