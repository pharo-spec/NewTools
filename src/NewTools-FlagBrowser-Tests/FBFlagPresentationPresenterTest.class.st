"
A FBFlagPresentationPresenterTest is a test class for testing the behavior of FBFlagPresentationPresenter
"
Class {
	#name : #FBFlagPresentationPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'flagPage'
	],
	#category : #'NewTools-FlagBrowser-Tests-Presenters'
}

{ #category : #testing }
FBFlagPresentationPresenterTest class >> isAbstract [
	^ self = FBFlagPresentationPresenterTest
]

{ #category : #running }
FBFlagPresentationPresenterTest >> getLocationFlagMethod [
	^ FBLocation class: FBMock selector: #flagMethod interval: (1 to: 5)
]

{ #category : #running }
FBFlagPresentationPresenterTest >> getLocationFlagMethod2 [
	^ FBLocation class: FBMock selector: #flagMethod2 interval: (5 to: 7)
]

{ #category : #running }
FBFlagPresentationPresenterTest >> instanciateFlagPage [
	^ self subclassResponsibility
]

{ #category : #running }
FBFlagPresentationPresenterTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."

	flagPage := self instanciateFlagPage.
	flagPage locationsTable
		items:
			{self getLocationFlagMethod.
			self getLocationFlagMethod2}
]

{ #category : #tests }
FBFlagPresentationPresenterTest >> testWhenDoubleClickOnLocationsTableShouldCallOpenInBrowserMethod [
	| mock |
	mock := FBMockUseToTestDoubleClickAction new.
	flagPage locationsTable items: {mock}.
	flagPage locationsTable doubleClickAtIndex: 1.
	self assert: mock isOpenInBrowserCall
]

{ #category : #tests }
FBFlagPresentationPresenterTest >> testWhenSelectedItemChangedShouldCodeContainsSourceCode [
	flagPage locationsTable selectIndex: 2.
	self
		assert: flagPage locationsTable selection selectedItem sourceCode
		equals: flagPage code text.
	self
		assert: flagPage code behavior
		equals: flagPage locationsTable selection selectedItem classLocation
]

{ #category : #tests }
FBFlagPresentationPresenterTest >> testWhenTextIsAcceptedShouldCompileIt [
	| mock |
	mock := FBClassMock new.
	flagPage code behavior: mock.
	flagPage code text: 'test'.
	flagPage code accept.
	self assert: mock isCompileCall
]
