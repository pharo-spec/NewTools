"
I represent a group of rules in StCritiqueBrowserPresenter tree view.
"
Class {
	#name : #CBCritiquesRuleGroup,
	#superclass : #Object,
	#instVars : [
		'name',
		'rules'
	],
	#category : #'NewTools-CodeCritiques-Utilities'
}

{ #category : #'instance creation' }
CBCritiquesRuleGroup class >> named: aString rules: aCollection [
	^ self new
		  name: aString;
		  rules: (aCollection sorted: [ :a :b | a name < b name ]);
		  yourself
]

{ #category : #enumerating }
CBCritiquesRuleGroup >> do: aBlock [

	rules do: aBlock
]

{ #category : #testing }
CBCritiquesRuleGroup >> isComposite [

	^ true
]

{ #category : #accessing }
CBCritiquesRuleGroup >> name [
	^ name
]

{ #category : #accessing }
CBCritiquesRuleGroup >> name: anObject [
	name := anObject
]

{ #category : #accessing }
CBCritiquesRuleGroup >> rules [
	^ rules
]

{ #category : #accessing }
CBCritiquesRuleGroup >> rules: anObject [
	rules := anObject
]
