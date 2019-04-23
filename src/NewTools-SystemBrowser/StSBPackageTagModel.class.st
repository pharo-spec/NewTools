Class {
	#name : #StSBPackageTagModel,
	#superclass : #StSBBasePackageModel,
	#instVars : [
		'packageTag'
	],
	#category : #'NewTools-SystemBrowser'
}

{ #category : #'instance creation' }
StSBPackageTagModel class >> newEnvironment: anEnvironment packageTag: aPackageTag [ 

	^ self new
		environment: anEnvironment;
		packageTag: aPackageTag;
		yourself
]

{ #category : #accessing }
StSBPackageTagModel >> children [

	^ #()
]

{ #category : #accessing }
StSBPackageTagModel >> classes [

	^ #()
]

{ #category : #accessing }
StSBPackageTagModel >> name [

	^ self packageTag name
]

{ #category : #accessing }
StSBPackageTagModel >> packageTag [
	^ packageTag
]

{ #category : #accessing }
StSBPackageTagModel >> packageTag: anObject [
	packageTag := anObject
]
