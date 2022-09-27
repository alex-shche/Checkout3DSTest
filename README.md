Application doesn't have any third-party dependencies and should run without any setup

The app utilises MVVM + Coordinator pattern. The Coordinator is called AppFlow and is responsible for handling actions and navigation.

Known issues:

1. Due to lack of time, the validation of the card is very primitive and doesn't take into consideration card type. It only checks that the input contains digits and is not empty.
2. Masks are not used for the input fields. This is maybe very confusing in ExpiryDate field, because the user has to enter the date as a sequence of 6 digits. The keyboard doesn't have slash and there is no mask - bad UX, but no time to implement the mask.
3. On webview screen, if user zooms in (selects input field) it's very hard / impossible to close the modal view using swipe down gesture.
4. There are no error states/reload/loading states on webview screen. So, if loading of URL fails due to connectivity issues, the user has to make a new payment
5. The tests cover only CardInputViewModel and are implemented to illustrate how mocks can be used to reproduce different scenarios. Other view models, AppFlow, Repository, ApiService can be tested in a similar manner.
6. Some strange errors in the console about autolayout and entitlements.
