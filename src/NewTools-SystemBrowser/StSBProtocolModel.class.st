Class {
	#name : #StSBProtocolModel,
	#superclass : #StSBModel,
	#instVars : [
		'protocol',
		'modelClass'
	],
	#category : #'NewTools-SystemBrowser'
}

{ #category : #'instance creation' }
StSBProtocolModel class >> newEnvironment: anEnvironment class: aClass protocol: aProtocol [

	^ self new 
		environment: anEnvironment;
		modelClass: aClass;
		protocol: aProtocol;
		yourself
]

{ #category : #accessing }
StSBProtocolModel >> methods [

	^ (self protocol methods 
		collect: [ :each | 
			StSBMethodModel 
				newEnvironment: self environment 
				method: (self modelClass >> each) ])
		sorted: #name ascending
]

{ #category : #accessing }
StSBProtocolModel >> modelClass [
	^ modelClass
]

{ #category : #accessing }
StSBProtocolModel >> modelClass: anObject [
	modelClass := anObject
]

{ #category : #accessing }
StSBProtocolModel >> name [

	^ self protocol name
]

{ #category : #accessing }
StSBProtocolModel >> protocol [
	^ protocol
]

{ #category : #accessing }
StSBProtocolModel >> protocol: anObject [
	protocol := anObject
]
