"
I'm a ""do it and inspect"" command.
I will select all contents of a playground and I will execute it, inspecting the result.
"
Class {
	#name : 'StPlaygroundDoItCommand',
	#superclass : 'StPlaygroundCommand',
	#category : 'NewTools-Playground-Command',
	#package : 'NewTools-Playground',
	#tag : 'Command'
}

{ #category : 'default' }
StPlaygroundDoItCommand class >> defaultDescription [

	^ 'Do it all and inspect.'
]

{ #category : 'default' }
StPlaygroundDoItCommand class >> defaultIconName [

	^ #go
]

{ #category : 'default' }
StPlaygroundDoItCommand class >> defaultName [

	^ 'Do it'
]

{ #category : 'accessing' }
StPlaygroundDoItCommand class >> order [

	^ 0
]

{ #category : 'executing' }
StPlaygroundDoItCommand >> execute [

	context doEvaluateAllAndGo
]
