"
I am simple tool to load projects from their repositories.

Try me with:
```
StProjectLoader new openWithSpec
```


"
Class {
	#name : #StProjectLoader,
	#superclass : #StPresenter,
	#instVars : [
		'loadableProjects',
		'menuBarPresenter',
		'projectListPresenter',
		'descriptionTextPresenter',
		'tickedProjects',
		'summaryPanel'
	],
	#category : #'NewTools-ProjectLoader'
}

{ #category : #specs }
StProjectLoader class >> defaultSpec [ 

	^ SpBoxLayout newVertical 
			add: (SpPanedLayout newHorizontal
						add: #projectListPresenter 
							withConstraints: [ :constraints |" constraints width: 150" ];
						add: (SpBoxLayout newVertical
									add: 'Summary' height: self labelHeight;						
									add: #summaryPanel withConstraints: [ :constraints | 
											constraints 
												height: self toolbarHeight * 4;
												padding: 2. ];
									add: 'Project Readme' height: self labelHeight;
									add: #descriptionTextPresenter;
									yourself);
						yourself);
			add: #menuBarPresenter withConstraints: [ :constraints | constraints height: self toolbarHeight ];
			yourself
]

{ #category : #specs }
StProjectLoader class >> toolbarHeight [

	^ 30
]

{ #category : #specs }
StProjectLoader class >> worldMenuEntry: aBuilder [

	<worldMenu>

	(aBuilder item: #LoadAdditionalProject)
		parent: #Tools;
		order: 202;
		label: 'Load Additional Projects';
		icon: (self iconNamed: #config);
		help: 'Let you browse and load selected additional projects to improve your experience with Pharo';
		action: [ self new openWithSpec ]
]

{ #category : #initialization }
StProjectLoader >> connectPresenters [  

	projectListPresenter 
		whenSelectionChangedDo: [ self updateSelection ]
]

{ #category : #'ui - operations' }
StProjectLoader >> displayDescription [

	| description |
	
	description := 'I have no selection'.
	
	self selectedProjects 
		ifNotEmpty: [ 
			description := self selectedProjects first description. 
			description ifNil: [ description := 'Impossible to get the description :''(' ]].
			
	descriptionTextPresenter text: (self parseDescription: description)
		
]

{ #category : #'ui - operations' }
StProjectLoader >> displaySummary [
	
	| summary |
	
	self selectedProjects 
		ifNotEmpty: [ 
			summary := self selectedProjects first summary. 
			summary ifNil: [ summary := 'No Summary' ]].

	summaryPanel text: summary.
]

{ #category : #initialization }
StProjectLoader >> initialize [
	tickedProjects := OrderedCollection new.
	loadableProjects := LoadableProject allProjects.
	super initialize.
	
]

{ #category : #initialization }
StProjectLoader >> initializePresenters [ 

	projectListPresenter := self newTable.
	projectListPresenter addColumn:
			((SpCheckBoxTableColumn title: ' ' evaluated: [ :class | self tickedProjects includes: class ])
				onActivation: [ :class | self tickedProjects add: class ];
				onDeactivation: [ :class | self tickedProjects remove: class ];
				width: 20;
				yourself).
				
   projectListPresenter addColumn: (SpCompositeTableColumn new
			title: 'Name';
			addColumn: (SpImageTableColumn evaluated: [ :each | 
				self iconNamed: #glamorousFolder ]);
			addColumn: (SpStringTableColumn evaluated: [ :each | each name])).
	projectListPresenter items: loadableProjects.

	menuBarPresenter := self newButtonBar.
	menuBarPresenter add: (SpButtonPresenter new label: 'Cancel'; action: [ self window close ]; yourself).
	menuBarPresenter add: (SpButtonPresenter new label: 'Ok'; action: [ self loadTickedProjects ]; yourself).
	
	descriptionTextPresenter := self newText.
	descriptionTextPresenter beNotEditable.
	summaryPanel := self newText.
	summaryPanel beNotEditable.
	
]

{ #category : #initialization }
StProjectLoader >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: 'Optional project loader';
		initialExtent: 900@600
	
]

{ #category : #operations }
StProjectLoader >> loadTickedProjects [

	self tickedProjects 
		do: [ :aProject | aProject load ]
]

{ #category : #accessing }
StProjectLoader >> loadableProjects [

	^ loadableProjects
]

{ #category : #accessing }
StProjectLoader >> loadableProjects: aColl [

	loadableProjects := aColl
]

{ #category : #'ui - operations' }
StProjectLoader >> parseDescription: description [

	^ StProjectLoaderRenderer newCurrent render: description
]

{ #category : #accessing }
StProjectLoader >> selectedProjects [
	
	^ projectListPresenter selection selectedItems
]

{ #category : #accessing }
StProjectLoader >> tickedProjects [

	^ tickedProjects
]

{ #category : #'ui - operations' }
StProjectLoader >> updateSelection [

	self displayDescription.
	self displaySummary
]
