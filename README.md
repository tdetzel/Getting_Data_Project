Samsung data readme file

The file run_analysis.R imports raw data and variable names from a repository of Samsung smartphone measurements collected in an experiment to predict six types of activities by 30 subjects who participated.

The code pulls a subset of measurements (variables that reported a mean and standard deviation) and calculates a mean for each grouped by subject and activity.

The code produces a final tidy table ("means") and writes it to a file ("samsungmeans.txt") in the R working directory.

The code assumes the raw data has been downloaded (see comments) into a working directory folder named "/Data".

There are 10 steps to the code:

Part 1 -- Setup
Checks for the directory and files and loads required libraries.

Part 2 -- Get data
Downloads the data and unzips the component files.

Part 3 -- Extracts tables
Reads in the test, training, activity and subject tables.

Part 4 -- Combine data
Combines the test and training data with activity and subject variables int as a single data frame.

Part 5 -- Get variable names
Reads in the variable names and combines them for later use.

Part 6 -- Merge activity labels
Merges plain-English activity labels with the data.

Part 7 -- Get mean, stdev variables
Finds the variables that measure means or std and creates a new table, "subdat" as a data.table.

Part 8 -- Clean up variable names
Fixes variable names to make them easier to read. Gets rid of unneeded parentheses. Separates 't' and 'f' prefixes at start. Changes case to lower.
Updates "subdata" with cleaned-up names.

Part 9 -- Calculate grouped means
Uses data.table to calculate means for each variable by subject and activity.

Part 10 -- Sort and write to file
Sorts data by subject using setkey(). Writes the tidy output file to the working directory.



