Class {
	#name : #StSBClassModel,
	#superclass : #StSBModel,
	#instVars : [
		'modelClass'
	],
	#category : #'NewTools-SystemBrowser-Model'
}

{ #category : #'instance creation' }
StSBClassModel class >> newEnvironment: anEnvironment  class: aClass [

	^ self new 
		environment: anEnvironment;
		modelClass: aClass;
		yourself
]

{ #category : #accessing }
StSBClassModel >> behavior [

	^ nil
]

{ #category : #accessing }
StSBClassModel >> classProtocols [

	^ self classQuery execute items collect: [ :each |
		StSBProtocolModel 
			newEnvironment: self environment 
			protocol: each  ]
]

{ #category : #'private queries' }
StSBClassModel >> classQuery [

	^ ClyAllMethodGroupsQuery 
		from: ClyClassSideScope 
		of: self modelClass 
		in: self environment
]

{ #category : #accessing }
StSBClassModel >> comment [

	^ self modelClass comment
]

{ #category : #accessing }
StSBClassModel >> definition [

	^ self modelClass definitionWithSlots
	
]

{ #category : #accessing }
StSBClassModel >> icon [

	^ self modelClass systemIcon
]

{ #category : #accessing }
StSBClassModel >> instanceProtocols [

	^ self instanceQuery execute items collect: [ :each |
		StSBProtocolModel 
			newEnvironment: self environment 
			protocol: each  ]
]

{ #category : #'private queries' }
StSBClassModel >> instanceQuery [

	^ ClyAllMethodGroupsQuery 
		from: ClyInstanceSideScope 
		of: self modelClass 
		in: self environment
]

{ #category : #accessing }
StSBClassModel >> modelClass [
	^ modelClass
]

{ #category : #accessing }
StSBClassModel >> modelClass: anObject [
	modelClass := anObject
]

{ #category : #accessing }
StSBClassModel >> name [

	^ self modelClass name
]

{ #category : #accessing }
StSBClassModel >> windowTitle [ 

	^ 'Class: ', self name
]
