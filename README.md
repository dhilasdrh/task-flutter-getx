
# Overview

This is a simple Flutter mobile application developed using GetX library for state management, dependency injection, and navigation, and Get CLI to quickly set up and configure project with GetX architecture and installing essential packages in Flutter.

This project consists of two pages: The `HomeView` displays a list of students with their basic information, and the `DetailView` provides a detailed view of a selected student. It also has a floating action button for adding new student data. The project fetches and parses JSON data from API.  This project also includes error handling mechanisms for scenarios such as no internet connection, failed API calls, and unexpected errors. 

## Get CLI Usage

-   `get create project`: Initializes new Flutter project with the GetX architecture, setting up the essential folder structure and configuration.
-   `get create page:detail`: Generates files and folders for a detail page in the Flutter project.
-   `get generate model from "https://btj-academy-default-rtdb.asia-southeast1.firebasedatabase.app/mahasiswa.json"`: Generates a model class based on JSON data from a specified URL.
-   `get generate model with assets/json/data.json`: Generates a model class based on JSON data from a local asset.
-   `get install loading_animation_widget`: Installs the `loading_animation_widget` package for displaying loading animations.
-   `get install faker`: Installs the `faker` package for generating fake data, used for creating random image URLs.
-   `get install fl_chart`: Installs the `fl_chart` package for integrating charts in the application.
-   `get install connectivity`: Installs the `connectivity` package for monitoring device internet connectivity.

## Key Components

1.  **mahasiswa_model**: Defines the data model for Mahasiswa. Implements methods for converting JSON data to objects and generating random image URLs.
    
2.  **mahasiswa_provider**: Implements the data provider using GetConnect to interact with the backend API. Handles API calls for fetching and posting student data.
    
3.  **home_view**: The main screen of the application that displays a list of students. It utilizes the GetX architecture for state management.
    
4.  **home_controller**: Manages the state and logic for the home view. It handles data fetching, sorting, adding new students, and provides functions for displaying success/error messages.
    
5.  **home_binding**: Binds the dependencies for the home view and controller, ensuring they are available when needed.
    
6.  **detail_view**: Displays detailed information about a selected student, including a graph representing their GPA (IPK).
    
7.  **detail_binding**: Binds the dependencies for the detail view and controller.

# Main Features

## Home Page

- The `HomeView` screen displays a list of students retrieved from API using the `MahasiswaProvider` for data management.
- The UI conditionally rendered based on the application state with GetX's `Obx` widget.
	-   Loading: displays a loading indicator while data is being fetched. The loading used `loading_animation_widget`.
	-   Error: displays an error message if there is an issue fetching data. 
	-   Data Available: displays the list of students when data is successfully loaded
- The student data is stored in a `RxList<Mahasiswa> data` variable.
- The student data is displayed using a `ListView.builder` widget, and each student is displayed with `ListTile` in the list.
- The profile image for each users are generated using `Faker`.
- Each list item is a clickable card that leads to the detailed view of the respective student.
-  `RefreshIndicator` allows users to trigger a refresh of the student list by pulling down on the screen. 

**Loading State and Error State Handling**

- When data is being fetched, a loading widget is displayed to indicate to the user that an operation is in progress.
-  If user encounters issues such as no internet connection or failure to fetch data from the API, the page will display an appropriate error message and button "Retry" to allow users to retry fetching the data.

**Success and Error Messages**

- Success and error messages are displayed to provide feedback to the user, using a `Get.snackBar` with a green background, while error messages use a red background.

**Sorting**

-   Users can sort the student list by name in ascending or descending order using the 'Sort' icon in the `AppBar`.
-   The sorting state is managed using GetX's reactivity (`RxBool sortAscending`) to ensures the UI is automatically updated when the sorting state changes.


## Student Details Page

-   The `DetailView` screen presents detailed information about a selected student, including personal details, academic information, and a GPA graph.
- The graph is displayed using `fl_chart` package.
-   Navigation to this view is achieved using the Get package's `Get.to` method.
-   `DetailView`: Retrieves the selected student's data from the arguments passed during navigation and dynamically builds the UI.


## Add Student Data

-   Users can add a new student through floating action button on the `HomeView` screen, and it will invokes widget `AddDataDialog` to display a dialog with input fields for adding new student information.
-   The `HomeController` handles the logic for adding a new student with `addData` method, which communicates with the API to add a new student.  

**AddDataDialog**
 - The dialog is implemented using the `AlertDialog` widget, providing a clean and organized structure.
 - It uses the `Get.dialog` method to display an `AlertDialog` containing a `Form` with various input fields for student information.

**Form Validation**

-  The `Form` widget is used with a `GlobalKey` for form validation. 
- Each input field has a corresponding `CustomTextField` widget that encapsulates the `TextFormField`.
- Form validation is handled using the `GlobalKey<FormState>` and Flutter's built-in `TextFormField` widgets.
-   The `validator` functions are implemented to ensure that the input fields are not empty, providing user feedback if validation fails.

**CustomTextField**

- Created `CustomTextField` widget that encapsulates a `TextFormField` to create consistent and reusable text input fields throughout the application.
-   It includes parameters for customization, such as `labelText`, `keyboardType`, and optional `validator` functions.

**Save and Cancel Actions**

-   The dialog has two action buttons: 'Save' and 'Cancel'.
-   The "Save" button triggers the validation process, and if successful, it invokes the `addData` method in the `HomeController` to add the new student.
-   The "Cancel" button dismisses the dialog without saving.

**Error Handling**

- If there is an error during the data addition process, an error dialog will be displayed, providing information about the failure and it provides a 'Try Again' option.
- The error messages are displayed using `Get.defaultDialog` to provide immediate feedback to the user.
-   If the user chooses to try again, the dialog remains open with current input, allowing the user to correct the input data.
