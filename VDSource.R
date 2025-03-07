#UTILITY FUNCTIONS####
data_import <- function(location = location_var, excel_path = excel_path_var, form) {
 
  # Check if data source is local or VD
  if (location == "VD") {
    df <- read_excel(excel_path, sheet = form, col_names = FALSE) %>% as.data.frame()
    df <- df[-1, ] 
    colnames(df) <- df[1, ]  
    df <- df[-1, ]  
    View(df)
  } else if (location == "VD") {
    df <- edcData$Forms[[form]]
  } else {
    stop("Invalid location. Use 'local' or 'VD'.")
  }
 
  return(df)
} 
#####

#UPDATE ONCE:
excel_path_var <- "C:/Users/KeenanIkking/Downloads/_ZA_20250211_073456.xlsx"
BIC_image <- "https://www.bioinformatico.com/wp-content/uploads/2024/03/logo-1.png"

#####

DM <- data_import(form ="DM")
IE <- data_import(form ="IE")

