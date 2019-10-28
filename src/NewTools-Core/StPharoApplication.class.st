Class {
	#name : #StPharoApplication,
	#superclass : #SpApplication,
	#classVars : [
		'Current'
	],
	#classInstVars : [
		'session'
	],
	#category : #'NewTools-Core-Application'
}

{ #category : #'instance creation' }
StPharoApplication class >> current [ 
	
	self validateSession.
	^ Current ifNil: [ Current := self new ]
]

{ #category : #private }
StPharoApplication class >> validateSession [
	
	session == Smalltalk session ifTrue: [ ^ self ].
	Current := nil.
	session := Smalltalk session
]

{ #category : #running }
StPharoApplication >> run [ 

	Current ifNotNil: [ Current close ].
	super run. 
	Current := self
]

{ #category : #'private running' }
StPharoApplication >> start [

	
]

{ #category : #convenience }
StPharoApplication >> useGtk [

	self useBackend: #Gtk with: StPharoGtkConfiguration new
]

{ #category : #convenience }
StPharoApplication >> useGtkDark [

	self useBackend: #Gtk with: StPharoGtkDarkConfiguration new
]

{ #category : #convenience }
StPharoApplication >> useMorphic [

	self useBackend: #Morphic
]
