"
Presenter for a folder structure
"
Class {
	#name : #StSimpleFolderStructurePresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'tree'
	],
	#category : #'NewTools-SimpleFileBrowser-UI-Components'
}

{ #category : #specs }
StSimpleFolderStructurePresenter class >> defaultSpec [

	^ SpBoxLayout newTopToBottom
		add: #tree;
		yourself
]

{ #category : #specs }
StSimpleFolderStructurePresenter class >> open [ 
	<script>
	self new openWithSpec 
]

{ #category : #actions }
StSimpleFolderStructurePresenter >> browseFolder [
	 tree selectedItem browseFolder 
]

{ #category : #'menu handling' }
StSimpleFolderStructurePresenter >> folderContextMenu [

	^(SpMenuPresenter new
		addGroup: [ :group | group
			addItem: [ :item | item name: 'Open in native browser';  action: [ self browseFolder ]]
		])
]

{ #category : #initialization }
StSimpleFolderStructurePresenter >> initializePresenters [

	tree := self newTreeTable.
	tree
		addColumn:
			(SpCompositeTableColumn new
				title: self title;
				addColumn:
					(SpImageTableColumn new
						width: 20;
						evaluated: #icon;
						yourself);
				addColumn:
					(SpStringTableColumn new
						evaluated: #label;
						yourself);
				yourself);
		roots: StSimpleFileSystemItemWrapper roots;
		children: [ :aClass | aClass subdirectories ];
		beResizable.
	tree contextMenu: self folderContextMenu
]

{ #category : #accessing }
StSimpleFolderStructurePresenter >> pathIndexOf: pathArray in: aCollection [ 
	| pathElement |
	
	pathElement := aCollection detectIndex: [ :each | each label = pathArray first basename ].
	pathArray size = 1 ifTrue: [ ^ { pathElement } ].
	^ { pathElement }, (self 
		pathIndexOf: pathArray allButFirst
		in: (tree childrenFor: (aCollection at: pathElement)))
]

{ #category : #accessing }
StSimpleFolderStructurePresenter >> selectPathByItems: path [ 

	tree selectPath: (self pathIndexOf: path in: tree roots)
]

{ #category : #initialization }
StSimpleFolderStructurePresenter >> title [

	^ Smalltalk os isWindows 
		ifTrue: [ 'Drives and Folders' ] 
  		ifFalse: [ 'Folders' ] 
	
]

{ #category : #'api-events' }
StSimpleFolderStructurePresenter >> whenFolderChangedDo: aBlock [
	
	tree whenSelectionChangedDo: [ :selection | 
		aBlock cull: selection selectedItem ]
]
