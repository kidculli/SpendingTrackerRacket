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
![ScreenShot](Proc.jpg)

The rain and power data will be written beforehand in html in the file. The procedures will extract the data from the html in the file, and move the data into two lists, one list being the rain data numbers, and the other list being the power data list. The two lists will be handed to a function which will convert them into list of vectors. Each vector will have two numbers, one a power data number, and the other a rain data number. The list will then be handed to a function which will use the list to create a scatterplot graph of the data. 

## Schedule

### First Milestone (Fri Apr 15)
First Milestone: A file filled with html should be turned in, along with procedures to extract the data from the file, and store it in the two lists. 

### Second Milestone (Fri Apr 22)
The second milestone will be procedures to convert the data in the two lists two a list of vectors which is needed for creating a scatter-plot, and procedures taking that transformed data and using it to create a 2d graph. 


### Final Presentation (last week of semester)
The project should be done at this point. We would simply add more features, such as perhaps adding another graph, and allowing the user to add data to be graphed. If time permits we may explore graphing a 3d plot. 

## Group Responsibilities
I, John Kuczynski, will be creating the file with the html. I will also be creating the procedures to extract the data, and store it in two lists.

Cullin Lam, will be creating a procedure that takes the result of parsing the html file and converting the data points into a list of coordinate vectors. This list will then be passed to a plot function that will plot the data and configure the x and y axis with appropriate tick marks and labels. 



<!-- Links -->
[haven]:https://www.havenondemand.com
[hydro]:https://catalog.data.gov/dataset/monthly-hydropower-generation-data-by-facility-us-bureau-of-reclamation
[rain]:https://www.wunderground.com/history/airport/KSEA/2000/9/4/MonthlyHistory.html?req_city=&req_state=&req_statename=&reqdb.zip=&reqdb.magic=&reqdb.wmo=
[data]:https://www.data.gov

