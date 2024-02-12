"
I represent a class as a ̀FinderResult̀.
"
Class {
	#name : 'StFinderClassResult',
	#superclass : 'StFinderResult',
	#category : 'NewTools-Finder-Result',
	#package : 'NewTools-Finder',
	#tag : 'Result'
}

{ #category : 'testing' }
StFinderClassResult class >> matches: aCompiledMethod [ 
	"Answer <true> if aClassOraTaCompositionElement is a <Class>"
	
	^ aCompiledMethod methodClass isClass
]

{ #category : 'action' }
StFinderClassResult >> browseAction [
	"Opens the system browser on its content. If it has a `StFinderSelectorResult` as a parent,
	then opens the system browser on its content with the selector from its parent focused."

	self hasSelectorParent
		ifTrue: [
			self browser
				openOnClass: self content
				selector: self parent content ]
		ifFalse: [ content browse ]
]

{ #category : 'accessing' }
StFinderClassResult >> content: aCompiledMethodOrClass [

	content := aCompiledMethodOrClass isCompiledMethod 
		ifTrue: [  aCompiledMethodOrClass methodClass ]
		ifFalse: [ aCompiledMethodOrClass ]
]

{ #category : 'copying' }
StFinderClassResult >> copyTo: aWriteStream [ 

	aWriteStream << self content name.
	self hasSelectorParent
		ifTrue: [ 
			aWriteStream
				<< '>>#';
				<< self parent content ]
]

{ #category : 'displaying' }
StFinderClassResult >> displayIcon [

	(self content inheritsFrom: Exception) ifTrue: [ ^ self iconNamed: #exception ].
	self content isAbstract ifTrue: [ ^ self iconNamed: #classAbstract ].
	self content isDeprecated ifTrue: [ ^ self iconNamed: #smallNew ].
	self content isObsolete ifTrue: [ ^ self iconNamed: #error ].
	^ self iconNamed: #class
]

{ #category : 'action' }
StFinderClassResult >> forFinderPreview: aSpCodePresenter [ 

	^ (self content isClass and: [ self parent isNotNil and: [ self parent isPackageResult not ] ])
		ifTrue: [ 
			self 
				displaySource: self getCompiledMethod
				in: aSpCodePresenter ]
		ifFalse: [ 
			aSpCodePresenter 
				beForScripting;
				text: self content definitionString ]
]

{ #category : 'accessing' }
StFinderClassResult >> getCompiledMethod [
	"Answer a <CompiledMethod> representing the currently found content"

	^ self parent content isCompiledMethod
		ifTrue: [ self parent content ]
		ifFalse: [ self content >> self parent content ]
]

{ #category : 'instance creation' }
StFinderClassResult >> getCompiledMethodFrom: aStFinderSelectorResult [ 

	^ self content >> aStFinderSelectorResult content
]

{ #category : 'copying' }
StFinderClassResult >> hasSelectorParent [

	^ self parent isNotNil and: [ self parent isSelectorResult ]
]

{ #category : 'testing' }
StFinderClassResult >> isClassResult [

	^ true
]

{ #category : 'action' }
StFinderClassResult >> referencesAction [

	self navigation browseAllUsersOfClassOrTrait: self content
]

{ #category : 'accessing' }
StFinderClassResult >> selectItemIn: aSpTreePresenter [ 

	| pathIndexCollection |
	pathIndexCollection := aSpTreePresenter pathIndexOf: { self }.
	aSpTreePresenter 
		selectPath: pathIndexCollection scrollToSelection: true;
		clickAtPath: pathIndexCollection
]
