"
Description
--------------------

I am a browser allowing one to browse the flags in the system. 

I can organize them in different ways such as flags by flags parameters, flags by class or flags by packages.
"
Class {
	#name : #FlagBrowser,
	#superclass : #ComposablePresenter,
	#instVars : [
		'tabs'
	],
	#category : #'FlagBrowser-Spec'
}

{ #category : #specs }
FlagBrowser class >> defaultSpec [
	^ SpecBoxLayout newVertical
		add: #tabs;
		yourself
]

{ #category : #'world menu' }
FlagBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #'Flags Browser')
		parent: #'New Tools';
		order: 20;
		action: [ self open ];
		iconName: #breakpoint;
		help: 'Explore the flags in the system.';
		withSeparatorAfter 
]

{ #category : #specs }
FlagBrowser class >> open [
	<script>
	self new openWithSpec
]

{ #category : #initialization }
FlagBrowser >> initializeWidgets [
	tabs := self newNotebook.

	FBPagePresenter allPages do: [ :aPage | tabs addPage: (NotebookPage title: aPage title icon: (self iconNamed: aPage icon) provider: [ self instantiate: aPage ]) ]
]

{ #category : #initialization }
FlagBrowser >> initializeWindow: aWindowPresenter [
	aWindowPresenter title: 'Flags Browser'.
	aWindowPresenter initialExtent: (1000 @ 500) scaledByDisplayScaleFactor
]
