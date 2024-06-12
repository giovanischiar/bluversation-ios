<h1 align="center">
  <img src="readme-res/ic_launcher.svg" width="100" height="100"><br>
  Bluversation
</h1>

<p align="center">
  <strong>A bluetooth chat</strong><br>
  A simple bluetooth chat iOS and macOS application
</p>

- [Use Cases](#use-cases)
- [Technologies](#technologies)
- [Diagrams](#diagrams)
  - [Project structure](#project-structure)
  - [Group `view` and `viewmodel`](#group-view-and-viewmodel)
  - [Group `view.viewdata`](#group-viewviewdata)
  - [Group `viewmodel` and `view.viewdata`](#group-viewmodel-and-viewviewdata)
  - [Group `viewmodel` and `model.repository`](#group-viewmodel-and-modelrepository)
  - [Group `model`](#group-model)
  - [Group `model.repository` and `model`](#group-modelrepository-and-model)
- [Future Tasks](#future-tasks)

## Use Cases
<table>
  <thead>
    <tr>
      <th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
      <th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <img src="readme-res/screenshots/conversations-screen-empty-ios.png" width="232.05" height="490.8">
      </td>
      <td>
        <img src="readme-res/screenshots/conversations-screen-empty-macos.png">
      </td>
    </tr>
    <tr>
      <td colspan="2">
        This is the app when you open it for the first time. To start a conversation, click on the icon at the top to find the contacts. You'll need to turn Bluetooth on in order to find and chat with other contacts.
      </td>
    </tr>
    <tr>
      <td>
        <img src="readme-res/screenshots/contacts-dialog-ios.png" width="232.05" height="490.8">
      </td>
      <td>
        <img src="readme-res/screenshots/contacts-dialog-macos.png">
      </td>
    </tr>
    <tr>
      <td colspan="2">
        Here is the contacts dialog opened. Select one of the contacts found to start a conversation.
      </td>
    </tr>
    <tr>
      <td>
        <img src="readme-res/screenshots/conversation-screen-ios.png" width="232.05" height="490.8">
      </td>
      <td>
        <img src="readme-res/screenshots/conversation-screen-macos.png">
      </td>
    </tr>
    <tr>
      <td colspan="2">
        This is how the conversation will appear with a complete chat history. Type your message in the text field at the bottom of the screen to send messages.
      </td>
    </tr>
  </tbody>
</table>

# Technologies
|Technology|Purpose|
|:-:|:-:|
|<img src="https://developer.apple.com/assets/elements/icons/swiftui/swiftui-96x96_2x.png" width="50" height="50"><br>[SwiftUI](https://developer.apple.com/xcode/swiftui/)|Design UI|  
|<img src="https://www.bluetooth.com/wp-content/uploads/2019/10/Master-Icon-File_Logo-600x600.png" width="50" height="50"><br>[Bluetooth](https://developer.apple.com/xcode/swiftui/)|Communication between the devices|  

## Diagrams
  Please check <a href="https://github.com/giovanischiar/diagram-notation">this repository</a> to learn more about the notation I used to create the diagrams in this project.

### Project structure
  This diagram shows all the groups the application has, along with their structures. Some groups are simplified, while others are more detailed.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./readme-res/diagrams/dark/project-structure-diagram.dark.svg">
  <img alt="Whole Project Diagram" src="./readme-res/diagrams/project-structure-diagram.light.svg">
</picture>

### Group `view` and `viewmodel`
  These diagrams illustrate the relationship between screens from `view` and `viewmodel` classes. The arrows from the View Models represent View Data objects (structs that hold all the necessary data for the view to display), primitives, or collections encapsulated by [Publishers](https://developer.apple.com/documentation/combine/publisher), which are artifacts that encapsulate data streams. Every update in the View Data triggers the Publisher to emit these new values to the `view`, and the view updates automatically. Typically, the methods called from screens in `view` to classes in `viewmodel` trigger these changes, as represented in the diagram below by arrows from the `view` screens to `viewmodel` classes.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./readme-res/diagrams/dark/view-view-model-diagram.dark.svg">
  <img alt="View/ViewModel Relationship Diagram" src="./readme-res/diagrams/view-view-model-diagram.light.svg">
</picture>

### Group `view.viewdata`
  View Datas are structs that hold all the data the `view` needs to present. They are created from `model` structs and served by View Models to the `view`. This diagram represents all the associations among the artifacts in the `view.viewdata`.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./readme-res/diagrams/dark/viewdata-diagram.dark.svg">
  <img alt="ViewData Diagram" src="./readme-res/diagrams/viewdata-diagram.light.svg">
</picture>

### Group `viewmodel` and `view.viewdata`
  View Models serve the `view` with objects made from `view.viewdata` structs, collections, or primitive objects encapsulated by Publishers. This diagram represents all the associations among the artifacts in `viewmodel` and `view.viewdata`.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./readme-res/diagrams/dark/viewmodel-viewdata-diagram.dark.svg">
  <img alt="ViewModel/ViewData Diagram" src="./readme-res/diagrams/viewmodel-viewdata-diagram.light.svg">
</picture>

### Group `viewmodel` and `model.repository`
  View Models also serve as a [façade](https://en.wikipedia.org/wiki/Facade_pattern), triggering methods in `model.repository` structs. This diagram shows that each View Model has its own repository struct and illustrates all methods each View Model calls, represented by arrows from View Models to Repositories.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./readme-res/diagrams/dark/viewmodel-repository-diagram.dark.svg">
  <img alt="ViewModel/Repository Relationship Diagram" src="./readme-res/diagrams/viewmodel-repository-diagram.light.svg">
</picture>

### Group `model`
  Model structs handle the logic of the application. This diagram represents all the associations among the structs in the `model`.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./readme-res/diagrams/dark/model-diagram.dark.svg">
  <img alt="Model Diagram" src="./readme-res/diagrams/model-diagram.light.svg">
</picture>

### Group `model.repository` and `model`
  These diagrams represent all the associations among the structs in `model.repository` and `model`.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./readme-res/diagrams/dark/repository-model-diagram.dark.svg">
  <img alt="Repository Model Diagram" src="./readme-res/diagrams/repository-model-diagram.light.svg">
</picture>

## Future Tasks
  - Improve the stability. After some time, the connection between the devices is lost.
  - Use Persistance.
  - Create the app icon.
  - Add more chat features.