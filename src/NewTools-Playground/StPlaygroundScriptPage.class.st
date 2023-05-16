"
This is a special kind of page to point to any script file. 
This can be used to extend open a `StPlaygroundPagePresenter`to be used with any script referenced by a `FileReference`.

Example: 
```
reference := 'script.st' asFileReference.
(StPlaygroundPagePresenter on: (StPlaygroundScriptPage fromReference: reference)) open
```
"
Class {
	#name : #StPlaygroundScriptPage,
	#superclass : #StPlaygroundPage,
	#instVars : [
		'fileReference'
	],
	#category : #'NewTools-Playground-Model'
}

{ #category : #accessing }
StPlaygroundScriptPage >> fileReference [

	^ fileReference
]

{ #category : #initialization }
StPlaygroundScriptPage >> fromReference: aFileReference [

	super fromReference: aFileReference.
	fileReference := aFileReference
]
