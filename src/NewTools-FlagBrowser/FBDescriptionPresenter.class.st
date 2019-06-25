"
Description
--------------------

I am a page of the flag browser to give users a context to the tool.	
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	description:		<aTextPresenter> Text area to explain the purpose of the browser.

"
Class {
	#name : #FBDescriptionPresenter,
	#superclass : #FBPagePresenter,
	#instVars : [
		'description'
	],
	#category : #'NewTools-FlagBrowser-Presenters'
}

{ #category : #specs }
FBDescriptionPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #description;
		yourself
]

{ #category : #specs }
FBDescriptionPresenter class >> icon [
	^ #help
]

{ #category : #accessing }
FBDescriptionPresenter class >> priority [
	^ 20
]

{ #category : #specs }
FBDescriptionPresenter class >> title [
	^ 'Description'
]

{ #category : #initialization }
FBDescriptionPresenter >> initializeWidgets [
	description := self newText.

	description
		disable;
		text:
			'Flags in Pharo are a way to flag methods to retreive later. It is used for example to flag method in which new features need to be added later.
	
To flag a method you need to call the #flag: method inside. This method has no behavior and can take a parameter to explicite the scope of the flag. It is often a symbol such as `#todo`, but it can also be a string or an object.

Example:

```
myMethod
	self flag: #todo. "We need to return a computed value instead of a magic number."
	^ 42
```

Commonly used flags are:

- #todo to mark code that needs work to be done.
- #hack to mark hackish code.
- #broken to mark broken code.
- #clean to mark code that needs cleaning.
- #toCheck to mark code that should be checked later.
- #pharoX to mark code present for compatibility with X being the version of Pharo.

The goal of this browser is to help people finding the flags in their projects.'
]
