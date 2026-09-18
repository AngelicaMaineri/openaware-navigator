shiny::runApp(".")

rsconnect::deployApp(
  appDir  = "shinyapp",
  appName = "OpenAware_Navigator",
  account = "angelicamaineri"
)