Class {
	#name : #StSBMethodModel,
	#superclass : #StSBModel,
	#instVars : [
		'method'
	],
	#category : #'NewTools-SystemBrowser-Model'
}

{ #category : #'instance creation' }
StSBMethodModel class >> newEnvironment: anEnvironment method: aMethod [

	^ self new 
		environment: anEnvironment;
		method: aMethod;
		yourself
]

{ #category : #'api-shout' }
StSBMethodModel >> behavior [

	^ self method methodClass
]

{ #category : #accessing }
StSBMethodModel >> definition [
	
	^ self method sourceCode
]

{ #category : #accessing }
StSBMethodModel >> method [
	^ method
]

{ #category : #accessing }
StSBMethodModel >> method: anObject [
	method := anObject
]

{ #category : #accessing }
StSBMethodModel >> name [

	^ self method selector
]

{ #category : #accessing }
StSBMethodModel >> windowTitle [

	^ self method printString
]
