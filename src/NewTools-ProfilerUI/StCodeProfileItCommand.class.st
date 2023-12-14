"
I'm a ""profile it"" command. 
I will evalute the selection (or line) of the playground using a profiler.
"
Class {
	#name : 'StCodeProfileItCommand',
	#superclass : 'SpCodeSelectionCommand',
	#category : 'NewTools-ProfilerUI-Commands',
	#package : 'NewTools-ProfilerUI',
	#tag : 'Commands'
}

{ #category : 'defaults' }
StCodeProfileItCommand class >> defaultIconName [

	^ #smallProfile
]

{ #category : 'defaults' }
StCodeProfileItCommand class >> defaultName [

	^ 'Profile it'
]

{ #category : 'execution' }
StCodeProfileItCommand >> execute [

	| selection receiver evaluationContext stream compiledMethod |
	selection := self selectedTextOrLine.
	selection trimBoth ifEmpty: [ ^ self ].

	receiver := self context doItReceiver.
	evaluationContext := self context doItContext.

	stream := selection readStream.
	compiledMethod := self
		                  compile: stream
		                  for: receiver
		                  in: evaluationContext.
	compiledMethod ifNil: [ ^ self ].

	StProfilerPresenter new
		open;
		profileBlock: [
			compiledMethod valueWithReceiver: receiver arguments: #(  ) ]
		displayCode: selection
]
