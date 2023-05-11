## R CMD check results
There were no ERRORs,  or WARNINGs. 

Besides the new submission NOTE, there are two NOTES that are only found on Windows (Server 2022, R-devel 64-bit): 

```
* checking for non-standard things in the check directory ... NOTE
Found the following files/directories:
  ''NULL''
```

```
* checking for detritus in the temp directory ... NOTE
Found the following files/directories:
  'lastMiKTeXException'
```

A further NOTE is found on Fedora Linux (R-devel, clang, gfortran) and Ubuntu Linux (20.04.1 LTS, R-release, GCC).

```
* checking HTML version of manual ... NOTE
Skipping checking HTML validation: no command 'tidy' found
```

## Downstream dependencies
There are currently no downstream dependencies for this package.
