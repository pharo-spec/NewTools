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

	| browser1 browser2 group |
	[
		browser1 := StMethodBrowser browseImplementorsOf: #browseImplementorsOf:.
		browser2 := StMethodBrowser browseImplementorsOf: #browseSendersOf:.
		group := StMethodBrowserGroup current.
		self assert: group notebook pages size equals: 2 ] ensure: [
			StMethodBrowserGroup reset.
			group ifNotNil: [ group window delete ] ]
]
