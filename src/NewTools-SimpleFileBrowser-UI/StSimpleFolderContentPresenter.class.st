"
Show the content of a folder as list
"
Class {
	#name : 'StSimpleFolderContentPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'table',
		'folder',
		'detail'
	],
	#category : 'NewTools-SimpleFileBrowser-UI-Components',
	#package : 'NewTools-SimpleFileBrowser-UI',
	#tag : 'Components'
}

{ #category : 'specs' }
StSimpleFolderContentPresenter class >> defaultSpec [

	^ SpPanedLayout newTopToBottom
		position: 30 percent;
		add: #table;
		add: #detail;
		yourself
]

{ #category : 'examples' }
StSimpleFolderContentPresenter class >> example [

	^self openOn: FileSystem workingDirectory
]

{ #category : 'instance creation' }
StSimpleFolderContentPresenter class >> on: aFileReference [

	^(self new)
		folder: (StSimpleFileSystemItemWrapper on: aFileReference);
		yourself
]

{ #category : 'show' }
StSimpleFolderContentPresenter class >> openOn: aFileReference [

	(self on: aFileReference) openWithSpec
]

{ #category : 'accessing' }
StSimpleFolderContentPresenter >> detail [

	^detail ifNil: [ detail := (self instantiate: StSimpleFileDetailPresenter) ]
]

{ #category : 'accessing' }
StSimpleFolderContentPresenter >> folder [
	^ folder
]

{ #category : 'accessing' }
StSimpleFolderContentPresenter >> folder: anObject [
	folder := anObject.
	detail showFile: nil.
   self table items: folder allElements
	
]

{ #category : 'initialization' }
StSimpleFolderContentPresenter >> initializePresenters [

	self detail.
	self table	
		beMultipleSelection; 
		addColumn: (SpCompositeTableColumn new
				title: 'File Name';
				addColumn:
					(SpImageTableColumn new
						width: 20;
						evaluated: [ :each | each icon ];
						yourself);
				addColumn:
					(SpStringTableColumn new
						evaluated: [ :each | each label ];
						yourself);
				yourself);		
		addColumn: (SpStringTableColumn 
			title: 'Size' 
			evaluated: [ :each | each size ])
]

{ #category : 'accessing' }
StSimpleFolderContentPresenter >> table [

	^table ifNil: [ table := self newTable ]
]

{ #category : 'api-events' }
StSimpleFolderContentPresenter >> whenItemsChangedDo: aBlock [
	
	table whenSelectionChangedDo: [ :selection | 
		| items |
		items := selection selectedItems.
		aBlock cull: items.
		detail showFile: (items 
			ifNotEmpty: [ items last ]
			ifEmpty: [ nil ]) ] 
]
