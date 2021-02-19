Class {
	#name : #StGtkDebugSession,
	#superclass : #GtkDebugSession,
	#instVars : [
		'application'
	],
	#category : #'NewTools-Gtk'
}

{ #category : #accessing }
StGtkDebugSession >> application [

	^ application
]

{ #category : #accessing }
StGtkDebugSession >> application: anApplication [

	application := anApplication
]

{ #category : #private }
StGtkDebugSession >> initialize [

	super initialize. 
	application := SpToolCurrentApplication value ifNil: [ StPharoApplication current ]
]
