Class {
	#name : #StSBModel,
	#superclass : #Object,
	#instVars : [
		'environment'
	],
	#category : #'NewTools-SystemBrowser-Model'
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

{ #category : #accessing }
StSBModel >> icon [

	^ nil
]

{ #category : #accessing }
StSBModel >> name [

	^ self subclassResponsibility
]

{ #category : #accessing }
StSBModel >> windowTitle [
	
	^ 'TODO'
]
