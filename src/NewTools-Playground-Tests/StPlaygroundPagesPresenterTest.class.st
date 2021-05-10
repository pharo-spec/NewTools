Class {
	#name : #StPlaygroundPagesPresenterTest,
	#superclass : #StPlaygroundBaseTest,
	#category : #'NewTools-Playground-Tests'
}

{ #category : #accessing }
StPlaygroundPagesPresenterTest >> classToTest [

	^ StPlaygroundPagesPresenter
]

{ #category : #initialization }
StPlaygroundPagesPresenterTest >> initializeInstanceBeforeInitialization: aPresenter [

	aPresenter setModelBeforeInitialization: (StPlayground newApplication: application)
]

{ #category : #initialization }
StPlaygroundPagesPresenterTest >> initializeMemoryFileSystem: aFileSystem [

	aFileSystem / 'test1.sh' writeStreamDo: [ :stream | stream << '42 factorial' ].
	aFileSystem / 'test2.sh' writeStreamDo: [ :stream | 
		stream << '"Test'; cr.
		stream << 'Test 2"' ].
]

{ #category : #tests }
StPlaygroundPagesPresenterTest >> testLoadPage [

	self deny: presenter window notNil.
	self openInstance.
	self assert: presenter window isOpen.
	presenter loadPage: (memoryFileSystem / 'test1.sh').
	self deny: presenter window isOpen 
	
]
