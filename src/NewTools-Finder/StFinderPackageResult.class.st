Class {
	#name : 'StFinderPackageResult',
	#superclass : 'StFinderResult',
	#category : 'NewTools-Finder-Result',
	#package : 'NewTools-Finder',
	#tag : 'Result'
}

{ #category : 'testing' }
StFinderPackageResult class >> matches: aCollection [ 
	
	^ false
]

{ #category : 'copying' }
StFinderPackageResult >> copyTo: aWriteStream [ 

	aWriteStream << self content name
]

{ #category : 'displaying' }
StFinderPackageResult >> displayIcon [

	^ self iconNamed: #package
]

{ #category : 'displaying' }
StFinderPackageResult >> displayString [

	^ self content name
]

{ #category : 'private' }
StFinderPackageResult >> forFinderPreview: aSpCodePresenter [ 

	^ String empty
]

{ #category : 'testing' }
StFinderPackageResult >> isPackageResult [

	^ true
]

{ #category : 'private' }
StFinderPackageResult >> selectItemIn: aSpTreePresenter [ 

	| pathIndexCollection |
	pathIndexCollection := aSpTreePresenter pathIndexOf: { self }.
	aSpTreePresenter 
		selectPath: pathIndexCollection scrollToSelection: true;
		clickAtPath: pathIndexCollection
]
