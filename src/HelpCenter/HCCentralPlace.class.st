Class {
	#name : #HCCentralPlace,
	#superclass : #ComposablePresenter,
	#instVars : [
		'menuComponent',
		'hcbrowserComponent',
		'hcPharoWebSiteComponent'
	],
	#category : #HelpCenter
}

{ #category : #specs }
HCCentralPlace class >> defaultSpec [ 
	"menuComponent hcbrowserComponent"
	^SpecColumnLayout composed
		newRow: [ :row | row add: #menuComponent ] height: 32;
		newRow: [ :row | row add: #hcbrowserComponent ] origin: 0 @ 0 corner: 1 @ 1;
		newRow: [ :row | row add: #hcPharoWebSiteComponent ] height: 32;
		yourself
		
	
]

{ #category : #'world menu' }
HCCentralPlace class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #'Help Center')
		parent: #'New Tools';
		order: 20;
		action: [ self open ];
		iconName: #smallHelpIcon;
		help: 'Explore a list of help topics to learn to use Pharo tools.';
		withSeparatorAfter 
]

{ #category : #specs }
HCCentralPlace class >> open [
	<script>
	
	self new openWithSpec
]

{ #category : #accessing }
HCCentralPlace >> hcPharoWebSiteComponent [
	^ hcPharoWebSiteComponent
]

{ #category : #accessing }
HCCentralPlace >> hcPharoWebSiteComponent: anObject [
	hcPharoWebSiteComponent := anObject
]

{ #category : #accessing }
HCCentralPlace >> hcbrowserComponent [
	^ hcbrowserComponent
]

{ #category : #accessing }
HCCentralPlace >> hcbrowserComponent: anObject [
	hcbrowserComponent := anObject
]

{ #category : #api }
HCCentralPlace >> initialExtent [
	^ 800@600
]

{ #category : #initialization }
HCCentralPlace >> initializePresenter [


]

{ #category : #initialization }
HCCentralPlace >> initializeWidgets [
	menuComponent := self instantiate: HCMenu. 
	hcbrowserComponent := self instantiate: HCBrowser.
	hcPharoWebSiteComponent := self instantiate: HCPharoWebSite.
]

{ #category : #accessing }
HCCentralPlace >> menuComponent [
	^ menuComponent
]

{ #category : #accessing }
HCCentralPlace >> menuComponent: anObject [
	menuComponent := anObject
]

{ #category : #initialization }
HCCentralPlace >> title [ 
	^'Help Center'
]
