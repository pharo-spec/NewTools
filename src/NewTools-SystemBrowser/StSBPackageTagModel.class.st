Class {
	#name : #StSBPackageTagModel,
	#superclass : #StSBBasePackageModel,
	#instVars : [
		'classGroup'
	],
	#category : #'NewTools-SystemBrowser-Model'
}

{ #category : #'instance creation' }
StSBPackageTagModel class >> newEnvironment: anEnvironment classGroup: aPackageTag [ 

	^ self new
		environment: anEnvironment;
		classGroup: aPackageTag;
		yourself
]

{ #category : #accessing }
StSBPackageTagModel >> children [

	^ #()
]

{ #category : #accessing }
StSBPackageTagModel >> classGroup [
	
	^ classGroup
]

{ #category : #accessing }
StSBPackageTagModel >> classGroup: aClassGroup [

	classGroup := aClassGroup
]

{ #category : #accessing }
StSBPackageTagModel >> classes [

	^ self classGroup classes collect: [ :each | 
		StSBClassModel 
			newEnvironment: self environment
			class: each ]
]

{ #category : #accessing }
StSBPackageTagModel >> comment [

	^ self package packageComment
]

{ #category : #accessing }
StSBPackageTagModel >> fullName [

	^ self package classTags
		detect: [ :each | each name = self name ]
		ifFound: [ :each | each categoryName ]
		ifNone: [ self package name ]
]

{ #category : #accessing }
StSBPackageTagModel >> name [

	^ self classGroup name
]

{ #category : #private }
StSBPackageTagModel >> package [

	self flag: #REVIEW. "This is like thois because calypso does not attach the tag query 
	with a real RPackageTag but with some other query"
	self classGroup classQuery scope packagesDo: [ :each | ^ each ].
	^ nil
	
]
