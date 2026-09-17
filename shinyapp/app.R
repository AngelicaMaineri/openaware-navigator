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
    
    # 6. Conditional page showing
    sd_value("continue") == 'yes' ~ 'yes_sensitive_data',
    sd_value("continue") == 'no' ~ 'no_sensitive_data',
    sd_value("control_over_data_q") == 'yes' ~ 'yes_control_over_data',
    sd_value("control_over_data_q") == 'no' ~ 'no_control_over_data',
    sd_value("contacted_data_steward_q") == 'no' ~ 'no_contacted_data_steward',
    sd_value("informed_consent_q") == 'no' ~ 'no_informed_consent',
    sd_value("informed_consent_q") == 'yes' ~ 'yes_informed_consent',
    sd_value("informed_consent_data_sharing_q") == 'yes' ~ 'yes_informed_consent_data_sharing',
    sd_value("informed_consent_data_sharing_q") == 'no' ~ 'no_informed_consent_data_sharing',
    sd_value("informed_consent_data_sharing_q") == 'yes' ~ 'yes_informed_consent_data_sharing',
    sd_value("non_anonymous_q") == 'yes_openly' ~ 'yes_openly_non_anonymous',
    sd_value("non_anonymous_q") == 'yes_with_restrictions' ~ 'yes_with_restrictions_non_anonymous',
    sd_value("non_anonymous_q") == 'partially' ~ 'partially_non_anonymous',
    sd_value("non_anonymous_q") == 'no' ~ 'no_non_anonymous',
    sd_value("anonymity_q") == 'yes' ~ 'yes_anonymity',
    sd_value("anonymity_q") == 'no' ~ 'no_anonymity',
    sd_value("can_anonymize_q") == 'yes' ~ 'yes_can_anonymize',
    sd_value("can_anonymize_q") == 'no' ~ 'no_can_anonymize'
    
  )
  
  # Run surveydown server and define database
  sd_server(db = db)
}

# Launch the app
shiny::shinyApp(ui = ui, server = server)