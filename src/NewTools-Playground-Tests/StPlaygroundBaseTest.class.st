Class {
	#name : #StPlaygroundBaseTest,
	#superclass : #TestCase,
	#instVars : [
		'backendForTest',
		'application',
		'presenter',
		'memoryFileSystem'
	],
	#category : #'NewTools-Playground-Tests'
}

{ #category : #testing }
StPlaygroundBaseTest class >> isAbstract [

	^ super isAbstract or: [ self = StPlaygroundBaseTest ]
]

{ #category : #accessing }
StPlaygroundBaseTest >> classToTest [

	^ self subclassResponsibility
]

{ #category : #running }
StPlaygroundBaseTest >> initializeInstance: aPresenter [
	
]

{ #category : #running }
StPlaygroundBaseTest >> initializeInstanceBeforeInitialization: aPresenter [
	
]

{ #category : #running }
StPlaygroundBaseTest >> initializeMemoryFileSystem: aFileSystem [
]

{ #category : #'instance creation' }
StPlaygroundBaseTest >> newPage [ 

	^ StPlaygroundPage new 
		timeToWait: 5 milliSeconds;
		baseDirectory: memoryFileSystem;
		yourself
]

{ #category : #'private - utilities' }
StPlaygroundBaseTest >> openInstance [

	presenter open
]

{ #category : #running }
StPlaygroundBaseTest >> setUp [
	super setUp.
	
	backendForTest := SpMorphicBackendForTest new.
	application := StPharoApplication new.
	
	memoryFileSystem := FileSystem memory.
	self initializeMemoryFileSystem: memoryFileSystem.
		
	presenter := self classToTest basicNew. 
	self initializeInstanceBeforeInitialization: presenter.
	presenter application: application.
	presenter initialize.
	self initializeInstance: presenter
]

{ #category : #running }
StPlaygroundBaseTest >> tearDown [

	presenter withWindowDo: [ :window | window close ].
	super tearDown
]

{ #category : #'private - utilities' }
StPlaygroundBaseTest >> waitUntilContentsAreFlush [
		
	20 milliSeconds wait
	
]

{ #category : #'private - utilities' }
StPlaygroundBaseTest >> waitUntilUIRedrawed [

	backendForTest waitUntilUIRedrawed
]
