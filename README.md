Author: Roy Ng (roytornado@gmail.com)

# Intro
Devleopers! Making your code consistency, simple, readable are the key to a good code.
Creating things are not enough. Making it maintainable save your life (and your teammates) in the future.

# Env
- XCode 12
- Pod 1.10.0

# Frist Run
- pod install
- open workspace
- run on simualtor

ps. remember to change bundle id when you assigning a team for signing

# Common Practices
- Try your best to make view controllers small and clean. Breaking down responsibilities is always true.
- Keeping you classes in XCode and files in folders in sync. Same hierarchy just like Android's.
- Make sure that you know how to do multilingual (even your app is single language): Sync text from Google Doc; Think good string's key; Use generated global variables (ResHeader.swift) in code; Use in XIBs using IBInspectable + extension
- Separate storyboards in a good way: Not too many storyboards (one storyboard per screen); Not too many screens in one storyboard
- TableDataManager is your friend. Playing UITableViewDelegate/UITableViewDataSource inside view controllers is always stupid.
- Always consider about pagination and pull to refresh handling when showing data in table view/collection view
- Animations are essential for any touchable area (buttons/cells). Make a simple one yourself or ask the designers.
- Flow SDK (yep it's made by me) is a good example that how to simplify complicated chained operations using Composite pattern and Chain-of-responsibility pattern. You may think RxSwift can do the same things. But Flow is much more readable. Yes, again "readable" is very important.
- Please make sure the naming, coding styles and syntax consistent across all codes (even with Android's side). Even many developers are involved in the project. Follow one or change all.

# Summary
**Consistency**, **Simple**, **Readable**

