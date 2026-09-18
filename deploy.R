# Scripts to run the app and deploy online

setwd("C:/Users/angel/Documents/GitHub/odissei/openaware-navigator")

shiny::runApp(".")

rsconnect::deployApp(
  appDir  = "shinyapp",
  appName = "OpenAware_Navigator",
  account = "angelicamaineri"
)