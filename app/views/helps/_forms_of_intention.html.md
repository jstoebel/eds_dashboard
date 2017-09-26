# How to upload forms of intention from Qualtrics

### Find the date of the last processed FOI

We want to avoid having to process all FOIs in the Qualtrics data set as this will progressively become a longer and longer task. Find out the last FOI processed so we can filter for only FOIs happening after that timestamp

### Filter records

1. In Qualtrics click `add filter -> survey metadta -> End Date`
2. Select a data range between the timestamp determined above and the present day.
3. Click `export & import -> export data -> download data table`.
4. Click the XML tab at the top
5. make sure the option "use choice text" is selected
6. click download

### upload to the dashboard

1. Unzip the file (if you downloaded it ziped)
2. In the dashboard go to Reports -> Forms of Intention
3. Upload the file and click `Import'

If you get a positive confirmation message, you are done! If you get an error see below

### dealing with errors

There are potentially several things that could go wrong when uploading. The most common is when a student mistypes their B#. Qualtrics will ensure that a B# is entered in the correct format (B00+6 digits) but has no way of knowing if the B# matches a student. If this has happened you will get an error saying `Student could not be identified for record completed on <time stamp>` To fix this you can either edit the xml doc directly or do the following:

1. Go back to the dataset in Qualtrics.
2. Reveal the field called `End Date`
3. Find the record with the time stamp in question.
4. To remove the record: use the options arrow at the right to select `Delete Response`
5. To edit the record use the options arrow -> `Retake response`. Please do not select `Retake as New Response` as this will make a new record and leave the problem record in place.
6. Download a new XML doc and try uploading again.

If you get another error, please report it to the app administrator.


