Class {
	#name : 'StObjectTranscriptPresenterTest',
	#superclass : 'TestCase',
	#category : 'NewTools-ObjectTranscript',
	#package : 'NewTools-ObjectTranscript'
}

{ #category : 'tests' }
StObjectTranscriptPresenterTest >> testFalseShowInspectorDoNotShowInspector [

	| st win current |
	[
	current := StObjectTranscriptPresenter showInspector.
	StObjectTranscriptPresenter showInspector: false.
	st := StObjectTranscriptPresenter new.
	win := st
		       logger: StObjectTranscriptLogger instance;
		       open.
	self assert: win initialExtent equals: 550 @ 650 ] ensure: [
		win close.
		StObjectTranscriptPresenter showInspector: current ]
]

{ #category : 'tests' }
StObjectTranscriptPresenterTest >> testTrueShowInspectorShowsInspector [

	| st win current |
	self skip. 
	"There is a bug in Spec so my test cannot pass."
	
	[ current := StObjectTranscriptPresenter showInspector.
	StObjectTranscriptPresenter showInspector: true. 
	st := StObjectTranscriptPresenter new.
	win := st logger: StObjectTranscriptLogger instance; open.
	self assert: win initialExtent equals: (450.0 @ 650.0).
		] ensure: [ 
			win close.
			StObjectTranscriptPresenter showInspector: current ]
		
	
]
