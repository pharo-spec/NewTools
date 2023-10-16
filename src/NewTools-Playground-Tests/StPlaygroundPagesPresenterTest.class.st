Class {
	#name : 'StPlaygroundPagesPresenterTest',
	#superclass : 'StPlaygroundBaseTest',
	#category : 'NewTools-Playground-Tests',
	#package : 'NewTools-Playground-Tests'
}

{ #category : 'accessing' }
StPlaygroundPagesPresenterTest >> classToTest [

	^ StPlaygroundPagesPresenter
]

{ #category : 'initialization' }
StPlaygroundPagesPresenterTest >> initializeInstanceBeforeInitialization: aPresenter [

	aPresenter setModelBeforeInitialization: (StPlaygroundPresenter newApplication: application)
]

{ #category : 'initialization' }
StPlaygroundPagesPresenterTest >> initializeMemoryFileSystem: aFileSystem [

	aFileSystem / 'test1.ph' writeStreamDo: [ :stream | stream << '42 factorial' ].
	aFileSystem / 'test2.ph' writeStreamDo: [ :stream | 
		stream << '"Test'; cr.
		stream << 'Test 2"' ].
]

{ #category : 'tests' }
StPlaygroundPagesPresenterTest >> testLoadPage [

	self deny: presenter window notNil.
	self openInstance.
	self assert: presenter window isOpen.
	presenter loadPage: (memoryFileSystem / 'test1.ph').
	self deny: presenter window isOpen .
	self 
		assert: presenter parent page contents
		equals: (memoryFileSystem / 'test1.ph') contents
]
