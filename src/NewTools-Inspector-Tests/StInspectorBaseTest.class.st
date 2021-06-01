Class {
	#name : #StInspectorBaseTest,
	#superclass : #TestCase,
	#instVars : [
		'backendForTest',
		'application',
		'presenter',
		'memoryFileSystem'
	],
	#category : #'NewTools-Inspector-Tests'
}

{ #category : #testing }
StInspectorBaseTest class >> isAbstract [

	^ super isAbstract or: [ self = StInspectorBaseTest ]
]

{ #category : #accessing }
StInspectorBaseTest >> classToTest [

	^ self subclassResponsibility
]

{ #category : #running }
StInspectorBaseTest >> initializeInstance: aPresenter [
	
]

{ #category : #running }
StInspectorBaseTest >> initializeInstanceBeforeInitialization: aPresenter [
	
]

{ #category : #'private - utilities' }
StInspectorBaseTest >> openInstance [

	presenter openWithSpec
]

{ #category : #running }
StInspectorBaseTest >> setUp [
	super setUp.
	
	backendForTest := SpMorphicBackendForTest new.
	application := StPharoApplication new.
			
	presenter := self classToTest basicNew. 
	self initializeInstanceBeforeInitialization: presenter.
	presenter application: application.
	presenter initialize.
	self initializeInstance: presenter
]

{ #category : #running }
StInspectorBaseTest >> tearDown [

	presenter withWindowDo: [ :window | window close ].
	super tearDown
]

{ #category : #'private - utilities' }
StInspectorBaseTest >> waitUntilContentsAreFlush [
		
	20 milliSeconds wait
	
]

{ #category : #'private - utilities' }
StInspectorBaseTest >> waitUntilUIRedrawed [

	backendForTest waitUntilUIRedrawed
]
