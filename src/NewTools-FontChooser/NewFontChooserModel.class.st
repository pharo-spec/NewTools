Class {
	#name : #NewFontChooserModel,
	#superclass : #Model,
	#instVars : [
		'fontList'
	],
	#category : #'NewTools-FontChooser'
}

{ #category : #'instance creation' }
NewFontChooserModel class >> newWithDefaultFamilies [

   ^ self new fontList: LogicalFontManager current defaultFamilies; yourself
]

{ #category : #accessing }
NewFontChooserModel >> fontList [
	^ fontList
]

{ #category : #accessing }
NewFontChooserModel >> fontList: aCollection [ 
	fontList := aCollection
]
