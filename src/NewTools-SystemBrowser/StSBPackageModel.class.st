Class {
	#name : #StSBPackageModel,
	#superclass : #StSBBasePackageModel,
	#instVars : [
		'package'
	],
	#category : #'NewTools-SystemBrowser-Model'
}

{ #category : #'instance creation' }
StSBPackageModel class >> newEnvironment: anEnvironment package: aPackage [

	^ self new 
		environment: anEnvironment;
		package: aPackage;
		yourself
]

{ #category : #accessing }
StSBPackageModel >> allClassesQueries [

	^ {
		ClyAllClassesQuery from: ClyPackageScope of: self package in: self environment.
		ClyAllClassesQuery from: ClyPackageExtensionScope of: self package in: self environment
	}
]

{ #category : #accessing }
StSBPackageModel >> children [

	^ (self tagsQuery execute items 
		collect: [ :each | StSBPackageTagModel newEnvironment: self environment packageTag: each ])
		sorted: #name ascending 
]

{ #category : #accessing }
StSBPackageModel >> classes [

	^ self allClassesQueries 
		inject: #()
		into: [ :all :eachQuery | 
			all, (eachQuery execute items 
				collect: [ :each | StSBClassModel newEnvironment: self environment class: each ]) ]
]

{ #category : #accessing }
StSBPackageModel >> icon [

	^ self application iconNamed: #package
]

{ #category : #accessing }
StSBPackageModel >> name [

	^ self package name
]

{ #category : #accessing }
StSBPackageModel >> package [
	^ package
]

{ #category : #accessing }
StSBPackageModel >> package: anObject [
	package := anObject
]

{ #category : #accessing }
StSBPackageModel >> tagsQuery [
		
	^ ClyAllClassGroupsQuery sortedFrom: (ClyPackageScope of: self package in: self environment)
]
