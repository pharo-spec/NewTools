Class {
	#name : 'StFBCustomExtensionsFilter',
	#superclass : 'StFBExtensionsFilter',
	#instVars : [
		'extensions',
		'basename'
	],
	#category : 'NewTools-FileBrowser-Filtering',
	#package : 'NewTools-FileBrowser',
	#tag : 'Filtering'
}

{ #category : 'testing' }
StFBCustomExtensionsFilter class >> canBeDefault [

	^ false
]

{ #category : 'accessing - Class' }
StFBCustomExtensionsFilter class >> extensions: aCollection [

	^ self new
		  extensions: aCollection;
		  yourself
]

{ #category : 'accessing - Class' }
StFBCustomExtensionsFilter class >> extensions: aCollection basename: aString [

	^ self new
		  basename: aString;
		  extensions: aCollection;
		  yourself
]

{ #category : 'accessing' }
StFBCustomExtensionsFilter class >> priority [
	^ 20
]

{ #category : 'accessing' }
StFBCustomExtensionsFilter >> basename [

	^ basename ifNil: [ '-' ]
]

{ #category : 'accessing' }
StFBCustomExtensionsFilter >> basename: aString [

	basename := aString
]

{ #category : 'accessing' }
StFBCustomExtensionsFilter >> extensions [

	^ extensions
]

{ #category : 'accessing' }
StFBCustomExtensionsFilter >> extensions: aCollection [

	extensions := aCollection.
	basename ifNil: [ basename := extensions asCommaString ]
]

{ #category : 'initialization' }
StFBCustomExtensionsFilter >> initialize [

	super initialize.
	extensions := #(  )
]
