"
A FBByFlagsPagePresenterTest is a test class for testing the behavior of FBByFlagsPagePresenter
"
Class {
	#name : #FBByFlagsPagePresenterTest,
	#superclass : #FBFlagPresentationPresenterTest,
	#category : #'NewTools-FlagBrowser-Tests-Presenters'
}

{ #category : #running }
FBByFlagsPagePresenterTest >> instanciateFlagPage [
	^ FBByFlagsPagePresenter new
]
