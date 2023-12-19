Class {
	#name : 'StPlaygroundPageSummaryPresenterTest',
	#superclass : 'StPlaygroundBaseTest',
	#category : 'NewTools-Playground-Tests',
	#package : 'NewTools-Playground-Tests'
}

{ #category : 'accessing' }
StPlaygroundPageSummaryPresenterTest >> classToTest [

	^ StPlaygroundPageSummaryPresenter
]

{ #category : 'initialization' }
StPlaygroundPageSummaryPresenterTest >> initializeInstanceBeforeInitialization: aPresenter [

	aPresenter setModelBeforeInitialization: memoryFileSystem / 'test1.ph'
]

{ #category : 'initialization' }
StPlaygroundPageSummaryPresenterTest >> initializeMemoryFileSystem: aFileSystem [

	aFileSystem / 'test1.ph' writeStreamDo: [ :stream | stream << '' ].
	aFileSystem / 'test2.ph' writeStreamDo: [ :stream | 
		stream << 'Test'; cr.
		stream << 'Test 2' ].
]

{ #category : 'tests' }
StPlaygroundPageSummaryPresenterTest >> testContents [

	self assert: presenter contents equals: ''.
	presenter setModelBeforeInitialization: (StPlaygroundPage fromReference: (memoryFileSystem / 'test2.ph')).
	self assert: presenter contents equals: 'Test
Test 2'	
]

{ #category : 'tests' }
StPlaygroundPageSummaryPresenterTest >> testPageFirstLine [
	
	self assert: presenter pageTitle equals: 'Empty'.	
	presenter setModelBeforeInitialization: (StPlaygroundPage fromReference: memoryFileSystem / 'test2.ph').
	self assert: presenter pageTitle equals: 'Test'
]
