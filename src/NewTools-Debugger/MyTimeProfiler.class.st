Class {
	#name : #MyTimeProfiler,
	#superclass : #TimeProfiler,
	#classVars : [
		'profilingOn'
	],
	#category : #'NewTools-Debugger-View'
}

{ #category : #'as yet unclassified' }
MyTimeProfiler class >> profilingOn [
	profilingOn ifNil: [ profilingOn := false ].
	^ profilingOn
]

{ #category : #'as yet unclassified' }
MyTimeProfiler class >> profilingOn: aBoolean [
	profilingOn := aBoolean
	
]

{ #category : #opening }
MyTimeProfiler class >> spyOn: aBlock [
	"Profile aBlock if profilingOn is true. Else just execute aBlock"
	self profilingOn
		ifTrue: [ ^ super spyOn: aBlock ]
		ifFalse: [ ^ aBlock value ]
]
