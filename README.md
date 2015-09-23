How the script work:

1. Load in the necessary data and their description
2. Combine the train data and test data using rbind
3. Get the idx for the features whith 'std()' and 'mean()' in the name
4. Take only the columns with 'std()' and 'mean()' in the name by subsetting it with idx 
5. Combine it with subjectID and activity code list from subject_ and y_
6. Give the columns descriptive names
7. Summarize data: take mean on the data frame that is grouped on melted data 
8. Replace activity id with descriptive name (do it here so it has less occurances)
9. write result in txt file
