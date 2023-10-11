"
Adopt selected version on current playground. 
This command is to be used on `StPlaygroundPageVersionsPresenter`
"
Class {
	#name : 'StPlaygroundAdoptVersionCommand',
	#superclass : 'StPlaygroundCommand',
	#category : 'NewTools-Playground-Command',
	#package : 'NewTools-Playground',
	#tag : 'Command'
}

{ #category : 'accessing - defaults' }
StPlaygroundAdoptVersionCommand class >> defaultDescription [

	^ 'Adopt version contents in current playground'
]

{ #category : 'accessing - defaults' }
StPlaygroundAdoptVersionCommand class >> defaultName [

	^ 'Adopt'
]

{ #category : 'executing' }
StPlaygroundAdoptVersionCommand >> execute [

	self context doAdoptVersion
]
