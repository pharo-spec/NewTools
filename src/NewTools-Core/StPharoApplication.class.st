Class {
	#name : #StPharoApplication,
	#superclass : #SpApplication,
	#classVars : [
		'Current'
	],
	#category : #'NewTools-Core-Application'
}

{ #category : #accessing }
StPharoApplication class >> current [ 
	
	^ Current
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
