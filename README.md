## Exercise Acceptance Criteria

### State Machine

   Add the states that are missing and complete the reducer 

### ViewModel Mapping

    - "Title" label should depend on the rating value: 1 - Title.veryBad, 2: Title.bad, 3: Title.ok, 4: Title.good, 5: Title.great (HINT: You have an enum with all the values)
    - "Text" label should depend on the rating value: Less than 4: Text.requestExplanation (HINT: You have an enum with all the values)
    - The color of the stars should depend on the rating value:
        - From 1 to 2: Red
        - From 3 to 4: Yellow
        - 5: Green
        (HINT: You have an enum with all the values)
    - Explanation placeholder should be optional when rating more than 3 stars.
    - Explanation and submit button are hidden until the users taps in any star
    - Submit button is enabled when rating is more than 3 stars or comment is not empty.
    - Submit button should say "Submitting" while doing the network request.

### Unit Test

   Add at least one unit test to test the Acceptance Criteria. Suggestion: Stars color mapping.
