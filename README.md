
# Sports App

This application shows previous and upcoming matches. It provide highlights of previous matches. User can select any team and filter matches as per selected team. Synchronized all data for offline usage. MVVM structure is user to create this application. 


## Approaches(Reasons, Benefits, and Drawbacks)

Whole app created programmatically

- We have all UI and screen control is in one place.
- It become easier to resolve merge conflicts when two or more developers are working on same project.
- It is time consuming as we have to write more code for object properties, constrains, etc and if you are new to it, it is complex to add/update constrains when there are multiple objects.
- No visual representation of screens.

Diffable datasource is used for collectionview and tableview.

- This is very easy method to update in collection and table view.
- We don't need to update collection and table view after uploading datasource. It will handle add, delete updates automatically.
- Default methods are not needed when we use Diffable DataSource
- We can't directly update value in any section.
- We need minimum OS version as iOS 13 for using Diffable datasource

URLSession is used to get data from APIs and to load images

- Using URLSession we can implement only app required methods.
- It is useful for simple applications and no need to use any third party library as it contains extra logics.
- When we create big application we have to add lots of methods to handle errors and to make validations and with third party library it become easy. Third party library saves us from lot extra code.

NWPathMonitoris used to check network connection

- It is easy to implement and get status when network change.
- We need minimum OS version as iOS 12 for using this.

MVVM structure is used 

- This architecture is easy to understand and no bulky code in any single view controller.
- It increases testability of views.
- For simple view it become complex when we use MVVM.
- Increase development and maintenance cost of simple application.




## Demo

[filter demo](https://github.com/kruti01/Virtusa_Assignment/blob/main/filter.gif)

