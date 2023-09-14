Class {
	#name : #StPlaygroundTest,
	#superclass : #StPlaygroundBaseTest,
	#category : #'NewTools-Playground-Tests'
}

{ #category : #running }
StPlaygroundTest >> classToTest [

	^ StPlaygroundPresenter
]

{ #category : #running }
StPlaygroundTest >> initializeInstanceBeforeInitialization: aPresenter [

	aPresenter setModelBeforeInitialization: self newPage
]

{ #category : #'instance creation' }
StPlaygroundTest >> newPlayground [

	^ StPlaygroundPresenter 
		newApplication: application
		model: self newPage
		
]

{ #category : #tests }
StPlaygroundTest >> testContents [

	presenter open.
	self waitUntilUIRedrawed.
	presenter contents: 'Test'.
	presenter page flush.
	self assert: presenter model contents equals: 'Test'
]

{ #category : #tests }
StPlaygroundTest >> testLoadPage [

	| page |
	presenter open.
	self waitUntilUIRedrawed.
	presenter contents: 'Test 1'.
	presenter page flush.

	page := self newPage
		        contents: 'Test 2';
		        flush;
		        yourself.
	presenter loadPage: page fileReference.
	self waitUntilUIRedrawed.
	self assert: presenter page contents equals: page contents
]

{ #category : #tests }
StPlaygroundTest >> testNewInspectorForWorksWhenModelIsNil [
	| inspectorPanel |

	inspectorPanel := presenter newInspectorFor: nil.
	self assert: inspectorPanel notNil.
	self assert: (inspectorPanel isKindOf: StObjectInspectorPresenter)
]

{ #category : #tests }
StPlaygroundTest >> testStopProcessing [

	| page |
	presenter open.
	self waitUntilUIRedrawed.
	page := self newPage
		        contents: 'Test 1';
		        flush;
		        yourself.
	presenter loadPage: page fileReference.
	self waitUntilUIRedrawed.
	"a lot of time"
	presenter page timeToWait: 1 minute.
	presenter contents: 'Test 2'.
	"no time to flush"
	self assert: page contents equals: 'Test 1'.
	"now we can close and test."
	presenter window close.
	self assert: page contents equals: 'Test 2'
]
