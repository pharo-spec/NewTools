Class {
	#name : #StPlaygroundTest,
	#superclass : #TestCase,
	#instVars : [
		'playground',
		'backendForTest',
		'memoryFileSystem',
		'application'
	],
	#category : #'NewTools-Playground-Tests'
}

{ #category : #'instance creation' }
StPlaygroundTest >> newPage [ 

	^ StPlaygroundPage new 
		timeToWait: 5 milliSeconds;
		baseDirectory: memoryFileSystem;
		yourself
]

{ #category : #'instance creation' }
StPlaygroundTest >> newPlayground [

	^ StPlayground 
		newApplication: application
		model: self newPage
		
]

{ #category : #running }
StPlaygroundTest >> setUp [
	super setUp.
	
	memoryFileSystem := FileSystem memory.
	backendForTest := SpMorphicBackendForTest new.
	application := StPharoApplication new.
	playground := self newPlayground
]

{ #category : #running }
StPlaygroundTest >> tearDown [

	playground window close.
	super tearDown
]

{ #category : #tests }
StPlaygroundTest >> testContents [

	playground openWithSpec.
	self waitUntilUIRedrawed.
	playground contents: 'Test'.
	playground page flush.
	self 
		assert: playground model contents 
		equals: 'Test'.
		
	
]

{ #category : #tests }
StPlaygroundTest >> testLoadPage [
	| page |

	playground openWithSpec.
	self waitUntilUIRedrawed.
	playground contents: 'Test 1'.
	playground page flush.

	page := self newPage
		contents: 'Test 2';
		flush;
		yourself.
	playground loadPage: page fileReference.
	self waitUntilUIRedrawed.
	self 
		assert: playground page contents 
		equals: page contents
]

{ #category : #tests }
StPlaygroundTest >> testStopProcessing [
	| page |

	playground openWithSpec.
	self waitUntilUIRedrawed.
	page := self newPage
		contents: 'Test 1';
		flush;
		yourself.
	playground loadPage: page fileReference.
	self waitUntilUIRedrawed.
	"a lot of time"
	playground page timeToWait: 1 minute.
	playground contents: 'Test 2'.
	"no time to flush"
	self assert: page contents equals: 'Test 1'.
	"now we can close and test."
	playground window close.
	self assert: page contents equals: 'Test 2'.
	
]

{ #category : #private }
StPlaygroundTest >> waitUntilContentsAreFlush [
		
	20 milliSeconds wait
	
]

{ #category : #private }
StPlaygroundTest >> waitUntilUIRedrawed [

	backendForTest waitUntilUIRedrawed
]
