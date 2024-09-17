# Coding challenge (iOS)

## Information
This repository contains a simple iOS app. It displays a list of nobel prize 
laureates. The data is retreived from a public API. Swagger Documentation of 
this API can be found here: 
[SwaggerHub](https://app.swaggerhub.com/apis/NobelMedia/NobelMasterData/2.0#/default/get_nobelPrizes) 

For simplicity's sake, we will always just display the first laureate per year 
and category. *Sorry to all other great recipients of this high honour*

Your tasks will focus around improving this app by adding some functionality.
You are allowed to search the internet, but the use of AI tools like ChatGPT 
is not allowed. Please refrain from adding any 3rd party libraries. If you feel
you would really benefit from adding any dependency please ask us. 

You may change all of the provided code. The GUI should be as functional and 
usable as possible, but please do not spend to much time on aestetics.
We added a very basic successful test case. You can add any additional tests 
you like. 

If any tasks or requirements are unclear to you, feel free to ask any questions 
you might have.

**We are not expecting you to finish all tasks listed below.**

Lets get started!

### Task 1
- Create and checkout a new branch of `main` named with your initials followed by 
`-code-challenge-2-ios` (e.g. `ld-code-challenge-2-ios`)
- Push this branch to the origin

### Task 2
- The service class already contains code to fetch details for a specific price 
winner. Enhance the list to handle user selection.
- Tapping on a row should push a new view controller
- This view should display some of the details retreived from the API
- The model already supports `gender`, please add information for date and place 
of birth and death (if applicable) as well
- Commit and push your changes to git

### Task 3
- Currently the app just displays the first set of entries
- Implement an infinite scroll for the collection
- The API provides `offset` and `limit` parameters to help you achieve this
- Commit and push your work to the repository

### Task 4
- Add a filter button to the navigation bar
- Tapping that button shows a sheet view
- The sheet has a way to select one of the following categories:
*(These values are not subject to change any time soon)*
    - Chemistry: che 
    - Economics: eco
    - Literature: lit
    - Peace: pea
    - Physics: phy
    - Medicine: med
    - All
- Selecting a value closes the sheet and a call to the API is made using the
selected value as a filter parameter. (selecting `All` clears the filter)
- Commit and push any changes made to git

## Conclusion
We hope you had fun with this coding challenge! You have now implemented an 
infinitely scrolling collection with item selection, a detail view and filtering.