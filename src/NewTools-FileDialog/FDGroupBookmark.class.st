"
i'm use to dispay group of bookmark
"
Class {
	#name : #FDGroupBookmark,
	#superclass : #FDAbstractBookMark,
	#instVars : [
		'collection'
	],
	#category : #'NewTools-FileDialog-Bookmark'
}

{ #category : #'instance creation' }
FDGroupBookmark class >> name: aName collection: aCollection iconName: icon [
	^ self new
		name: aName;
		collection: aCollection;
		iconNamed: icon;
		yourself
]

{ #category : #accessing }
FDGroupBookmark >> children [ 
	^ collection
]

{ #category : #accessing }
FDGroupBookmark >> collection [
	^ collection
]

{ #category : #accessing }
FDGroupBookmark >> collection: anObject [
	collection := anObject
]

{ #category : #testing }
FDGroupBookmark >> isComposite [
	^ true
]

{ #category : #accessing }
FDGroupBookmark >> removeAt: anInteger [ 
	self collection removeAt: anInteger.
]
