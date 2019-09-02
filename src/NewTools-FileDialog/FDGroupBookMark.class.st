"
i'm use to dispay group of bookmark
"
Class {
	#name : #FDGroupBookMark,
	#superclass : #FDAbstractBookMark,
	#instVars : [
		'collection'
	],
	#category : #'NewTools-FileDialog-Bookmark'
}

{ #category : #'instance creation' }
FDGroupBookMark class >> name: aName collection: aCollection iconName: icon [
	^ self new
		name: aName;
		collection: aCollection;
		iconNamed: icon;
		yourself
]

{ #category : #accessing }
FDGroupBookMark >> children [ 
	^ collection
]

{ #category : #accessing }
FDGroupBookMark >> collection [
	^ collection
]

{ #category : #accessing }
FDGroupBookMark >> collection: anObject [
	collection := anObject
]

{ #category : #testing }
FDGroupBookMark >> isComposite [
	^ true
]

{ #category : #accessing }
FDGroupBookMark >> removeAt: anInteger [ 
	self collection removeAt: anInteger.
]
