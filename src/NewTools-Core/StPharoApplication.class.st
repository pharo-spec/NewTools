Class {
	#name : #StPharoApplication,
	#superclass : #SpecApplication,
	#classVars : [
		'Current'
	],
	#category : #'NewTools-Core'
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
StPharoApplication >> useMorphic [

	self useBackend: #Morphic
]
