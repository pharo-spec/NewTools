"
A catalog browser
"
Class {
	#name : 'StCatalogBrowser',
	#superclass : 'StPresenter',
	#instVars : [
		'list',
		'description'
	],
	#category : 'NewTools-Catalog',
	#package : 'NewTools-Catalog'
}

{ #category : 'opening' }
StCatalogBrowser class >> open [
	<script>
	self new open
	
]

{ #category : 'layout' }
StCatalogBrowser >> defaultLayout [

	 ^ SpPanedLayout newHorizontal 
		add: #list;
		add: #description;
		yourself
]

{ #category : 'initialization' }
StCatalogBrowser >> initializePresenters [
	
	list := self newList.
	description := self newLabel
]
