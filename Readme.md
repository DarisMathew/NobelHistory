# Nobel Prize Laureates - iOS Coding Challenge

## Overview

This iOS app displays a list of Nobel Prize laureates, retrieving data from a public API. The app presents the first laureate per year and category for simplicity. The challenge focuses on enhancing the app by implementing user interactions, infinite scrolling, and filtering capabilities, while following modern iOS development best practices.

**API Documentation**: [SwaggerHub - Nobel Prize API](https://app.swaggerhub.com/apis/NobelMedia/NobelMasterData/2.0#/default/get_nobelPrizes)

## Setup Instructions

1. **Clone the repository**:
    ```bash
    git clone https://github.com/yourusername/nobel-prize-ios.git
    ```
2. **Open the project** in Xcode.
3. **Build and run** the app on a simulator or physical device.

## Features and Enhancements

### Laureate Details View

The app allows users to tap on a laureate in the list, which navigates them to a detailed view displaying information about the selected laureate. The details view shows:

- Name
- Gender
- Date and place of birth
- Date and place of death (if applicable)

This enhances the user experience by providing more in-depth information for each Nobel laureate.

### Infinite Scrolling

To improve usability when browsing through the laureates, the app implements infinite scrolling. As users reach the end of the current list, the app automatically loads more laureates from the API using pagination. The API’s `offset` and `limit` parameters are used to control this behavior, ensuring that additional data is fetched seamlessly and appended to the list.

### Filter by Category

A filter feature has been added to the navigation bar. By tapping the filter button, users can select one of the following Nobel Prize categories:

- Chemistry (`che`)
- Economics (`eco`)
- Literature (`lit`)
- Peace (`pea`)
- Physics (`phy`)
- Medicine (`med`)
- All (no filter)

Selecting a category will close the filter sheet and trigger a new API request to display laureates from the chosen category. This adds more flexibility and control for users who are interested in specific Nobel Prize fields.

## Key Technologies Used

- **Swift**: The primary language for development.
- **UIKit**: Used to build the app's user interface components.
- **URLSession**: Handles network requests to fetch Nobel Prize laureate data from the API.
- **MVVM Architecture**: The app follows the Model-View-ViewModel pattern to ensure separation of concerns and better maintainability.

## Future Enhancements

Here are some potential areas for future improvements:

- **Unit and UI Testing**: Expanding test coverage, especially for networking, infinite scrolling, and the filtering feature.
- **Error Handling**: Improve user-facing error messages and handling for network-related issues (e.g., retry options or offline support).
- **Data Caching**: Implement local data caching to reduce network calls and improve performance when revisiting previously loaded data.
- **UI/UX Improvements**: Refine the visual design and transitions to create a smoother and more polished user experience.

---

This project serves as a foundation for creating a more interactive and feature-rich Nobel Prize app. The focus is on functionality, clean architecture, and user experience enhancements such as infinite scrolling and category-based filtering.
