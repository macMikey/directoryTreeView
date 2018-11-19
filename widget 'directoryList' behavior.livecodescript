script "widget 'directoryList' behavior"
local fileList #full path list of all the files
local initialized #did we initialize the properties of the tree?


on clearList
   set the arrayData of me to empty
end clearList



on populate thePath, filterFor
   if not initialized then initialize
   put empty into fileList
   directoryWalk thePath, filterFor
   populateTreeView fileList
end populate



private command initialize
   if initialized then exit initialize

   #<mandatory>
      set the pathDelimiter of me to slash
      set the readOnly of me to true
   #</mandatory>

   #<optional>
      set the alternateRowBackgrounds of me to true
      set the arrayStyle of me to false
      set the showBorder of me to true
      set the showSeparator of me to false
      set the sortType of me to "text"
   #</optional>

   put true into initialized
end initialize




private command directoryWalk whatFolder, filterFor
   set the directory to whatFolder
   put the files into theFiles
   sort theFiles
   repeat for each line theFile in theFiles
      if theFile begins with "." then next repeat
      #<filter>
         if filterFor is not empty then
            put char offset(".",theFile)+1 to -1 of theFile into theSuffix
            if theSuffix is not among the items of filterFor then next repeat
         end if #filterFor is not empty
      #</filter>
      put whatFolder & slash & theFile & cr after fileList
   end repeat #for each line x in theFiles
   put the folders into theFolders
   sort theFolders
   repeat for each line theFolder in theFolders
      if theFolder is "." or theFolder is ".." then next repeat
      directoryWalk (whatFolder & slash & theFolder), filterFor
   end repeat #for each line x in theFolders
end directoryWalk



private command populateTreeView withWhat
   #debugx put empty into theArray
   set the itemDelimiter to slash
   set the wholeMatches to true
   repeat for each line theLine in withWhat
      delete char 1 of theLine # opening slash #debugx - in scanhammer this shouldn't happen I don't think
      
      put "["&quote before theLine #beginning of array key
      put quote&"]" after theLine#end of array key
      replace slash with quote&"]["&quote in theLine #slashes delimit what will be array keys
      put "put empty into theArray"&&theLine into toDo  #put empty into theArray["a"]["b"]["c"] - we aren't using the value just the keys to populate the treeView
      try
         do toDo
      catch e
         #skip funky filenames that have issues - e.g. folder icons files choke LC
      end try
   end repeat #for each line theLine in withWhat
   
   set the arrayData of me to theArray
end populateTreeView




##################################################################################################################################
#<treeView events>
   on actionDoubleClick
      # leaf node is double-clicked
      pass actionDoubleClick
   end actionDoubleClick



   on actionInspect
      #action icon clicked in read-only mode
      pass actionInspect
   end actionInspect



   on dataChanged
      #data array changed
      #the property is the arrayData of me
      pass dataChanged
   end dataChanged



   on hiliteChanged
   lock screen
   put slash & the hilitedElement of me into goop
   delete last char of goop #trailing slash b/c not using "value" only using "key"
   set the wholeMatches to true
   if goop is not among the lines of fileList then #it's a directory - in fileList fully-expressed paths appear, but when that is converted to a tree, each directory gets its own line, too.
      lock messages # otherwise hiliteChanged will fire again
      set the hilitedElement of me to 0 #kluge-alert!  setting it to empty throws an error.  0 won't work if there is a "0" directory.  Fixed in 9.0.1 RC1
      exit hiliteChanged
   end if #lineOffset(goop,directoriesList) is not 0 then
   unlock screen
   returnChoice goop
end hiliteChanged



private command returnChoice what
   answer "Modify the returnChoice handler in the behavior script for the directoryList widget to do more than just throw an answer dialog."&cr&what
end returnChoice
#</treeView events>
##################################################################################################################################
