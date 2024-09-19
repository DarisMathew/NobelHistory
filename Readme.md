# Nobel Prize Laureates - iOS Coding Challenge

## Overview

This iOS app displays a list of Nobel Prize laureates, retrieving data from a public API. The app presents the first laureate per year and category for simplicity. The challenge involves improving this app by adding user interaction, infinite scrolling, and filtering functionalities, without using third-party libraries unless explicitly permitted.

**API Documentation**: [SwaggerHub - Nobel Prize API](https://app.swaggerhub.com/apis/NobelMedia/NobelMasterData/2.0#/default/get_nobelPrizes)

## Setup Instructions

1. **Clone the repository**:
    ```bash
    git clone https://github.com/yourusername/nobel-prize-ios.git
    ```
2. **Open the project** in Xcode.
3. **Build and run** the app on a simulator or physical device.

## Tasks

### Task 1: Branch Setup

1. Create and checkout a new branch named `<your-initials>-code-challenge-2-ios` (e.g., `ld-code-challenge-2-ios`).
2. Push this branch to the origin:
    ```bash
    git push -u origin <your-branch-name>
    ```

---

### Task 2: Display Laureate Details

1. Enhance the app so that tapping on a laureate in the list pushes a new view controller that displays laureate details.
2. Details should include:
    - Name
    - Gender
    - Date and place of birth
    - Date and place of death (if applicable)
3. Commit and push your changes.

---

### Task 3: Infinite Scroll

1. Implement infinite scrolling in the laureates list.
    - Use the API's `offset` and `limit` parameters to fetch more laureates as the user scrolls down.
    - Ensure that new data is appended to the existing list without resetting the view.
2. Commit and push your work.

---

### Task 4: Filter Laureates by Category

1. Add a filter button to the navigation bar.
2. Tapping the filter button should display a sheet view that allows users to filter by category:
    - Chemistry (`che`)
    - Economics (`eco`)
    - Literature (`lit`)
    - Peace (`pea`)
    - Physics (`phy`)
    - Medicine (`med`)
    - All (no filter)
3. After a selection, the sheet should close, and a new API request should be made with the selected category as a filter.
4. Commit and push your changes.

---

## Key Technologies Used

- **Swift**: The primary language for development.
- **UIKit**: Used for building the app's UI components.
- **URLSession**: For making HTTP requests to fetch Nobel Prize laureate data.
- **MVVM**: The Model-View-ViewModel architecture is used to separate concerns and keep the code modular and testable.

## Future Improvements

Here are some additional enhancements that could be implemented with more time:
- **Unit and UI Testing**: Expanding test coverage, especially for networking and UI interactions.
- **Error Handling**: Display more user-friendly error messages for network issues (e.g., no internet).
- **Caching**: Implement data caching to reduce network calls when the user revisits previously loaded data.
- **Design Enhancements**: Improve UI/UX for a more polished and interactive experience.

