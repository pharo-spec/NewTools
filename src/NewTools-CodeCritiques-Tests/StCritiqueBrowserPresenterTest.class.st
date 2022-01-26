"
A StCritiqueBrowserTest is a test class for testing the behaivor of StCritiqueBrowserPresenter
"
Class {
	#name : #StCritiqueBrowserPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'critiqueBrowser',
		'rules'
	],
	#category : #'NewTools-CodeCritiques-Tests'
}

{ #category : #initialization }
StCritiqueBrowserPresenterTest >> classToTest [

	^ StCritiqueBrowserPresenter
]

{ #category : #running }
StCritiqueBrowserPresenterTest >> setUp [

	super setUp.
	critiqueBrowser := StCritiqueBrowserPresenter new.
	rules := (ReRuleManager visibleRuleClasses collect: [ :aClass | 
		          aClass new ]) sorted: [ :a :b | a name < b name ].
]

{ #category : #initialization }
StCritiqueBrowserPresenterTest >> testBrowseRule [

	| windowBrowser singleRule |
	singleRule := rules first.
	critiqueBrowser rules: rules.
	critiqueBrowser rulesModel selectItem: singleRule.
	windowBrowser := critiqueBrowser browseRule.
	self assert: windowBrowser class equals: ClyFullBrowserMorph.
	windowBrowser close.
	
]

{ #category : #initialization }
StCritiqueBrowserPresenterTest >> testInitializePresenters [

	self
		assert: critiqueBrowser rulesModel class
		equals: SpTreeTablePresenter.
	self
		assert: critiqueBrowser sourceCodeModel class
		equals: SpCodePresenter.
	self
		assert: critiqueBrowser toolbarModel class
		equals: StCritiqueToolbarPresenter.
	self
		assert: critiqueBrowser critiquesModel class
		equals: SpListPresenter
]

{ #category : #initialization }
StCritiqueBrowserPresenterTest >> testOpen [

	| window |
	window := self classToTest open.
	self assert: window isBuilt.
	window close
]
