# Spending Tracker 
Using Optical Character Recognition technology to track and store user spending and present it in scatter plot form. 
### Statement
This project is a revision of our original project in which we sought to model the correlation between hydro electric power generation and rain fall in the Pacific Northwest. We have decided to make our project more useful and interesting by combining several technologies that will allow a user to track thier own spending habits. Our solution uses optical character recognition to extract text from receipt images. The text will be parsed and data stored into MongoDB collection. Lastly the data will be plotted based on a filter query i.e. for last 7 days or last month of spending.  

### Analysis
Approaches from classes that will be used in the project will be using map to create a list of numbers from a list of strings, state-modification, closure, and recursion. 

### Data set or other source materials

After competing in the UMass Lowell Hawkathon, I (Cullin) was introduced to a the [HAVEN ON DEMAND][haven] API which provides many meachine learning api's for use for free with an API Key. For this project I thought it would be interesting to utilize their Optical Character Recognition Api which extracts text from images.  

###Example Request 

In order to use API we send an HTTP request to the correct URL with our parameters. Our sample image 
![image](https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcSMKXbo_GQB-JNYOtEokCUJFpK40O2p2f8WrN3CrlsR1jJ20OFr)

```
"https://api.havenondemand.com/1/api/sync/ocrdocument/v1?url=http%3A%2F%2Fwww.thedetroitbureau.com%2Fwp-content%2Fuploads%2F2012%2F06%2Fsign-sharp-edges.jpeg&mode=scene_photo&apikey=82833b89-515e-4727-97ff-d8af21d53be3"
```


###Example Response 

```json 
{
  "text_block": [
    {
      "text": "1- / • &apos; Q\n/ ! ; ! ; - -\n7 *\n!\n$\n,\nN\nX X\n;/\n, -;t\n! .\nA\nÉ &apos; . V tx: ; &quot;4 ( X M. Craig Parker\nEN N, Installation Services Man£*8€1&apos;\ngi;&apos; X ,N&gt;\nl gael 908 Boston Turnpike\nUnit 1\nShrewsbury, MA 01545 # . *\n{\nCell 508-797-7623\nOffice 774-275-2189\nFax 608-845-6076 N\nToll Free 877-903-3768\nMartin-C-Parker@HomeDepot.corn\n! 0\n1\n1 6/\n!\nl\n£\n&quot;&quot;Nr\n*&gt; ; &quot;\nw *\n**8 4 $ • ; XM X r\n!\n&apos; ! , #\n* %\nl&quot; l ! ; , &apos;\n* •\n; . . ! A (\n• • 4 • it&apos;\n@• • 0\nI /",
      "left": 0,
      "top": 0,
      "width": 1080,
      "height": 720
    }
  ]
}

```
With this data we plan on parsing the response string using JSON and regular expressions to extract the final dollar value amount from the image to be used as the total amount of money spent on that purchase. This data will be stored into our MongoDB database with the following schema: 

```json
{
  date_created: number(ms since unix epoch)
  total: number(total dollar value spent)
}
```


### Deliverable and Demonstration

The program will take as input an image file of the purchase receipt. It will then insert the transaction into the database. The program will also be able to plot graphs using the available data in the database with the x axis as date time and the y axis as the total amount spent on that day. 

### Evaluation of Result How will you know if you are successful? 

This project will be successful if the program is able to successfully extract the dollar amount from an image and insert it into the database. In addition the program should be able to produce a plot using the most recent data points in the database. 


## Architecture Diagram
![ScreenShot](https://github.com/oplS16projects/SpendingTrackerRacket/blob/master/SpendingTracker%20Diagram.png)


## Schedule

### First Milestone (Fri Apr 15)
Configure HTTP request to send a binary image file for OCR analysis. 
Create function to extract dollar value from JSON response 

### Second Milestone (Fri Apr 22)
Set Up MongoDB server 
Create insert function and query function using mongdb package. 

### Final Presentation (last week of semester)
Generate Weekly spending plot and monthly plot 

## Group Responsibilities

Cullin Lam - 
  Configure HTTP request to take binary file. 
  Set Up MongoDB server 
  Create insert/ query function 
  
John Kuczynski - 
  Create function to parse JSON response 
  Generate plots 


<!-- Links -->
[haven]:https://www.havenondemand.com


