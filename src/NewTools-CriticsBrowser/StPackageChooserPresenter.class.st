Class {
	#name : #StPackageChooserPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'packageList',
		'selectedPackagesList',
		'buttonBar'
	],
	#category : #'NewTools-CriticsBrowser'
}

{ #category : #example }
StPackageChooserPresenter class >> example [

	self new openWithSpec
]

{ #category : #actions }
StPackageChooserPresenter >> addAll [

	selectedPackagesList items: 
		(selectedPackagesList items, 
		(packageList items sorted: #packageName ascending)).
	packageList items: #().
	packageList selectItems: #()
	
]

{ #category : #actions }
StPackageChooserPresenter >> addSelected [

	selectedPackagesList items: 
		(selectedPackagesList items, 
		(packageList selectedItems sorted: #packageName ascending)).
	packageList items: ((packageList items \ packageList selectedItems) sorted: #packageName ascending).
	packageList selectItems: #()
]

{ #category : #actions }
StPackageChooserPresenter >> doAccept [

	self window close
]

{ #category : #initialization }
StPackageChooserPresenter >> initalizeSelectedPackageList [
	
	selectedPackagesList 
		contextMenu: self selectedPackageListMenu;		
		display: [ :each | each packageName ]
]

{ #category : #initialization }
StPackageChooserPresenter >> initializeButtonBar [
			
	buttonBar 
		add: (self newButton
				addStyle: 'small';
				label: '>';
				help: 'Add selected packages to selected list.';
				action: [ self addSelected ];
				yourself)
			expand: false;
		add: (self newButton
				addStyle: 'small';
				label: '>>';
				help: 'Add all packages to selected list.';
				action: [ self addAll ];
				yourself)
			expand: false;
		add: (self newButton
				addStyle: 'small';
				label: '<';
				help: 'Remove selected packages from selected list.';
				action: [ self removeSelected ];
				yourself)
			expand: false;
		add: (self newButton
				addStyle: 'small';
				label: '<<';
				help: 'Remove all packages from selected list.';
				action: [ self removeAll ];
				yourself)
			expand: false

]

{ #category : #initialization }
StPackageChooserPresenter >> initializeDialogWindow: aDialogWindowPresenter [

	aDialogWindowPresenter
		addButton: 'Accept' do: [ self doAccept ]
]

{ #category : #initialization }
StPackageChooserPresenter >> initializeLayout [
	
	self layout: (SpBoxLayout newTopToBottom
		spacing: 5;
		add: (SpPanedLayout newLeftToRight
			add: (SpBoxLayout newLeftToRight
				spacing: 5;
				add: (packageList := (self instantiate: SpFilteringSelectableListPresenter));
				add: (buttonBar := SpBoxLayout newTopToBottom) expand: false;
				yourself);
			add: (selectedPackagesList := (self instantiate: SpFilteringSelectableListPresenter));
			yourself);
		yourself)
]

{ #category : #initialization }
StPackageChooserPresenter >> initializePackageList [
	
	packageList 
		contextMenu: self packageListMenu;
		display: [ :each | each packageName ]
]

{ #category : #initialization }
StPackageChooserPresenter >> initializePresenters [
	<script: 'self new openWithSpec'>

	self initializeLayout.
	self initializePackageList.
	self initalizeSelectedPackageList.
	self initializeButtonBar
]

{ #category : #initialization }
StPackageChooserPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: 'Choose Packages';
		initialExtent: 700@500

]

{ #category : #private }
StPackageChooserPresenter >> packageListMenu [
		
	^ self newMenu
		addItem: [ :item | item name: 'Add selected'; action: [ self addSelected ] ];
		addItem: [ :item | item name: 'Add all'; action: [ self addAll ] ];
		yourself
]

{ #category : #accessing }
StPackageChooserPresenter >> packages [

	^ RPackageOrganizer default packages sorted: #packageName ascending
]

{ #category : #actions }
StPackageChooserPresenter >> removeAll [

	selectedPackagesList items: #().
	packageList items: self packages
]

{ #category : #actions }
StPackageChooserPresenter >> removeSelected [

	packageList items: ((packageList items, selectedPackagesList selectedItems) sorted: #packageName ascending).
	selectedPackagesList items: ((selectedPackagesList items \ selectedPackagesList selectedItems)  sorted: #packageName ascending).
	selectedPackagesList selectItems: #()
]

{ #category : #private }
StPackageChooserPresenter >> selectedPackageListMenu [
		
	^ self newMenu
		addItem: [ :item | item name: 'Remove selected'; action: [ self removeSelected ] ];
		addItem: [ :item | item name: 'Remove all'; action: [ self removeAll ] ];
		yourself
]

{ #category : #initialization }
StPackageChooserPresenter >> updatePresenter [

	packageList items: self packages
]
