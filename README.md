# SharedFunctions
## Summary
This repository contains general-purpose MATLAB functions. They are generally for reading from excel 
documents and/or plotting. Its commit history


## Coding Practices
Coding practices are derived mainly from 
	matlab_style_guidelines.pdf from http://www.datatool.com/prod02.htm 
via matlabcentral 
	http://www.mathworks.com/matlabcentral/fileexchange/2529-matlab-programming-style-guidelines

Rules are followed "strictly" while Guidelines are followed "loosely". I apologize for inconsistencies.

1. (Rule) Variable names (AND FUNCTIONS) should be in camelCase starting with lower case, with meaningful names. Acronyms should be avoided, and should be mixed or lower case. Ex: use "isUsaSpecific" instead of "isUSASpecific"

2. (Rule) Modularize by using functions. Also, use sections (matlab -> %%[code...]) Code longer than two editor screens is a candidate for partitioning.

3. (Guideline) Structures can be used to avoid long lists of input or output arguments. MATLAB's inputParser class is useful for dealing with long lists of input arguments. (Also, a function used by only one other function should be packaged as its subfunction in the same file.)

4. (Rule) Complex conditional expressions should be avoided. Introduce temporary logical
variables instead.

5. (Rule) Use Smart Indent before every commit.

6. (Guideline) Whitespace: Surround special symbols by spaces (=, &, | etc.). Add white space between logical units of a block. Blocks should be separated by more than one blank line, or the comment symbol followed by a repeated character such as * or -.

7. (Rule) Comments should consisely add information to the code. Write comments at the same time as the code. Address why or how rather than what.

8. (Rule) Comments should have a space between the comment symbol (% in MATLAB) and the comment text.

9. (Guidelines) Function header comments should consisely describe inputs, outputs, and any side effects, such as plot generation. The last function header comment should restate the function line. This allows the user to glance at the help printout and see the input and output argument usage. Add a blank line between header comments that should be printed and other header comments.

10. (Guideline) Write the documentation (class diagram, control loop, psuedocode, etc.) first.

11. (Rule) Add a blank line to the end of all files.
