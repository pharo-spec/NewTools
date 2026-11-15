"
I test `StWelcomeBrowser`, the window welcoming the user to Pharo with its topic pages, at the presenter level, without opening it.

## Responsibility:

- Check that its paginator is created through it, so that it belongs to it and uses its application (it used to fall back to `SpNullApplication`).
- Check that the paginator shows one page at a time, like the miller list it is chained to.

## Internal Representation

- `browser`: the presenter under test, not opened.
"
Class {
	#name : 'StWelcomeBrowserTest',
	#superclass : 'TestCase',
	#instVars : [
		'browser'
	],
	#category : 'NewTools-WelcomeBrowser-Tests',
	#package : 'NewTools-WelcomeBrowser-Tests'
}

{ #category : 'running' }
StWelcomeBrowserTest >> setUp [

	super setUp.
	browser := StWelcomeBrowser new
]

{ #category : 'tests' }
StWelcomeBrowserTest >> testPaginatorIsOwnedByTheBrowser [

	self assert: browser paginator owner identicalTo: browser
]

{ #category : 'tests' }
StWelcomeBrowserTest >> testPaginatorShowsOnePage [

	self assert: browser paginator visiblePages equals: 1
]

{ #category : 'tests' }
StWelcomeBrowserTest >> testPaginatorUsesTheBrowserApplication [

	self assert: browser paginator application identicalTo: browser application
]
