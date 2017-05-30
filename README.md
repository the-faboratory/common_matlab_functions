# SharedFunctions
This repository contains general-purpose MATLAB functions. They are generally for reading from excel 
documents and/or plotting.

Coding practices are derived mainly from 
	matlab_style_guidelines.pdf from http://www.datatool.com/prod02.htm 
via matlabcentral 
	http://www.mathworks.com/matlabcentral/fileexchange/2529-matlab-programming-style-guidelines

I generally follow the highlighted points, with a few modifications to streamline with Joran's 
coding style and a few of my personal preferences. Rules are followed "strictly" while Guidelines 
are followed "loosely". I apologize for inconsistencies. Please fix inconsistencies in the source code.


1. (Rule) Variable names (AND FUNCTIONS) should be in mixed case starting with lower case.

2. (Guideline) Variables with a large scope should have meaningful names. Variables with a small scope can have short names.

3. (Guideline) A convention on pluralization should be followed consistently. EX: singular = point, plural = pointArray

4. (Rule) Acronyms, even if normally uppercase, should be mixed or lower case.
Use html, isUsaSpecific, checkTiffFormat()
Avoid hTML, isUSASpecific, checkTIFFFormat()

5. (Rule) Abbreviations in names should be avoided.

6. (Rule) Modularize by using functions. Also, use sections (matlab -> %%[code...]) Code longer than two editor screens is a candidate for partitioning.

7. (Guideline) Structures can be used to avoid long lists of input or output arguments. MATLAB's inputParser class is useful for dealing with long lists of input arguments. (Also, a function used by only one other function should be packaged as its subfunction in the same file.)

8. (Very Guideline. Should implement more.) Avoid mixing input or output code with computation, except for preprocessing, in a single
function. Mixed purpose functions are unlikely to be reusable.

9. (Rule) Complex conditional expressions should be avoided. Introduce temporary logical
variables instead.

10. (Guideline) Content should be kept within the first 80 columns.

11. (Rule) Use Smart Indent before every local AND remote GitHub commit. If an auto-spacing feature is ever added to MATLAB, use this also.

12. (Guidelines) White space -> 
Surround =, &, and| by spaces. Conventional operators can be surrounded by spaces. Commas can be followed by a space. 

Logical groups of statements within a block should be separated by one blank line.

Enhance readability by introducing white space between logical units of a block.
Blocks should be separated by more than one blank line.


Another approach is to use the comment symbolfollowed by a repeated character such as * or -.

Use alignment wherever it enhances readability.

13. (Rule) Comments should add information to the code, in a way that is easy to read. Explain usage. Write comments at the same time as teh code. Address why or how rather than what.

14. (Rule) Comments should have a space between the comment symbol (% in MATLAB) and the comment text. % Start with an upper case letter and end with a period.

15. (Guidelines) Function header comments should describe any side effects, such as plot generation. The last function header comment should restate the function line. This allows the user to glance at the help printout and see the input and output argument usage. Avoid clutter in the help printout of the function header. Add a blank line between header comments that should be printed and other header comments.

16. (Guideline) Vrite the documentation (class diagram, control loop, psuedocode, etc.) first.

17. (Rule) Use source control. For large projects or imporant files, use a complete version control package such as GitHub. For small projects, add change history comments. Ex: % 24 November 1971, D.B. Cooper, exit conditions modified.

18. (Rule) Add a blank line to the end of all files.