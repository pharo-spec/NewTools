"
I am a code presenter that highlights the code of an AST node to which a DebugPoint is attached.
"
Class {
	#name : 'DebugPointCodePresenter',
	#superclass : 'SpCodePresenter',
	#category : 'NewTools-DebugPointsBrowser',
	#package : 'NewTools-DebugPointsBrowser'
}

{ #category : 'updating - presenters' }
DebugPointCodePresenter >> updateCode: aDebugPointNodeTarget [
	"updates the code window with the code of the selected debug point"
	aDebugPointNodeTarget ifNil:[self text: ''.^self].
	self text: aDebugPointNodeTarget sourceCode;
		beForMethod: aDebugPointNodeTarget method;
		addTextSegmentDecoration: 
			(SpTextPresenterDecorator forHighlight
         		interval: (aDebugPointNodeTarget node start to: ((aDebugPointNodeTarget node stop) +1));
            yourself) .
]
