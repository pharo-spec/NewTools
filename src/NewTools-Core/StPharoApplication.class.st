Class {
	#name : #StPharoApplication,
	#superclass : #SpecApplication,
	#instVars : [
		'properties'
	],
	#classVars : [
		'Current'
	],
	#category : #'NewTools-Core'
}

{ #category : #accessing }
StPharoApplication class >> current [ 
	
	^ Current
]

{ #category : #initialization }
StPharoApplication >> initialize [

	super initialize.
	properties := Dictionary new
]

{ #category : #accessing }
StPharoApplication >> properties [

	^ properties
]

{ #category : #accessing }
StPharoApplication >> propertyAt: aKey [

	^ properties at: aKey
]

{ #category : #accessing }
StPharoApplication >> propertyAt: aKey ifAbsent: aBlock [

	properties 
		at: aKey
		ifAbsent: aBlock
]

{ #category : #accessing }
StPharoApplication >> propertyAt: aKey ifAbsentPut: aBlock [

	properties 
		at: aKey
		ifAbsentPut: aBlock
]

{ #category : #accessing }
StPharoApplication >> propertyAt: aKey ifPresent: aBlock [

	properties
		at: aKey 
		ifPresent: aBlock
]

{ #category : #accessing }
StPharoApplication >> propertyAt: aKey ifPresent: aBlock ifAbsent: absentBlock [

	properties
		at: aKey 
		ifPresent: aBlock
		ifAbsent: absentBlock
]

{ #category : #accessing }
StPharoApplication >> propertyAt: aKey ifPresent: aBlock ifAbsentPut: absentBlock [

	properties
		at: aKey 
		ifPresent: aBlock
		ifAbsentPut: absentBlock
]

{ #category : #accessing }
StPharoApplication >> propertyAt: aKey put: aValue [

	properties 
		at: aKey
		put: aValue
]

{ #category : #running }
StPharoApplication >> run [ 

	Current ifNotNil: [ Current close ].
	super run. 
	Current := self
]

{ #category : #'private running' }
StPharoApplication >> start [

	
]

{ #category : #convenience }
StPharoApplication >> useGtk [

	self useBackend: #Gtk with: StPharoGtkConfiguration new
]

{ #category : #convenience }
StPharoApplication >> useMorphic [

	self useBackend: #Morphic
]
