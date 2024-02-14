Extension { #name : 'Object' }

{ #category : '*NewTools-Fuel' }
Object >> fuelOut [
	| target validFilename fuelFilename |
	
	validFilename := FilePathEncoder encode: (FileSystem disk 
		checkName: self printString 
		fixErrors: true).
	fuelFilename := (FilePathEncoder decode: validFilename) , '.fuel'.
	target := FileLocator imageDirectory / fuelFilename.
	self serializeToFileNamed: target nextVersion fullName
]
