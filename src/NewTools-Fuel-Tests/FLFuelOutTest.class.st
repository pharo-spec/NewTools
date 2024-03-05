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

	targetObject := #(1 2 3) fuelOut.
	fileName := targetObject printString , '.fuel'.
	self assert: fileName asFileReference exists.

]

{ #category : 'tests' }
FLFuelOutTest >> testFuelOutWriteFile [

	| targetObject |
	targetObject := Object new fuelOut.
	fileName := targetObject printString , '.fuel'.
	self assert: fileName asFileReference exists.
		
]

{ #category : 'tests' }
FLFuelOutTest >> testFuelOutWriteFileVersioned [

	| firstTargetObject firstTargetObjectFilename secondTargetObject |
	
	firstTargetObject := Object new fuelOut.
	firstTargetObjectFilename := firstTargetObject printString , '.fuel'.
	
	secondTargetObject := Object new fuelOut.
	fileName := secondTargetObject printString , '.1.fuel'.
	
	self assert: fileName asFileReference exists.

	firstTargetObjectFilename asFileReference ensureDelete.
]

{ #category : 'tests' }
FLFuelOutTest >> testFuelOutWriteFileWithFileSystemDelimiters [

	self 
		should: [ '/this/is/a/file/path.txt' fuelOut ] 
		raise: FileDoesNotExistException
		description: 'Users of #fuelOut should ensure a valid printString implementation to serialize the file name'

]
