"
I represent a result in the ̀Finder̀ tool.

I am a composite object and subclasses of me reperesent different kinds of results.

I have a content, which is the actual result, and define a specified set of actions
for it.
"
Class {
	#name : 'StFinderResult',
	#superclass : 'Object',
	#instVars : [
		'content',
		'parent',
		'children'
	],
	#category : 'NewTools-Finder-Result',
	#package : 'NewTools-Finder',
	#tag : 'Result'
}

{ #category : 'instance creation' }
StFinderResult class >> newFor: aCompiledMethod [
	"Answer a <Class> matching aCompiledMethod to be represented as result item"

	^ self allSubclasses
		detect: [ : subclass | subclass matches: aCompiledMethod ]
		ifFound: [ : subclass | subclass new content: aCompiledMethod ]
		ifNone: [ self error: 'No matching result for ' , aCompiledMethod selector ]

]

{ #category : 'adding' }
StFinderResult >> addChild: aFinderResult [

	aFinderResult parent: self.
	children add: aFinderResult
]

{ #category : 'action' }
StFinderResult >> browseAction [
	"Default does nothing. Subclasses may implement their own action for browsing."
]

{ #category : 'system tool access' }
StFinderResult >> browser [
	"We should check how to do it via the stApplication but ok for now"

	self flag: #comeBack.
	^ Smalltalk tools browser
]

{ #category : 'accessing' }
StFinderResult >> children [

	^ children
]

{ #category : 'accessing' }
StFinderResult >> children: anObject [

	children := anObject
]

{ #category : 'accessing' }
StFinderResult >> content [

	^ content
]

{ #category : 'accessing' }
StFinderResult >> content: anObject [

	content := anObject
]

{ #category : 'displaying' }
StFinderResult >> displayIcon [

	^ nil
]

{ #category : 'displaying' }
StFinderResult >> displaySource: aCompiledMethod in: aSpCodePresenter [

	aSpCodePresenter 
		beForMethod: aCompiledMethod;
		text: aCompiledMethod sourceCode
]

{ #category : 'displaying' }
StFinderResult >> displayString [

	^ content asString
]

{ #category : 'testing' }
StFinderResult >> hasBrowseAction [

	^ false
]

{ #category : 'testing' }
StFinderResult >> hasChildren [

	^ self children notEmpty
]

{ #category : 'testing' }
StFinderResult >> hasHierarchyAction [

	^ false
]

{ #category : 'testing' }
StFinderResult >> hasImplementersAction [

	^ false
]

{ #category : 'testing' }
StFinderResult >> hasInheritanceAction [

	^ false
]

{ #category : 'testing' }
StFinderResult >> hasSendersAction [

	^ false
]

{ #category : 'testing' }
StFinderResult >> hasVersionsAction [

	^ false
]

{ #category : 'action' }
StFinderResult >> hierarchyAction [
	"Default does nothing. Subclasses may implement their own action for hieracchy."
]

{ #category : 'action' }
StFinderResult >> implementersAction [
	"Default does nothing. Subclasses may implement their own action for implementers."
]

{ #category : 'action' }
StFinderResult >> inheritanceAction [
	"Default does nothing. Subclasses may implement their own action for inheritance."
]

{ #category : 'initialization' }
StFinderResult >> initialize [

	children := OrderedCollection new
]

{ #category : 'testing' }
StFinderResult >> isClassResult [

	^ false
]

{ #category : 'testing' }
StFinderResult >> isExampleResult [

	^ self parent notNil and: [ self parent isExampleResult ]
]

{ #category : 'testing' }
StFinderResult >> isPackageResult [

	^ false
]

{ #category : 'testing' }
StFinderResult >> isPragmaResult [

	^ false
]

{ #category : 'testing' }
StFinderResult >> isSelectorResult [

	^ false
]

{ #category : 'testing' }
StFinderResult >> matches: aString [ 
	"Answer <true> if the receiver's displayed text match exactly aString"
	
	^ self displayString = aString
]

{ #category : 'system tool access' }
StFinderResult >> navigation [
	"We should check how to do it via the stApplication but ok for now"

	self flag: #comeBack.
	^ SystemNavigation default
]

{ #category : 'accessing' }
StFinderResult >> parent [

	^ parent
]

{ #category : 'accessing' }
StFinderResult >> parent: anObject [

	parent := anObject
]

{ #category : 'printing' }
StFinderResult >> printOn: aStream [

	super printOn: aStream.
	aStream space.
	self content printOn: aStream.
]

{ #category : 'action' }
StFinderResult >> sendersAction [
	"Default does nothing. Subclasses may implement their own action for senders."
]

{ #category : 'system tool access' }
StFinderResult >> versionBrowser [
	"We should check how to do it via the stApplication but ok for now"
	self flag: #comeBack.
	^ Smalltalk tools versionBrowser
]

{ #category : 'action' }
StFinderResult >> versionsAction [
	"Default does nothing. Subclasses may implement their own action for versions."
]
