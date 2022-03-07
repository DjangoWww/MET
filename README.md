# MET

- ## Description
  Basically using MVVM + RxSwift + Moya + PromiseKit to build this demo app.

  The main file is inside `MET/Modules/`, `MET/Service/ServerProvider` and `MET/Constants/ServerAPI`, with some other files just for extension and other purposes

  We have two main screens.
  - FirstPageVC: type in the key works in searchBar, and hit `search` button for the leftBarButtonItem to get the result. The rightBarButtonItem `clear all` is used to clear all the image caches.

  - SecondPageVC: The rightBarButtonItem `clear one` is used to clear the specific cache for this page. You can `tap` on the image to show additional images gallery.


- ## Requirements
  - Xcode Version 13.1 (13A1030d)

  - Swift Version 5.5 (swiftlang-1300.0.31.1 clang-1300.0.29.1)


- ## Installation Instructions
  - Install Xcode Version 13.1 (13A1030d) and open MET.xcworkspace file with Xcode

  - You can try `pod install` in case there's some pods missing


- ## About test
  You can find it in `METTests.swift`, only added a few test cases since it's just a demo app.
  - FirstPageVMTests
    - testInitialState to test if the InitialState is correct
    - testReqSearch to test if testReqSearch gets the correct response

  - SecondPageVMTests
    - testInitialState to test if the InitialState is correct
    - testIfGetObjectIsCorrect to test if the result get correct answer for request getObject

  - ServerProviderTests
    - testGetSingleObject to test if the provider is working correctly when getting a single object
    - testGetManyObject to test if the provider is working correctly when getting many object
    - testGetRandomObject to get random object using the result of getObjects request
    - _getObjectPromise to create a promise for other funcs to use
    - _getObject to see if the provider is working correctly


- ## Dependency Injection
  Check out `ServerProvider`, set `shouldUseStubClosure` for request mocking, notice that it won't work if it's not `DEBUG`. And you can move to the param while initializing, depends on the situation, i choose to put it here as variable since it's easy to test.


- ## File tree
  Check `Tree.md` file


- ## Others
  Feel free to point out if there's something wrong with the architecture, like over engineering or lack of considerations in somewhere. And about UI, i choose a simple UI since it's just a `demo app`, but of cause i can `manage nesty views` also, so don't worry about it.
