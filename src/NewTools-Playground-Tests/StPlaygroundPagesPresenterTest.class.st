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
	| loaded |

	loaded := false.
	self deny: presenter window notNil.
	self openInstance.
	self assert: presenter window isOpen.
	presenter onLoadPage: [ :aPage | loaded := true ].
	presenter loadPage: (StPlaygroundPage fromReference: (memoryFileSystem / 'test1.ph')).
	self deny: presenter window isOpen .
	self assert: loaded
]
