Class {
	#name : #STSBClassModel,
	#superclass : #StSBModel,
	#instVars : [
		'modelClass'
	],
	#category : #'NewTools-SystemBrowser'
}

{ #category : #'instance creation' }
STSBClassModel class >> newEnvironment: anEnvironment  class: aClass [

	^ self new 
		environment: anEnvironment;
		modelClass: aClass;
		yourself
]

{ #category : #accessing }
STSBClassModel >> icon [

	^ nil
]

{ #category : #accessing }
STSBClassModel >> modelClass [
	^ modelClass
]

{ #category : #accessing }
STSBClassModel >> modelClass: anObject [
	modelClass := anObject
]

{ #category : #accessing }
STSBClassModel >> name [

	^ self modelClass name
]
