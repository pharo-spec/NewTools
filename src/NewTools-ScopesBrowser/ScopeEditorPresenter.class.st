Class {
	#name : 'ScopeEditorPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'packagesTree',
		'scope'
	],
	#category : 'NewTools-ScopesBrowser-GUI',
	#package : 'NewTools-ScopesBrowser',
	#tag : 'GUI'
}

{ #category : 'layout' }
ScopeEditorPresenter class >> defaultLayout [
	^ SpBoxLayout newLeftToRight 
		add: (SpBoxLayout newTopToBottom
			   add: #packagesTree
			   expand: true
			   fill: true
			   padding: 0;
			   yourself);
		"add: (SpBoxLayout newTopToBottom
			   add: #packagesTree
			   expand: true
			   fill: true
			   padding: 0;
			   yourself);"
		yourself
]

{ #category : 'instance creation' }
ScopeEditorPresenter class >> open [
	<script>
	self new open
]

{ #category : 'instance creation' }
ScopeEditorPresenter class >> title [
	^ 'Scope Editor'
]

{ #category : 'initialization' }
ScopeEditorPresenter >> initializePresenters [
	packagesTree := self newTreeTable.
]

{ #category : 'initialization' }
ScopeEditorPresenter >> newTreeTable [
	^ super newTreeTable
		beMultipleSelection;
		addColumn: (SpCompositeTableColumn new
			title: 'Packages / Classes / Protocols';
			addColumn: ((SpImageTableColumn 
				evaluated: [ :anElement | self iconNamed: anElement class scopesIconName ])
				width: 300;
				yourself);
			addColumn: (SpStringTableColumn evaluated: #name);
			yourself);
		"addColumn: (SpStringTableColumn 
			title: 'n' 
			evaluated: [ :element | element subelements size asString ]);"
		"addColumn: (SpStringTableColumn 
			title: 'Number of methods' 
			evaluated: [ :class | class methods size asString ]);"
		roots: Smalltalk packages;
		children: [ :aClass | aClass subelements ];
		beResizable;
		"contextMenu: self menu;"
		activateOnDoubleClick;
		whenActivatedDo: [ :selection | packagesTree toggleSelectedItems ].
]
