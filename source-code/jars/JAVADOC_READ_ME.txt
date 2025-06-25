*.javadoc.jar files
----------------
To generate the full javaDoc, simply double-click on the <your_file>.javadoc.jar

NOTE : If the double-click does not work, this is due to the fact that the .jar
file type is not associated to java (.exe). In that case, you can simply 
open a console, cd to this directory and type 'java -jar <your_file>.javadoc.jar
This is assuming that java(.exe) is known by your os. If this is not the case,
you can try by specifying the full path to java.
The extraction will create a sub-directory named <your_file>.javadoc.
You will be able to browse the java doc starting from <your_file>.javadoc/index.html

Merging javadoc in one single file
----------------------------------
This is possible to merge one or multiple javadoc-jar files in one single file.
To do so, use tJavadocMerge in your <tafj_home>/bin directory.
There is 2 different syntax for the tJavadocMerge.

Syntax 1 : tJavadocMerge <directory_of_*.javadoc.jar> [<new_jar_name>]
This wil take all the *.javadoc.jar of the directory specified, and create one big 
.javadoc.jar file in the same directory.
If the new_jar_name is not specified, the name will be "T24.javadoc.jar"
example : ./tJavadocMerge /home/user/myT24/jars ASingleDoc.javadoc.jar

Syntax 2 : tJavadocMerge -merge <List of *.javadoc.jar> -o <new_jar_name>
This one allows you to specify the files you want to merge and the full path of the result.
example 1 : ./tJavadocMerge -merge ./AA_Account.javadoc.jar ./AC_Account.javadoc.jar -o /home/user/doc/Account.javadoc.jar
example 2 : ./tJavadocMerge -merge ./T24/jars/AA*.javadoc.jar /home/user/doc/AA.javadoc.jar
