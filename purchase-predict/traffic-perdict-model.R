# This script creates and scores a model designed to predict the propensity
# for a user to buy a particular product. The script connects to the Insights
# server and its functions set model, score, and report configuration. Where
# execute methods are called, the script tells the server to use the
# configuration to create a model, score, or report.

##### Step 1: Connect to Insights environment and library.

# Use the ApigeeInsights R package to provide modeling functions.
library(ApigeeInsights)

# Collect configuration parameters from the config insights-connection-config file.
# The paste function forms a path by concatenating the working directory
# (where this R file is) with the name of the config file. If your config file isn't
# in the same directory as this script file, be sure to make the appropriate changes.
config <- paste(getwd(),"/insights-connection-config",sep="")
# Connect to the Insights server, but do it invisibly (without printing to the console).
invisible(connect(configFile = config))

# Change this value to append new models, scores, and reports with
# something as an identifier. This helps avoid conflicts with artifacts
# already on the server. Each time you run this script to create new
# objects on the server, you’ll need to change this value to avoid
# name conflicts with objects already on the server.
myID <- "v1"

##### Step 2: Get things started by identifying a server-side
##### project and the catalog holding the data.

# Name the server-side project that will hold the modeling
# configuration created by this code. Insights creates the project.
projectName <- paste("TrafficForecast", myID, sep="-")

# Specify the catalog that contains the datasets to be
# used by this model. RetailDatasets is a pre-installed catalog.
setCatalog("Traffic")

# Create a model object so you can start setting model details. The name
# value is used to identify the model on the server.
model <- Model$new(project=projectName, name="MyRecommendationsModel",
                   description="A model to show propensity for buying a particular product.")

# Set time frame for training data. The model will be created by analyzing
# events whose timestamps fall within these boundaries.
model$setDateFilter(startTime="2013-01-01 00:00:00", endTime="2013-08-19 23:59:59")

# Set the user profile dataset to use, along with the parts of the data
# that should be considered in looking for patterns.
model$setProfile(dataset="APITraffic", dimensions=list(c("apiname", "time","traffic")))
