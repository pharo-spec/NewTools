Extension { #name : 'ZipArchive' }

{ #category : '*NewTools-Utils-Compression' }
ZipArchive class >> extractAllIn: aFileReferenceOrFileName [
	"Service method to extract all contents of a zip.
	Example: 
		ZipArchive extractAllIn: 'my_file.zip' 
		"
	| directory |

	directory := (StOpenDirectoryPresenter new
		currentDirectory: FileSystem workingDirectory;
		openModal) ifNil: [ ^ self ].

	^ self new
		readFrom: aFileReferenceOrFileName;
		extractAllTo: directory
]
