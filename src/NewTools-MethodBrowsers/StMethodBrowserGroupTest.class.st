Class {
	#name : 'StMethodBrowserGroupTest',
	#superclass : 'TestCase',
	#instVars : [
		'openedBrowsers'
	],
	#category : 'NewTools-MethodBrowsers-Tests',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Tests'
}

{ #category : 'private' }
StMethodBrowserGroupTest >> browsingGroupOf: aStMethodBrowser [

	^ aStMethodBrowser methodList browsingGroup
]

{ #category : 'private' }
StMethodBrowserGroupTest >> registerBrowser: aStMethodBrowser [

	openedBrowsers add: aStMethodBrowser.
	^ aStMethodBrowser
]

{ #category : 'running' }
StMethodBrowserGroupTest >> setUp [

	super setUp.
	openedBrowsers := OrderedCollection new
]

{ #category : 'running' }
StMethodBrowserGroupTest >> tearDown [

	openedBrowsers do: [ :browser | browser withWindowDo: #close ].
	super tearDown
]

{ #category : 'tests' }
StMethodBrowserGroupTest >> testAddingBrowserInSameGroupAddsTab [

	| browser1 browser2 group |
	browser1 := self registerBrowser: (StMethodBrowser browseImplementorsOf: #browseImplementorsOf:).
	group := self browsingGroupOf: browser1.
	browser2 := self registerBrowser: (StMethodBrowser methods: { StMethodBrowserTest >> #testExplicitBrowseSenders }).
	group addBrowser: browser2.
	
	self assert: group notebook pages size equals: 2
]

{ #category : 'tests' }
StMethodBrowserGroupTest >> testBrowseOpensNewGroupWindowHostingTheBrowserTab [

	| browser group |
	browser := self registerBrowser: (StMethodBrowser browseImplementorsOf: #browseImplementorsOf:).
	group := self browsingGroupOf: browser.
	
	self assert: group isNotNil.
	self assert: group class equals: StMethodBrowserGroup.
	self assert: group notebook pages size equals: 1.
	self assert: group notebook selectedPage title equals: browser windowTitle
]

{ #category : 'tests' }
StMethodBrowserGroupTest >> testBrowsingGroupWhenBrowserHostedReturnsItsGroup [ 

	| browser group list |
	browser := self registerBrowser: (StMethodBrowser browseImplementorsOf: #browseImplementorsOf:).
	group := self browsingGroupOf: browser.
	list := browser methodList.
	
	self assert: list browsingGroup equals: group.
	self assert: group class equals: StMethodBrowserGroup
]

{ #category : 'tests' }
StMethodBrowserGroupTest >> testCloseCurrentTabClosesOnlyActiveTab [

	| browser addedBrowser group |
	browser := self registerBrowser: (StMethodBrowser browseImplementorsOf: #browseImplementorsOf:).
	group := self browsingGroupOf: browser.
	addedBrowser := self registerBrowser: (StMethodBrowser methods: { (StMethodBrowserTest >> #testExplicitBrowseSenders) }).
	group addBrowser: addedBrowser.
	self assert: group notebook pages size equals: 2.

	group closeCurrentTab.

	self assert: group notebook pages size equals: 1
]

{ #category : 'tests' }
StMethodBrowserGroupTest >> testCloseCurrentTabOnDirtyTabAsksBeforeDiscarding [

	| browser group |
	browser := self registerBrowser: (StMethodBrowser browseImplementorsOf: #browseImplementorsOf:).
	group := self browsingGroupOf: browser.
	browser textPresenter markDirty.
	self assert: browser isDirty.

	self withDiscardConfirmation: false on: group during: [ group closeCurrentTab ].
	browser textPresenter unmarkDirty.

	self assert: group notebook pages size = 1 description: 'Declined discard should keep the dirty tab open'
]

{ #category : 'tests' }
StMethodBrowserGroupTest >> testCloseCurrentTabOnDirtyTabClosesAfterDiscardConfirmation [

	| browser group |
	browser := self registerBrowser: (StMethodBrowser browseImplementorsOf: #browseImplementorsOf:).
	group := self browsingGroupOf: browser.
	browser textPresenter markDirty.
	self assert: browser isDirty.

	self withDiscardConfirmation: true on: group during: [ group closeCurrentTab ].

	self assert: group notebook pages isEmpty
]

{ #category : 'tests' }
StMethodBrowserGroupTest >> testCloseCurrentTabOnLastTabClosesWindow [

	| browser group |
	browser := self registerBrowser: (StMethodBrowser browseImplementorsOf: #browseImplementorsOf:).
	group := self browsingGroupOf: browser.
	self assert: group notebook pages size equals: 1.

	group closeCurrentTab.
	
	self assert: group notebook pages isEmpty.
	self assert: group isDisplayed not description: 'Closing the last tab should close the whole window'
]

{ #category : 'tests' }
StMethodBrowserGroupTest >> testClosingWindowClosesTheWholeGroupWindow [

	| browser1 browser2 group |
	browser1 := self registerBrowser: (StMethodBrowser browseImplementorsOf: #browseImplementorsOf:).
	group := self browsingGroupOf: browser1.
	browser2 := self registerBrowser: (StMethodBrowser methods: { (StMethodBrowserTest >> #testExplicitBrowseSenders) }).
	group addBrowser: browser2.
	self assert: group notebook pages size equals: 2.
	
	group window delete.
	self deny: group isDisplayed description: 'Closing the window should close the whole browser, not remove the latest tab'
]

{ #category : 'tests' }
StMethodBrowserGroupTest >> testTwoBrowsesOpenTwoDistinctNewWindows [

	| browser1 browser2 group1 group2 |
	browser1 := self registerBrowser: (StMethodBrowser browseImplementorsOf: #browseImplementorsOf:).
	group1 := self browsingGroupOf: browser1.
	browser2 := self registerBrowser: (StMethodBrowser browseImplementorsOf: #browseSendersOf:).
	group2 := self browsingGroupOf: browser2.

	self assert: group1 isNotNil.
	self assert: group2 isNotNil.
	self deny: group1 equals: group2.
	self assert: group1 notebook pages size equals: 1.
	self assert: group2 notebook pages size equals: 1
]

{ #category : 'helpers' }
StMethodBrowserGroupTest >> withDiscardConfirmation: anAnswer on: aGroup during: aBlock [

	| topWindow originalApplication confirmationStub |
	topWindow := aGroup nearWindow.
	originalApplication := topWindow application.
	confirmationStub := StMethodBrowserGroupTestProxy new
		                    wrapped: originalApplication;
		                    confirmAnswer: anAnswer.
	topWindow application: confirmationStub.
	^ [ aBlock value ] ensure: [ topWindow application: originalApplication ]
]
