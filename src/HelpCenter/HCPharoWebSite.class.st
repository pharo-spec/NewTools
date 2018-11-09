Class {
	#name : #HCPharoWebSite,
	#superclass : #ComposablePresenter,
	#instVars : [
		'link'
	],
	#category : #HelpCenter
}

{ #category : #specs }
HCPharoWebSite class >> defaultSpec [
	^SpecRowLayout composed
		newRow: [ :row | row add: #link ]; 
		yourself
]

{ #category : #initialization }
HCPharoWebSite >> initializePresenter [

	"link action: [ WebBrowser openOn: 'https://pharo.org/documentation' ]."

]

{ #category : #initialization }
HCPharoWebSite >> initializeWidgets [
	link := self newLabel.
	
	link 
		label: 'Pharo.org Documentation Page';
		color: Color blue
]

{ #category : #accessing }
HCPharoWebSite >> link [
	^ link
]

{ #category : #accessing }
HCPharoWebSite >> link: anObject [
	link := anObject
]
