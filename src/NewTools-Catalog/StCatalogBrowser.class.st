Class {
	#name : #StCatalogBrowser,
	#superclass : #StPresenter,
	#instVars : [
		'list',
		'description'
	],
	#category : #'NewTools-Catalog'
}

{ #category : #specs }
StCatalogBrowser class >> defaultSpec [

	^ SpPanedLayout newHorizontal 
		add: #list;
		add: #description;
		yourself
]

{ #category : #initialization }
StCatalogBrowser >> initializeWidgets [
	
	list := self newList.
	description := self newLabel
]
