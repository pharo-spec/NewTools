"
Used to instruct the File Browser to display files with custom file extension(s).

## Example

To display Pharo image files:
```smalltalk
StCustomExtensionsFilter extensions: #( '.image' )`
```
"
Class {
	#name : 'StCustomExtensionsFilter',
	#superclass : 'StExtensionsFilter',
	#instVars : [
		'extensions',
		'basename'
	],
	#category : 'NewTools-FileBrowser-Filtering',
	#package : 'NewTools-FileBrowser',
	#tag : 'Filtering'
}

{ #category : 'testing' }
StCustomExtensionsFilter class >> canBeDefault [

	^ false
]

{ #category : 'accessing - Class' }
StCustomExtensionsFilter class >> extensions: aCollection [

	^ self new
		  extensions: aCollection;
		  yourself
]

{ #category : 'accessing - Class' }
StCustomExtensionsFilter class >> extensions: aCollection basename: aString [

	^ self new
		  basename: aString;
		  extensions: aCollection;
		  yourself
]

{ #category : 'accessing' }
StCustomExtensionsFilter class >> priority [
	^ 20
]

{ #category : 'accessing' }
StCustomExtensionsFilter >> basename [

	^ basename ifNil: [ '-' ]
]

{ #category : 'accessing' }
StCustomExtensionsFilter >> basename: aString [

	basename := aString
]

{ #category : 'accessing' }
StCustomExtensionsFilter >> extensions [

	^ extensions
]

{ #category : 'accessing' }
StCustomExtensionsFilter >> extensions: aCollection [

	extensions := aCollection.
	basename ifNil: [ basename := extensions asCommaString ]
]

{ #category : 'initialization' }
StCustomExtensionsFilter >> initialize [

	super initialize.
	extensions := #(  )
]
