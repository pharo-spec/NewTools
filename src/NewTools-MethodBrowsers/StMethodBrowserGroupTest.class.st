Class {
	#name : 'StMethodBrowserGroupTest',
	#superclass : 'TestCase',
	#category : 'NewTools-MethodBrowsers-Tests',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Tests'
}

{ #category : 'tests' }
StMethodBrowserGroupTest >> testAddTabCreatesNewPage [

	| browser group |
	[
		browser := StMethodBrowser browseImplementorsOf: #browseImplementorsOf:.
		group := StMethodBrowserGroup current.
		self assert: group notebook pages size equals: 1.
		self assert: group notebook selectedPage title equals: browser windowTitle ] ensure: [
			StMethodBrowserGroup reset.
			group ifNotNil: [ group window delete ] ]
]

{ #category : 'tests' }
StMethodBrowserGroupTest >> testAddTwoTabsReusesSameGroup [

	| group |
	[
		StMethodBrowser browseImplementorsOf: #browseImplementorsOf:.
		StMethodBrowser browseImplementorsOf: #browseSendersOf:.
		group := StMethodBrowserGroup current.
		self assert: group notebook pages size equals: 2 ] ensure: [
			StMethodBrowserGroup reset.
			group ifNotNil: [
					group window delete.
					group window delete ] ]
]

{ #category : 'tests' }
StMethodBrowserGroupTest >> testCloseBoxHitClosesEntireWindow [

	| group |
	[
		StMethodBrowser browseImplementorsOf: #browseImplementorsOf:.
		StMethodBrowser browseImplementorsOf: #browseSendersOf:.
		group := StMethodBrowserGroup current.
		self assert: group notebook pages size equals: 2.
		group window window closeBoxHit.

		self assert: group isDisplayed not ] ensure: [ StMethodBrowserGroup reset ]
]

{ #category : 'tests' }
StMethodBrowserGroupTest >> testRemovePageWhenMultipleDoesNotCloseTheGroup [

	| group |
	[
		StMethodBrowser browseImplementorsOf: #browseImplementorsOf:.
		StMethodBrowser browseSendersOf: #printOn:.
		group := StMethodBrowserGroup current.
		self assert: group notebook pages size equals: 2.
		group window delete.
		self assert: group notebook pages size equals: 1 ] ensure: [
			StMethodBrowserGroup reset.
			group ifNotNil: [ group window delete ] ]
]
