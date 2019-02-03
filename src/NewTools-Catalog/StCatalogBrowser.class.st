Class {
	#name : #StCatalogBrowser,
	#superclass : #ComposablePresenter,
	#instVars : [
		'list',
		'description'
	],
	#category : #'NewTools-Catalog'
}

{ #category : #specs }
StCatalogBrowser class >> defaultSpec [

	^ SpecPanedLayout newHorizontal 
		add: #list;
		add: #description;
		yourself
]

{ #category : #initialization }
StCatalogBrowser >> initializeWidgets [
	
	list := self newList.
	description := self newLabel
]
