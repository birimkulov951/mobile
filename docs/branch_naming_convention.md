## Branch rules
Rules for PR/branch:

1. Branch name must correspond to the JIRA ticket number. e.g. if the task number is PM-1234,
   branch name has to be named PM-1234.
2. Branch name **prefixes**: `feature/`, `release/` or `hotfix/`.
3. Make sure that your code is formatted and it doesn't have any unrelated functionality.
4. Run `flutter analyze`.
5. Squash wip commits and reduce their number as much as possible before opening pull request.
6. Commit message structure:
    - Header with task number and task title from the jira ticket. It is possible to use title from 
      the story ticket, e.g. PM-1234: Awesome feature
    - points done in this commit, e.g:
        - done this
        - done that
        - created awesome feature
7. Pull request structure:
   - Should contain all information from the commit
   - In addition should be provided details if the implementation was tested on test/prod environment on specific device, e.g:
        Tested on test:
           - Google Pixel 3 (Android 10).
   - QA notes - anything that can help QA to test this changes properly (If applicable)
8. Pull request has to be merged as a single commit, unless it is a `feature/` branch merging into `develop`.

```
Commit message examples: 
   PM-1234: Awesome feature
        - done this
        - done that
        - made it work
        - refactored this thing
```

```
Pull request message example:
    PM-1234: Awesome feature
        - done this
        - done that
        - made it work
        - refactored this thing
    Tested on test:
        - Tested on Nexus One (Android 11)
        - Tested on iPhone 12 simulator (iOS 15.2)
    QA notes:
        - This commit may affect ${other feature}. Make sure to check it.
```
## [Back | Contents](contents.md)