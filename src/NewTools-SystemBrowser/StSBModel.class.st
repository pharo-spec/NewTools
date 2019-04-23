Class {
	#name : #StSBModel,
	#superclass : #Object,
	#instVars : [
		'environment'
	],
	#category : #'NewTools-SystemBrowser'
}

{ #category : #accessing }
StSBModel >> application [ 

	^ StPharoApplication current
]

{ #category : #accessing }
StSBModel >> environment [

	^ environment
]

{ #category : #accessing }
StSBModel >> environment: anEnvironment [

	environment := anEnvironment
]
