spark_dependencies <- function(config,...){
  sparkapi::spark_dependency(
    packages = c("djgg:PCARD:1.1")
  )
}

.onLoad <- function(libname, pkgname) {
  sparkapi::register_extension(pkgname)
}
