shiny::runApp(".")

getwd()
setwd("C:/Users/angel/Documents/GitHub/odissei/openaware-navigator")

options(rsconnect.renv.snapshot = FALSE)

rsconnect::deployApp(
  appDir  = "shinyapp",
  appName = "OpenAware_Navigator",
  account = "angelicamaineri"
)