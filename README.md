# Spending Tracker 
Using Optical Character Recognition technology to track and store user spending and present it in scatter plot form. 
### Statement
This project is a revision of our original project in which we sought to model the correlation between hydro electric power generation and rain fall in the Pacific Northwest. We have decided to make our project more useful and interesting by combining several technologies that will allow a user to track thier own spending habits. Our solution uses optical character recognition to extract text from receipt images. The text will be parsed and data stored into MongoDB collection. Lastly the data will be plotted based on a filter query i.e. for last 7 days or last month of spending.  

### Analysis
Approaches from classes that will be used in the project will be using map to create a list of numbers from a list of strings, state-modification, closure, and recursion. 

### Data set or other source materials

After competing in the UMass Lowell Hawkathon 

```html 
<data1> 
  <raindata>15</raindata> 
  <hydrodata>50,000,000</hydrodata> 
</data1>
```
With this file we plan on creating a function that will read the file and return either a single list of cons pairs for the rain data and hydro data points or a single list for each that will be zipped together with another function. The final plottable form of the data will be a single list of vectors each containing the data point pairs. 


### Deliverable and Demonstration

The program will extract the data, and use it to graph the amount of rain by the amount of power produced. If we have time, later we will add extra features to allow the user to add new data to graph. Right now, it is not intended to be interactive. It will be shown to work when the user gets a graph. Right now, some of the lists can be shown. 

### Evaluation of Result How will you know if you are successful? 

This project will be successful if the program is able to correctly plot the data points provided to it. If the plot correctly conveys the information in the data we will consider the result a success. 


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
[hydro]:https://catalog.data.gov/dataset/monthly-hydropower-generation-data-by-facility-us-bureau-of-reclamation
[rain]:https://www.wunderground.com/history/airport/KSEA/2000/9/4/MonthlyHistory.html?req_city=&req_state=&req_statename=&reqdb.zip=&reqdb.magic=&reqdb.wmo=
[data]:https://www.data.gov

