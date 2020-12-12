# --------------------------------------------------- 
# Introduction to Writing Functions in R - Case study on grain yields 
# 11 dez 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# Grain yield and unit conversion  -------------------------------------------
# Converting areas to metric 1
# Write a function to convert acres to sq. yards
acres_to_sq_yards <- function(acres) {
  acres * 4840
}

# Write a function to convert yards to meters
yards_to_meters <- function(yards) {
  inches <- yards * 36
  meters <- inches * 0.0254
  meters
}

# Write a function to convert sq. meters to hectares
sq_meters_to_hectares <- function(sq_meters){
  hectares <- sq_meters/10000
  hectares
}

# Converting areas to metric 2
library(magrittr)

# Write a function to convert sq. yards to sq. meters
sq_yards_to_sq_meters <- function(sq_yards) {
  sq_yards %>%
    # Take the square root
    sqrt() %>%
    # Convert yards to meters
    yards_to_meters() %>%
    # Square it
    raise_to_power(2)
}

# Write a function to convert acres to hectares
acres_to_hectares <- function(acres) {
  acres %>%
    # Convert acres to sq yards
    acres_to_sq_yards() %>%
    # Convert sq yards to sq meters
    sq_yards_to_sq_meters() %>%
    # Convert sq meters to hectares
    sq_meters_to_hectares()
}

# Define a harmonic acres to hectares function
harmonic_acres_to_hectares <- function(acres) {
  acres %>% 
    # Get the reciprocal
    get_reciprocal() %>%
    # Convert acres to hectares
    acres_to_hectares() %>% 
    # Get the reciprocal again
    get_reciprocal()
}

# Converting yields to metric
# Write a function to convert lb to kg
lbs_to_kgs <- function(lbs) {
  kg <- lbs * 0.45359237
  kg
}

# Write a function to convert bushels to lbs
bushels_to_lbs <- function(bushels, crop) {
  # Define a lookup table of scale factors
  c(barley = 48, corn = 56, wheat = 60) %>%
    # Extract the value for the crop
    extract(crop) %>%
    # Multiply by the no. of bushels
    multiply_by(bushels)
}


# Write a function to convert bushels to kg
bushels_to_kgs <- function(bushels, crop) {
  bushels %>%
    # Convert bushels to lbs for this crop
    bushels_to_lbs(crop) %>%
    # Convert lbs to kgs
    lbs_to_kgs()
}


# Write a function to convert bushels/acre to kg/ha
bushels_per_acre_to_kgs_per_hectare <- function(bushels_per_acre, crop = c("barley", "corn", "wheat")) {
  # Match the crop argument
  crop <- match.arg(crop)
  bushels_per_acre %>%
    # Convert bushels to kgs for this crop
    bushels_to_kgs(crop) %>%
    # Convert harmonic acres to ha
    harmonic_acres_to_hectares()
}

# Applying the unit conversion
corn <- readRDS("Datasets/nass.corn.rds")
wheat <- readRDS("Datasets/nass.wheat.rds")

# View the corn dataset
glimpse(corn)

corn %>%
  # Add some columns
  mutate(
    # Convert farmed area from acres to ha
    farmed_area_ha = acres_to_hectares(farmed_area_acres),
    # Convert yield from bushels/acre to kg/ha
    yield_kg_per_ha = bushels_per_acre_to_kgs_per_hectare(
      yield_bushels_per_acre,
      crop = "corn"
    )
  )

# Wrap this code into a function
fortify_with_metric_units <- function(data, crop) {
  data %>%
    mutate(
      farmed_area_ha = acres_to_hectares(farmed_area_acres),
      yield_kg_per_ha = bushels_per_acre_to_kgs_per_hectare(
        yield_bushels_per_acre, 
        crop = crop
      )
    )
}

# Try it on the wheat dataset
fortify_with_metric_units(wheat, "wheat")

# Visualizing grain yields  -------------------------------------------
# Plotting yields over time
library(ggplot2)
wheat <- fortify_with_metric_units(wheat, "wheat")
corn <- fortify_with_metric_units(corn, "corn")

# Using corn, plot yield (kg/ha) vs. year
ggplot(corn, aes(y = yield_kg_per_ha, x = year)) +
  # Add a line layer, grouped by state
  geom_line(aes(group = state)) +
  # Add a smooth trend layer
  geom_smooth()

# Wrap this plotting code into a function
plot_yield_vs_year <- function(data) {
  ggplot(data, aes(year, yield_kg_per_ha)) +
    geom_line(aes(group = state)) +
    geom_smooth()
}
# Test it on the wheat dataset
plot_yield_vs_year(wheat)

# A nation divided
usa_census_regions <- read.csv("Datasets/usa_census_regions.csv")

# Inner join the corn dataset to usa_census_regions by state
corn %>%
  inner_join(usa_census_regions, by = "state")

# Wrap this code into a function
fortify_with_census_region <- function(data) {
  data %>%
    inner_join(usa_census_regions, by = "state")
  
}
# Try it on the wheat dataset
fortify_with_census_region(wheat)

# Plotting yields over time by region
wheat <- fortify_with_census_region(wheat)
corn <- fortify_with_census_region(corn)

# Plot yield vs. year for the corn dataset
plot_yield_vs_year(corn) +
  # Facet, wrapped by census region
  facet_wrap(vars(census_region))

# Wrap this code into a function
plot_yield_vs_year_by_region <- function(data) {
  plot_yield_vs_year(data) +
    facet_wrap(vars(census_region))
}
# Try it on the wheat dataset
plot_yield_vs_year_by_region(wheat)

# Modeling grain yields  -------------------------------------------
# Running a model
library(mgcv)

# Run a generalized additive model of 
# yield vs. smoothed year and census region
corn_model <- gam(yield_kg_per_ha ~ s(year) + census_region, data = corn)

# Wrap the model code into a function
run_gam_yield_vs_year_by_region <- function(data) {
  gam(yield_kg_per_ha ~ s(year) + census_region, data = data)
}

# Try it on the wheat dataset
wheat_model <- run_gam_yield_vs_year_by_region(wheat)

# Making yield predictions
census_regions <- levels(factor(usa_census_regions$census_region))

# Make predictions in 2050  
predict_this <- data.frame(
  year = 2050,
  census_region = census_regions
) 

# Predict the yield
pred_yield_kg_per_ha <- predict(corn_model, predict_this, type = "response")

predict_this %>%
  # Add the prediction as a column of predict_this 
  mutate(pred_yield_kg_per_ha = pred_yield_kg_per_ha)

# Wrap this prediction code into a function
predict_yields <- function(model, year) {
  predict_this <- data.frame(
    year = year,
    census_region = census_regions
  ) 
  pred_yield_kg_per_ha <- predict(model, predict_this, type = "response")
  predict_this %>%
    mutate(pred_yield_kg_per_ha = pred_yield_kg_per_ha)
}

# Try it on the wheat dataset
predict_yields(wheat_model, 2050)

# Do it all over again
barley <- readRDS("Datasets/nass.barley.rds")

fortified_barley <- barley %>% 
  # Fortify with metric units
  fortify_with_metric_units(crop = "barley") %>%
  # Fortify with census regions
  fortify_with_census_region()

# See the result
glimpse(fortified_barley)

# Plot yield vs. year by region
plot_yield_vs_year_by_region(fortified_barley)

fortified_barley %>% 
  # Run a GAM of yield vs. year by region
  run_gam_yield_vs_year_by_region()  %>% 
  # Make predictions of yields in 2050
  predict_yields(2050)
