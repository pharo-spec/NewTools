"
I am a code presenter that highlights the code of an AST node to which a DebugPoint is attached.
"
Class {
	#name : 'DebugPointCodePresenter',
	#superclass : 'SpCodePresenter',
	#category : 'NewTools-DebugPointsBrowser',
	#package : 'NewTools-DebugPointsBrowser'
}

{ #category : 'adding' }
DebugPointCodePresenter >> addHighlightForNode: aDebugPointNodeTarget [

	self addTextSegmentDecoration:
		(SpTextPresenterDecorator forHighlight
			 interval: (aDebugPointNodeTarget node start to: aDebugPointNodeTarget node stop + 1);
			 yourself)
]

{ #category : 'updating - presenters' }
DebugPointCodePresenter >> updateCode: aDebugPointNodeTarget [
	"updates the code window with the code of the selected debug point"

	aDebugPointNodeTarget ifNil: [
		self text: ''.
		^ self ].
	self
		text: aDebugPointNodeTarget sourceCode;
		beForMethod: aDebugPointNodeTarget method;
		addHighlightForNode: aDebugPointNodeTarget
]
