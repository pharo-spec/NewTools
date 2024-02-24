Class {
	#name : 'StVersionBrowserPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'class',
		'factory'
	],
	#category : 'NewTools-MethodBrowsers-Tests',
	#package : 'NewTools-MethodBrowsers-Tests'
}

{ #category : 'running' }
StVersionBrowserPresenterTest >> setUp [
	super setUp.
	factory := ClassFactoryForTestCase new.
	class := factory newClass

]

{ #category : 'running' }
StVersionBrowserPresenterTest >> tearDown [
	factory cleanUp.
	super tearDown
]

{ #category : 'running' }
StVersionBrowserPresenterTest >> testRevertOldMethod [ 
	| browser |
	class compile: 'm
	^1'.
	self assert: class new m equals: 1.
	class compile: 'm
	^2'.
	self assert: class new m equals: 2.
	browser := StVersionBrowserPresenter on: class >> #m.
	browser selectIndex: browser changeList size.
	browser doRevert.
	self assert: class new m equals: 1.
	
	
]
