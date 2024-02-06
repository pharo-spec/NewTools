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

	^ #glamorousGo
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

	| thrd |
	thrd := context application
		        propertyAt: #executionThread
		        ifAbsent: [ nil ].
	thrd ifNotNil: [ :e |
		self inform: 'Terminating previous Do-It !'.
		e terminate ].
	thrd := [
	        self context withWindowDo: [ :w |
		        w title: 'Playground - running' ].
	        context doEvaluateAllAndGo.
	        context application propertyAt: #executionThread put: nil.
	        self context withWindowDo: [ :w |
		        w title: 'Playground - finished' ] ] forkAt:
		        Processor userBackgroundPriority.
	context application propertyAt: #executionThread put: thrd
]
