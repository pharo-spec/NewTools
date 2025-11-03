"
I am StSimpleInspectorBuilder.

I help in creating simple key/value inspector panels.

Check my usage (class references) for examples.
"
Class {
	#name : 'StSimpleInspectorBuilder',
	#superclass : 'Object',
	#instVars : [
		'specBuilder',
		'info'
	],
	#category : 'NewTools-Inspector-Model',
	#package : 'NewTools-Inspector',
	#tag : 'Model'
}

{ #category : 'instance creation' }
StSimpleInspectorBuilder class >> on: aSpecBuilder [
	^ self new on: aSpecBuilder; yourself
]

{ #category : 'initialization' }
StSimpleInspectorBuilder >> initialize [ 
	super initialize.
	info := OrderedCollection new
]

{ #category : 'accessing' }
StSimpleInspectorBuilder >> key: key value: value [
	info add: key -> value
]

{ #category : 'initialization' }
StSimpleInspectorBuilder >> on: aSpecBuilder [
	specBuilder := aSpecBuilder 
]

{ #category : 'accessing' }
StSimpleInspectorBuilder >> table [
	| keysColumn valuesColumn |
	keysColumn := SpStringTableColumn title: #key evaluated: [ :anAssociation | anAssociation key ].
	valuesColumn := SpStringTableColumn title: #value evaluated: [ :anAssociation | anAssociation value ].
	^ specBuilder newTable
		addStyle: 'stList';
		addColumn: keysColumn;
		addColumn: valuesColumn;
		items: (info collect: [ :anAssociation | StInspectorAssociationNode hostObject: anAssociation ]);
		yourself
]
