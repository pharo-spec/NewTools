"
I'm a """"cancel of do it and inspect"""" command.
I will cancel current playground execution when possible...
"
Class {
	#name : 'StPlaygroundCancelItCommand',
	#superclass : 'StPlaygroundCommand',
	#category : 'NewTools-Playground-Command',
	#package : 'NewTools-Playground',
	#tag : 'Command'
}

{ #category : 'default' }
StPlaygroundCancelItCommand class >> defaultDescription [

	^ 'Cancel current do it'
]

{ #category : 'accessing' }
StPlaygroundCancelItCommand class >> defaultIconName [

	^ #glamorousCancel
]

{ #category : 'default' }
StPlaygroundCancelItCommand class >> defaultName [

	^ 'Cancel it'
]

{ #category : 'accessing' }
StPlaygroundCancelItCommand class >> order [

	^ 1
]

{ #category : 'executing' }
StPlaygroundCancelItCommand >> execute [ 

	| tmp |
	(context application propertyAt: #executionThread ifAbsent:[ nil ])
		ifNil: [ self inform: 'No pending "Do it" !' ] 
		ifNotNil: [ :e |
			e terminate.
			self inform: 'Previous Do-It Cancelled !'.
			context application propertyAt: #executionThread put: nil ].

	self context withWindowDo: [ :w | tmp := w title: 'Playground - stopped' ].
]
