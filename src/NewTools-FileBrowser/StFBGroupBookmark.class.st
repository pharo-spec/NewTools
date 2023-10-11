"
i'm use to dispay group of bookmark
"
Class {
	#name : 'StFBGroupBookmark',
	#superclass : 'StFBAbstractBookMark',
	#instVars : [
		'collection'
	],
	#category : 'NewTools-FileBrowser-Bookmark',
	#package : 'NewTools-FileBrowser',
	#tag : 'Bookmark'
}

{ #category : 'instance creation' }
StFBGroupBookmark class >> name: aName collection: aCollection iconName: icon [
	^ self new
		name: aName;
		collection: aCollection;
		iconNamed: icon;
		yourself
]

{ #category : 'accessing' }
StFBGroupBookmark >> children [ 
	^ collection
]

{ #category : 'accessing' }
StFBGroupBookmark >> collection [
	^ collection
]

{ #category : 'accessing' }
StFBGroupBookmark >> collection: anObject [
	collection := anObject
]

{ #category : 'testing' }
StFBGroupBookmark >> isComposite [
	^ true
]

{ #category : 'accessing' }
StFBGroupBookmark >> removeAt: anInteger [ 
	self collection removeAt: anInteger.
]
