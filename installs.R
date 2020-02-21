devtools::install_url('https://cran.r-project.org/src/contrib/Archive/aws.s3/aws.s3_0.3.12.tar.gz')

install.packages(
  c(
    'reticulate',
    'tuneR' 
  )
)

devtools::install_github("tidyverse/tidyr")
devtools::install_github(repo='jumo/des-jumoR@development',auth_token = Sys.getenv('GITHUB_PAT'))
devtools::install_github(repo='jumo/des-hercules-r@development',auth_token = Sys.getenv('GITHUB_PAT'))


sparklyr::spark_install()