Class {
	#name : 'FLFuelOutTest',
	#superclass : 'TestCase',
	#instVars : [
		'fileName'
	],
	#category : 'NewTools-Fuel-Tests',
	#package : 'NewTools-Fuel-Tests'
}

{ #category : 'running' }
FLFuelOutTest >> tearDown [

	fileName ifNotNil: [ : f | f asFileReference ensureDelete ].
	super tearDown.
]

{ #category : 'tests' }
FLFuelOutTest >> testFuelOutWriteArrayFile [

	| targetObject |

	FileLocator imageDirectory isWritable
		ifFalse: [ ^ self skip ].
	targetObject := { 1 . 2 .  3 } fuelOut.
	fileName := targetObject printString , '.fuel'.
	self assert: fileName asFileReference exists 
]

{ #category : 'tests' }
FLFuelOutTest >> testFuelOutWriteFile [

	| targetObject |
	
	FileLocator imageDirectory isWritable
		ifFalse: [ ^ self skip ].
	targetObject := Object new fuelOut.
	fileName := targetObject printString , '.fuel'.
	self assert: fileName asFileReference exists.
]

{ #category : 'tests' }
FLFuelOutTest >> testFuelOutWriteFileVersioned [

	| firstTargetObject firstTargetObjectFile secondTargetObject |

	FileLocator imageDirectory isWritable
		ifFalse: [ ^ self skip ].	

	(firstTargetObjectFile := 'an Object.fuel' asFileReference) exists
		ifTrue: [ firstTargetObjectFile ensureDelete ].
	firstTargetObject := Object new fuelOut.
	fileName := firstTargetObjectFile nextVersion basename.
		
	secondTargetObject := Object new fuelOut.
	
	self assert: fileName asFileReference exists.

	firstTargetObjectFile ensureDelete.
]

{ #category : 'tests' }
FLFuelOutTest >> testFuelOutWriteFileWithFileSystemDelimiters [

	FileLocator imageDirectory isWritable
		ifFalse: [ ^ self skip ].

	self 
		should: [ '/this/is/a/file/path.txt' fuelOut ] 
		raise: FileDoesNotExistException
		description: 'Users of #fuelOut should ensure a valid printString implementation to serialize the file name'

]
