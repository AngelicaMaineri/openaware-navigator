# Package setup ---------------------------------------------------------------

# Install required packages:
# install.packages("pak")
# pak::pak("surveydown-dev/surveydown") # Development version from GitHub

# Load packages
library(surveydown)

# Database setup --------------------------------------------------------------
#
# Details at: https://surveydown.org/docs/storing-data
#
# surveydown stores data on any PostgreSQL database. We recommend
# https://supabase.com/ for a free and easy to use service.
#
# Once you have your database ready, run the following function to store your
# database configuration parameters in a local .env file:
#
# sd_db_config()
#
# Once your parameters are stored, you are ready to connect to your database.
# For this demo, we set ignore = TRUE in the following code, which will ignore
# the connection settings and won't attempt to connect to the database. This is
# helpful if you don't want to record testing data in the database table while
# doing local testing. Once you're ready to collect survey responses, set
# ignore = FALSE or just delete this argument.

db <- sd_db_connect(ignore = TRUE)

# UI setup --------------------------------------------------------------------

ui <- sd_ui()

# Server setup ----------------------------------------------------------------

server <- function(input, output, session) {
  # Used for case 5
  # Custom function to check if pet number input is > 1
  more_than_one_pet <- function(input) {
    if (is.null(sd_value("pet_number"))) {
      return(FALSE)
    }
    num_pets <- as.numeric(sd_value("pet_number"))
    return(num_pets > 1)
  }
  
  # Define any conditional showing logic here (show a question if a condition is true)
  sd_show_if(
      sd_value("continue") == 'yes' ~ 'node_control',
      sd_value("node_control_q") == 'yes' ~ 'node_steward',
      sd_value("node_control_q") == 'no' ~ 'endpoint_info',
      sd_value("node_steward_q") == 'yes' ~ 'node_consent',
      sd_value("node_steward_q") == 'no' ~ 'action_contact',
      sd_value("node_consent_q") == 'yes' ~ 'node_anon',
      (sd_value("node_consent_q") == 'no' | sd_value("node_anoncan_q") == 'no') ~ 'action_mdonly',
      (sd_value("node_anon_q") == 'yes' | sd_value("node_anonit_q") == 'yes') ~ 'action_deposit',
      sd_value("node_anon_q") == 'no' ~ 'node_anonit',
      sd_value("node_anonit_q") == 'no' ~ 'node_anoncan',
      sd_value("node_anoncan_q") == 'yes' ~ 'action_anondoit',
      sd_value("action_anondoit_q") == 'yes' ~ 'action_deposit',
      (sd_value("action_mdonly_q") == 'yes' | sd_value("action_deposit_q") == 'yes') ~ 'endpoint_materials',
      (sd_value("continue") == 'no' |
         sd_value("action_anondoit_q") == 'no' |
         sd_value("action_mdonly_q") == 'no' |
         sd_value("action_deposit_q") == 'no') ~ 'endpoint_exit'
    )
  
  # Run surveydown server and define database
  sd_server(db = db)
}

# Launch the app
shiny::shinyApp(ui = ui, server = server)