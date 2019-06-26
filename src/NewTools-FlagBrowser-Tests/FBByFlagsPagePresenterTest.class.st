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

{ #category : #tests }
FBByFlagsPagePresenterTest >> selectFlagaRandomFalgForTest [
	flagPage flagsList
		selectIndex:
			((flagPage flagsList items collect: #parameter)
				indexOf: #aRandomFlagForTest)
]

{ #category : #tests }
FBByFlagsPagePresenterTest >> testWhenCaseSensitiveChangeShouldDisplayTODOAndtodo [
	"caseSensitive when use to merge capitalized and not capitalized charracter"

	| flagListItem |
	flagPage caseCheckbox state
		ifTrue: [ flagPage caseCheckbox click ].
	flagListItem := flagPage flagsList items collect: #parameter.
	self
		assert:
			((flagListItem includes: #Test)
				and: [ (flagListItem includes: #test) not
						and: [ (flagListItem includes: #TEST) not ] ]).
	flagPage caseCheckbox click.
	flagListItem := flagPage flagsList items collect: #parameter.
	self
		assert:
			((flagListItem includes: #TEST)
				and: [ (flagListItem includes: #test) 
						and: [ (flagListItem includes: #Test) not ] ])
]

{ #category : #tests }
FBByFlagsPagePresenterTest >> testWhenFlagsListSelectedItemChangeShouldSendToLocationsTableLocationsOfSelectedItemAndSelectedIndexEquals1 [
	self selectFlagaRandomFalgForTest.
	self
		assert: (flagPage locationsTable items collect: #selector)
		equals: {#flagMethod2 . #flagMethod} asOrderedCollection.
	self
		assert: flagPage locationsTable selection selectedIndex
		equals: 1
]

{ #category : #tests }
FBByFlagsPagePresenterTest >> testWhenModeDropboxSelectedItemChangeShouldSendToFlagsListAllFlagsOfSelectedItem [
	flagPage modeDropbox
		selectedIndex:
			((flagPage modeDropbox listItems collect: #name)
				indexOf: #FBStringFlag).
		self assert:  ((flagPage flagsList  items collect: #parameter) includes:'a flag for Test flagBrowser')
]
