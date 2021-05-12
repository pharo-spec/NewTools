Class {
	#name : #StPlaygroundPageSummaryPresenterTest,
	#superclass : #StPlaygroundBaseTest,
	#category : #'NewTools-Playground-Tests'
}

{ #category : #accessing }
StPlaygroundPageSummaryPresenterTest >> classToTest [

	^ StPlaygroundPageSummaryPresenter
]

{ #category : #initialization }
StPlaygroundPageSummaryPresenterTest >> initializeInstanceBeforeInitialization: aPresenter [

	aPresenter setModelBeforeInitialization: memoryFileSystem / 'test1.sh'
]

{ #category : #initialization }
StPlaygroundPageSummaryPresenterTest >> initializeMemoryFileSystem: aFileSystem [

	aFileSystem / 'test1.ph' writeStreamDo: [ :stream | stream << '' ].
	aFileSystem / 'test2.ph' writeStreamDo: [ :stream | 
		stream << 'Test'; cr.
		stream << 'Test 2' ].
]

{ #category : #tests }
StPlaygroundPageSummaryPresenterTest >> testContents [

	self assert: presenter contents equals: ''.
	presenter setModelBeforeInitialization: memoryFileSystem / 'test2.sh'.
	self assert: presenter contents equals: 'Test
Test 2'	
]

{ #category : #tests }
StPlaygroundPageSummaryPresenterTest >> testPageFirstLine [
	
	self assert: presenter pageFirstLine equals: 'Empty'.	
	presenter setModelBeforeInitialization: memoryFileSystem / 'test2.sh'.
	self assert: presenter pageFirstLine equals: 'Test'
]
