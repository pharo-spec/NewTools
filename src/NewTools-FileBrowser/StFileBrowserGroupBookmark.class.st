"
i'm use to dispay group of bookmark
"
Class {
	#name : 'StFileBrowserGroupBookmark',
	#superclass : 'StFileBrowserAbstractBookMark',
	#instVars : [
		'collection'
	],
	#category : 'NewTools-FileBrowser-Bookmark',
	#package : 'NewTools-FileBrowser',
	#tag : 'Bookmark'
}

{ #category : 'instance creation' }
StFileBrowserGroupBookmark class >> name: aName collection: aCollection iconName: icon [
	^ self new
		name: aName;
		collection: aCollection;
		iconNamed: icon;
		yourself
]

{ #category : 'accessing' }
StFileBrowserGroupBookmark >> children [ 
	^ collection
]

{ #category : 'accessing' }
StFileBrowserGroupBookmark >> collection [
	^ collection
]

{ #category : 'accessing' }
StFileBrowserGroupBookmark >> collection: anObject [
	collection := anObject
]

{ #category : 'testing' }
StFileBrowserGroupBookmark >> isComposite [
	^ true
]

{ #category : 'accessing' }
StFileBrowserGroupBookmark >> removeAt: anInteger [ 
	self collection removeAt: anInteger.
]
