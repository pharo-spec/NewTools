"
This is a utility class for printing objects to Text or String.

"
Class {
	#name : #StObjectPrinter,
	#superclass : #Object,
	#classVars : [
		'DisplayStringLength'
	],
	#category : #'NewTools-Inspector-Model'
}

{ #category : #converting }
StObjectPrinter class >> asNonTruncatedTextFrom: anObject [
	"I return a representation of the receiver in which all lines breaks 
	are replaced by spaces. I return a String unless there is an error 
	printing the object. In this case I return a Text highlighted in red."
	^ [ anObject asString replaceAll: String cr with: String space ] 
			on: Exception 
			do: [ 'Error printing' ]
]

{ #category : #converting }
StObjectPrinter class >> asTruncatedTextFrom: anObject [
	"I return a truncated representation of the receiver in which all lines breaks 
	are replaced by spaces. I return a String unless there is an error printing the
	object. In this case I return a Text highlighted in red."
	^ [ ((anObject displayStringLimitedTo: self displayStringLength) copyReplaceAll: String cr with: String space) replaceAll: String lf with: String space ]
		on: Exception
		do: [ :error | self textFromError: error ]
]

{ #category : #settings }
StObjectPrinter class >> displayStringLength [
	^ DisplayStringLength ifNil: [ DisplayStringLength := 100 ]
]

{ #category : #settings }
StObjectPrinter class >> displayStringLength: anInteger [ 
	
	DisplayStringLength := anInteger
]

{ #category : #settings }
StObjectPrinter class >> settingsOn: aBuilder [
	<systemsettings>
		
	(aBuilder setting: #displayStringLength)
		parent: #inspector;
		default: 100;
		target: self;
		description: 'The length of the display string shown in the inspector';
		label: 'Display String length in Collection'
]

{ #category : #converting }
StObjectPrinter class >> textFromError: anError [

	| message |
	message := anError messageText ifEmpty: [ anError class name ].
	^ 'Error printing: ', message
]

{ #category : #printing }
StObjectPrinter >> asNonTruncatedTextFrom: anObject [
	^ self class asNonTruncatedTextFrom: anObject
]

{ #category : #printing }
StObjectPrinter >> asTruncatedTextFrom: anObject [
	^ self class asTruncatedTextFrom: anObject
]
