# directoryTreeView
Uses the Tree View widget to recursively display a directory's contents

## populate thePath {, fileExtensions}
### Parameters
#### thePath
Topmost path to display

#### fileExtensions
Optional comma-delimited list of file extensions that will be included in the list (omit the dot, please)

```dispatch "populate" to widget "DirectoryList" with "/", "pdf"```
