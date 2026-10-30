Class {
	#name : 'StMethodBrowserGroupTest',
	#superclass : 'TestCase',
	#instVars : [
		'openedBrowsers'
	],
	#category : 'NewTools-MethodBrowsers-Tests',
	#package : 'NewTools-MethodBrowsers-Tests'
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
